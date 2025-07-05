/// Background sync models and configuration
class BackgroundSyncModels {}

/// Sync configuration options
class SyncConfiguration {
  final Duration frequency;
  final bool requiresNetworkConnectivity;
  final bool requiresDeviceIdle;
  final bool requiresCharging;
  final Duration retryDelay;
  final int maxRetries;

  const SyncConfiguration({
    this.frequency = const Duration(hours: 6),
    this.requiresNetworkConnectivity = true,
    this.requiresDeviceIdle = false,
    this.requiresCharging = false,
    this.retryDelay = const Duration(minutes: 15),
    this.maxRetries = 3,
  });

  Map<String, dynamic> toJson() => {
        'frequency': frequency.inMilliseconds,
        'requiresNetworkConnectivity': requiresNetworkConnectivity,
        'requiresDeviceIdle': requiresDeviceIdle,
        'requiresCharging': requiresCharging,
        'retryDelay': retryDelay.inMilliseconds,
        'maxRetries': maxRetries,
      };

  factory SyncConfiguration.fromJson(Map<String, dynamic> json) {
    return SyncConfiguration(
      frequency: Duration(milliseconds: json['frequency'] ?? 21600000),
      requiresNetworkConnectivity: json['requiresNetworkConnectivity'] ?? true,
      requiresDeviceIdle: json['requiresDeviceIdle'] ?? false,
      requiresCharging: json['requiresCharging'] ?? false,
      retryDelay: Duration(milliseconds: json['retryDelay'] ?? 900000),
      maxRetries: json['maxRetries'] ?? 3,
    );
  }
}

/// Sync task type
enum SyncTaskType {
  healthData,
  prescriptions,
  notifications,
  general,
}

/// Sync status
enum SyncStatus {
  pending,
  running,
  completed,
  failed,
  cancelled,
}

/// Sync task information
class SyncTask {
  final String id;
  final SyncTaskType type;
  final SyncStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? error;
  final Map<String, dynamic>? data;
  final int retryCount;

  const SyncTask({
    required this.id,
    required this.type,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.error,
    this.data,
    this.retryCount = 0,
  });

  SyncTask copyWith({
    String? id,
    SyncTaskType? type,
    SyncStatus? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? error,
    Map<String, dynamic>? data,
    int? retryCount,
  }) {
    return SyncTask(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      error: error ?? this.error,
      data: data ?? this.data,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'startedAt': startedAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'error': error,
        'data': data,
        'retryCount': retryCount,
      };

  factory SyncTask.fromJson(Map<String, dynamic> json) {
    return SyncTask(
      id: json['id'],
      type: SyncTaskType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SyncTaskType.general,
      ),
      status: SyncStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SyncStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      startedAt:
          json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      error: json['error'],
      data: json['data'],
      retryCount: json['retryCount'] ?? 0,
    );
  }
}

/// Sync statistics
class SyncStatistics {
  final int totalTasks;
  final int pendingTasks;
  final int completedTasks;
  final int failedTasks;
  final DateTime? lastSync;
  final DateTime? nextSync;

  const SyncStatistics({
    required this.totalTasks,
    required this.pendingTasks,
    required this.completedTasks,
    required this.failedTasks,
    this.lastSync,
    this.nextSync,
  });

  Map<String, dynamic> toJson() => {
        'totalTasks': totalTasks,
        'pendingTasks': pendingTasks,
        'completedTasks': completedTasks,
        'failedTasks': failedTasks,
        'lastSync': lastSync?.toIso8601String(),
        'nextSync': nextSync?.toIso8601String(),
      };

  factory SyncStatistics.fromJson(Map<String, dynamic> json) {
    return SyncStatistics(
      totalTasks: json['totalTasks'] ?? 0,
      pendingTasks: json['pendingTasks'] ?? 0,
      completedTasks: json['completedTasks'] ?? 0,
      failedTasks: json['failedTasks'] ?? 0,
      lastSync:
          json['lastSync'] != null ? DateTime.parse(json['lastSync']) : null,
      nextSync:
          json['nextSync'] != null ? DateTime.parse(json['nextSync']) : null,
    );
  }
}

/// Network connectivity status
class NetworkStatus {
  final bool isConnected;
  final String connectionType;
  final bool isMetered;

  const NetworkStatus({
    required this.isConnected,
    required this.connectionType,
    this.isMetered = false,
  });

  Map<String, dynamic> toJson() => {
        'isConnected': isConnected,
        'connectionType': connectionType,
        'isMetered': isMetered,
      };

  factory NetworkStatus.fromJson(Map<String, dynamic> json) {
    return NetworkStatus(
      isConnected: json['isConnected'] ?? false,
      connectionType: json['connectionType'] ?? 'none',
      isMetered: json['isMetered'] ?? false,
    );
  }
}
