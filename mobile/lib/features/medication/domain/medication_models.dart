/// Medication model
class Medication {
  final String id;
  final String name;
  final String? dosage;
  final String? instructions;
  final String? frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? medicationImage;
  final String? color;
  final String? notes;

  const Medication({
    required this.id,
    required this.name,
    this.dosage,
    this.instructions,
    this.frequency,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.medicationImage,
    this.color,
    this.notes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String?,
      instructions: json['instructions'] as String?,
      frequency: json['frequency'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      medicationImage: json['medication_image'] as String?,
      color: json['color'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'instructions': instructions,
      'frequency': frequency,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'medication_image': medicationImage,
      'color': color,
      'notes': notes,
    };
  }
}

/// Model for creating a new medication
class MedicationCreate {
  final String name;
  final String? dosage;
  final String? instructions;
  final String? frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? medicationImage;
  final String? color;
  final String? notes;

  const MedicationCreate({
    required this.name,
    this.dosage,
    this.instructions,
    this.frequency,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.medicationImage,
    this.color,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'instructions': instructions,
      'frequency': frequency,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'medication_image': medicationImage,
      'color': color,
      'notes': notes,
    };
  }
}

/// Model for updating an existing medication
class MedicationUpdate {
  final String? name;
  final String? dosage;
  final String? instructions;
  final String? frequency;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final String? medicationImage;
  final String? color;
  final String? notes;

  const MedicationUpdate({
    this.name,
    this.dosage,
    this.instructions,
    this.frequency,
    this.startDate,
    this.endDate,
    this.isActive,
    this.medicationImage,
    this.color,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) json['name'] = name;
    if (dosage != null) json['dosage'] = dosage;
    if (instructions != null) json['instructions'] = instructions;
    if (frequency != null) json['frequency'] = frequency;
    if (startDate != null) json['start_date'] = startDate!.toIso8601String();
    if (endDate != null) json['end_date'] = endDate!.toIso8601String();
    if (isActive != null) json['is_active'] = isActive;
    if (medicationImage != null) json['medication_image'] = medicationImage;
    if (color != null) json['color'] = color;
    if (notes != null) json['notes'] = notes;

    return json;
  }
}

/// Type of medication history action
enum MedicationActionType {
  taken,
  skipped,
  scheduled,
  updated,
}

/// Medication history record
class MedicationHistory {
  final String id;
  final String medicationId;
  final MedicationActionType actionType;
  final DateTime timestamp;
  final String? notes;

  const MedicationHistory({
    required this.id,
    required this.medicationId,
    required this.actionType,
    required this.timestamp,
    this.notes,
  });

  factory MedicationHistory.fromJson(Map<String, dynamic> json) {
    return MedicationHistory(
      id: json['id'] as String,
      medicationId: json['medication_id'] as String,
      actionType: _actionTypeFromString(json['action_type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication_id': medicationId,
      'action_type': _actionTypeToString(actionType),
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  static MedicationActionType _actionTypeFromString(String value) {
    switch (value) {
      case 'taken':
        return MedicationActionType.taken;
      case 'skipped':
        return MedicationActionType.skipped;
      case 'scheduled':
        return MedicationActionType.scheduled;
      case 'updated':
        return MedicationActionType.updated;
      default:
        return MedicationActionType.taken;
    }
  }

  static String _actionTypeToString(MedicationActionType type) {
    switch (type) {
      case MedicationActionType.taken:
        return 'taken';
      case MedicationActionType.skipped:
        return 'skipped';
      case MedicationActionType.scheduled:
        return 'scheduled';
      case MedicationActionType.updated:
        return 'updated';
    }
  }
}
