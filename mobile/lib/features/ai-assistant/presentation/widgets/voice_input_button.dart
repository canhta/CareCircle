import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/design/design_tokens.dart';
import '../providers/ai_assistant_providers.dart';

class VoiceInputButton extends ConsumerStatefulWidget {
  final Function(String) onVoiceInput;

  const VoiceInputButton({super.key, required this.onVoiceInput});

  @override
  ConsumerState<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends ConsumerState<VoiceInputButton>
    with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isAvailable = false;
  String _recognizedText = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );

      if (mounted) {
        setState(() {
          _isAvailable = available;
        });
      }
    } catch (e) {
      debugPrint('Speech initialization error: $e');
    }
  }

  void _onSpeechStatus(String status) {
    debugPrint('Speech status: $status');

    if (mounted) {
      setState(() {
        _isListening = status == 'listening';
      });

      // Update voice recording state
      ref.read(voiceRecordingProvider.notifier).state = _isListening;

      if (_isListening) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  void _onSpeechError(dynamic error) {
    debugPrint('Speech error: $error');

    if (mounted) {
      setState(() {
        _isListening = false;
      });

      ref.read(voiceRecordingProvider.notifier).state = false;
      _animationController.stop();
      _animationController.reset();

      _showError('Voice recognition error: ${error.toString()}');
    }
  }

  Future<void> _startListening() async {
    if (!_isAvailable) {
      _showError('Speech recognition not available');
      return;
    }

    try {
      setState(() {
        _recognizedText = '';
      });

      await _speech.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US', // TODO: Support Vietnamese
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        ),
      );
    } catch (e) {
      _showError('Failed to start listening: ${e.toString()}');
    }
  }

  void _onSpeechResult(dynamic result) {
    if (mounted) {
      setState(() {
        _recognizedText = result.recognizedWords;
      });

      // If speech is finalized and we have text, send it
      if (result.finalResult && _recognizedText.isNotEmpty) {
        widget.onVoiceInput(_recognizedText);
        setState(() {
          _recognizedText = '';
        });
      }
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speech.stop();

      // Send the recognized text if we have any
      if (_recognizedText.isNotEmpty) {
        widget.onVoiceInput(_recognizedText);
        setState(() {
          _recognizedText = '';
        });
      }
    } catch (e) {
      _showError('Failed to stop listening: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show recognized text preview
        if (_recognizedText.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CareCircleDesignTokens.primaryMedicalBlue.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _recognizedText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CareCircleDesignTokens.primaryMedicalBlue,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Voice input button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? _scaleAnimation.value : 1.0,
              child: GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isListening
                        ? Colors.red
                        : CareCircleDesignTokens.primaryMedicalBlue,
                    shape: BoxShape.circle,
                    boxShadow: _isListening
                        ? [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            );
          },
        ),

        // Status text
        if (_isListening)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Listening...',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: 10),
            ),
          ),
      ],
    );
  }
}
