import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/logging/logging.dart';
import '../../presentation/providers/ai_assistant_providers.dart';

/// Service for persisting and restoring streaming chat sessions
/// Implements healthcare-compliant session management with proper cleanup
class SessionPersistenceService {
  static const String _sessionsKey = 'ai_assistant_streaming_sessions';
  static const String _activeSessionKey = 'ai_assistant_active_session';
  static const String _conversationStateKey = 'ai_assistant_conversation_state';

  // Healthcare-compliant logger for session management
  final _logger = BoundedContextLoggers.aiAssistant;

  /// Save a streaming session to persistent storage
  Future<void> saveSession(StreamingSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing sessions
      final existingSessions = await getAllSessions();
      
      // Add or update the session
      existingSessions[session.sessionId] = session;
      
      // Clean up old inactive sessions (older than 24 hours)
      final cleanedSessions = _cleanupOldSessions(existingSessions);
      
      // Save updated sessions
      final sessionsJson = cleanedSessions.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      
      await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
      
      _logger.logAiInteraction('Session saved successfully', {
        'sessionId': session.sessionId,
        'conversationId': session.conversationId,
        'isActive': session.isActive,
        'messageCount': session.messageIds.length,
      });
      
    } catch (e) {
      _logger.error('Failed to save session', {
        'sessionId': session.sessionId,
        'error': e.toString(),
      });
      rethrow;
    }
  }

  /// Get all stored sessions
  Future<Map<String, StreamingSession>> getAllSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsString = prefs.getString(_sessionsKey);
      
      if (sessionsString == null) {
        return {};
      }
      
      final sessionsJson = jsonDecode(sessionsString) as Map<String, dynamic>;
      final sessions = <String, StreamingSession>{};
      
      for (final entry in sessionsJson.entries) {
        try {
          sessions[entry.key] = StreamingSession.fromJson(
            entry.value as Map<String, dynamic>,
          );
        } catch (e) {
          _logger.error('Failed to parse session', {
            'sessionId': entry.key,
            'error': e.toString(),
          });
          // Continue with other sessions
        }
      }
      
      return sessions;
      
    } catch (e) {
      _logger.error('Failed to load sessions', {
        'error': e.toString(),
      });
      return {};
    }
  }

  /// Get sessions for a specific conversation
  Future<List<StreamingSession>> getSessionsForConversation(String conversationId) async {
    final allSessions = await getAllSessions();
    return allSessions.values
        .where((session) => session.conversationId == conversationId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Most recent first
  }

  /// Save the current active session
  Future<void> saveActiveSession(StreamingSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeSessionKey, jsonEncode(session.toJson()));
      
      _logger.logAiInteraction('Active session saved', {
        'sessionId': session.sessionId,
        'conversationId': session.conversationId,
      });
      
    } catch (e) {
      _logger.error('Failed to save active session', {
        'sessionId': session.sessionId,
        'error': e.toString(),
      });
    }
  }

  /// Restore the last active session
  Future<StreamingSession?> restoreActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionString = prefs.getString(_activeSessionKey);
      
      if (sessionString == null) {
        return null;
      }
      
      final sessionJson = jsonDecode(sessionString) as Map<String, dynamic>;
      final session = StreamingSession.fromJson(sessionJson);
      
      _logger.logAiInteraction('Active session restored', {
        'sessionId': session.sessionId,
        'conversationId': session.conversationId,
        'isActive': session.isActive,
      });
      
      return session;
      
    } catch (e) {
      _logger.error('Failed to restore active session', {
        'error': e.toString(),
      });
      return null;
    }
  }

  /// Save conversation state for restoration
  Future<void> saveConversationState(String conversationId, Map<String, dynamic> state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateKey = '${_conversationStateKey}_$conversationId';
      
      final stateData = {
        'conversationId': conversationId,
        'timestamp': DateTime.now().toIso8601String(),
        'state': state,
      };
      
      await prefs.setString(stateKey, jsonEncode(stateData));
      
      _logger.logAiInteraction('Conversation state saved', {
        'conversationId': conversationId,
        'stateKeys': state.keys.toList(),
      });
      
    } catch (e) {
      _logger.error('Failed to save conversation state', {
        'conversationId': conversationId,
        'error': e.toString(),
      });
    }
  }

  /// Restore conversation state
  Future<Map<String, dynamic>?> restoreConversationState(String conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateKey = '${_conversationStateKey}_$conversationId';
      final stateString = prefs.getString(stateKey);
      
      if (stateString == null) {
        return null;
      }
      
      final stateData = jsonDecode(stateString) as Map<String, dynamic>;
      final state = stateData['state'] as Map<String, dynamic>;
      
      _logger.logAiInteraction('Conversation state restored', {
        'conversationId': conversationId,
        'stateKeys': state.keys.toList(),
      });
      
      return state;
      
    } catch (e) {
      _logger.error('Failed to restore conversation state', {
        'conversationId': conversationId,
        'error': e.toString(),
      });
      return null;
    }
  }

  /// Clean up inactive sessions (older than 24 hours)
  Map<String, StreamingSession> _cleanupOldSessions(Map<String, StreamingSession> sessions) {
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));
    
    final cleanedSessions = <String, StreamingSession>{};
    int removedCount = 0;
    
    for (final entry in sessions.entries) {
      final session = entry.value;
      final lastActivity = session.lastActivity ?? session.createdAt;
      
      if (lastActivity.isAfter(cutoffTime)) {
        cleanedSessions[entry.key] = session;
      } else {
        removedCount++;
      }
    }
    
    if (removedCount > 0) {
      _logger.logAiInteraction('Old sessions cleaned up', {
        'removedCount': removedCount,
        'remainingCount': cleanedSessions.length,
      });
    }
    
    return cleanedSessions;
  }

  /// Clean up all sessions (for testing or reset)
  Future<void> clearAllSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionsKey);
      await prefs.remove(_activeSessionKey);
      
      // Clean up conversation states
      final keys = prefs.getKeys();
      final conversationStateKeys = keys.where((key) => key.startsWith(_conversationStateKey));
      
      for (final key in conversationStateKeys) {
        await prefs.remove(key);
      }
      
      _logger.logAiInteraction('All sessions cleared', {
        'clearedConversationStates': conversationStateKeys.length,
      });
      
    } catch (e) {
      _logger.error('Failed to clear sessions', {
        'error': e.toString(),
      });
    }
  }

  /// Get session statistics for monitoring
  Future<Map<String, dynamic>> getSessionStatistics() async {
    try {
      final sessions = await getAllSessions();
      
      int activeSessions = 0;
      int inactiveSessions = 0;
      int totalMessages = 0;
      DateTime? oldestSession;
      DateTime? newestSession;
      
      for (final session in sessions.values) {
        if (session.isActive) {
          activeSessions++;
        } else {
          inactiveSessions++;
        }
        
        totalMessages += session.messageIds.length;
        
        if (oldestSession == null || session.createdAt.isBefore(oldestSession)) {
          oldestSession = session.createdAt;
        }
        
        if (newestSession == null || session.createdAt.isAfter(newestSession)) {
          newestSession = session.createdAt;
        }
      }
      
      return {
        'totalSessions': sessions.length,
        'activeSessions': activeSessions,
        'inactiveSessions': inactiveSessions,
        'totalMessages': totalMessages,
        'oldestSession': oldestSession?.toIso8601String(),
        'newestSession': newestSession?.toIso8601String(),
      };
      
    } catch (e) {
      _logger.error('Failed to get session statistics', {
        'error': e.toString(),
      });
      return {};
    }
  }
}
