// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OCRMedicationData _$OCRMedicationDataFromJson(Map<String, dynamic> json) =>
    _OCRMedicationData(
      name: json['name'] as String?,
      strength: json['strength'] as String?,
      quantity: json['quantity'] as String?,
      instructions: json['instructions'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$OCRMedicationDataToJson(_OCRMedicationData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'strength': instance.strength,
      'quantity': instance.quantity,
      'instructions': instance.instructions,
      'confidence': instance.confidence,
    };

_OCRFields _$OCRFieldsFromJson(Map<String, dynamic> json) => _OCRFields(
  prescribedBy: json['prescribedBy'] as String?,
  prescribedDate: json['prescribedDate'] as String?,
  pharmacy: json['pharmacy'] as String?,
  medications:
      (json['medications'] as List<dynamic>?)
          ?.map((e) => OCRMedicationData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OCRFieldsToJson(_OCRFields instance) =>
    <String, dynamic>{
      'prescribedBy': instance.prescribedBy,
      'prescribedDate': instance.prescribedDate,
      'pharmacy': instance.pharmacy,
      'medications': instance.medications,
    };

_ProcessingMetadata _$ProcessingMetadataFromJson(Map<String, dynamic> json) =>
    _ProcessingMetadata(
      ocrEngine: json['ocrEngine'] as String,
      processingTime: (json['processingTime'] as num).toDouble(),
      imageQuality: (json['imageQuality'] as num).toDouble(),
      extractionMethod: json['extractionMethod'] as String,
    );

Map<String, dynamic> _$ProcessingMetadataToJson(_ProcessingMetadata instance) =>
    <String, dynamic>{
      'ocrEngine': instance.ocrEngine,
      'processingTime': instance.processingTime,
      'imageQuality': instance.imageQuality,
      'extractionMethod': instance.extractionMethod,
    };

_OCRData _$OCRDataFromJson(Map<String, dynamic> json) => _OCRData(
  extractedText: json['extractedText'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  fields: OCRFields.fromJson(json['fields'] as Map<String, dynamic>),
  processingMetadata: ProcessingMetadata.fromJson(
    json['processingMetadata'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OCRDataToJson(_OCRData instance) => <String, dynamic>{
  'extractedText': instance.extractedText,
  'confidence': instance.confidence,
  'fields': instance.fields,
  'processingMetadata': instance.processingMetadata,
};

_PrescriptionMedication _$PrescriptionMedicationFromJson(
  Map<String, dynamic> json,
) => _PrescriptionMedication(
  name: json['name'] as String,
  strength: json['strength'] as String,
  form: json['form'] as String,
  dosage: json['dosage'] as String,
  quantity: (json['quantity'] as num).toInt(),
  instructions: json['instructions'] as String,
  linkedMedicationId: json['linkedMedicationId'] as String?,
);

Map<String, dynamic> _$PrescriptionMedicationToJson(
  _PrescriptionMedication instance,
) => <String, dynamic>{
  'name': instance.name,
  'strength': instance.strength,
  'form': instance.form,
  'dosage': instance.dosage,
  'quantity': instance.quantity,
  'instructions': instance.instructions,
  'linkedMedicationId': instance.linkedMedicationId,
};

_Prescription _$PrescriptionFromJson(Map<String, dynamic> json) =>
    _Prescription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      prescribedBy: json['prescribedBy'] as String,
      prescribedDate: DateTime.parse(json['prescribedDate'] as String),
      pharmacy: json['pharmacy'] as String?,
      ocrData: json['ocrData'] == null
          ? null
          : OCRData.fromJson(json['ocrData'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      verifiedBy: json['verifiedBy'] as String?,
      medications:
          (json['medications'] as List<dynamic>?)
              ?.map(
                (e) =>
                    PrescriptionMedication.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      verificationStatus:
          $enumDecodeNullable(
            _$VerificationStatusEnumMap,
            json['verificationStatus'],
          ) ??
          VerificationStatus.pending,
      dateIssued: json['dateIssued'] == null
          ? null
          : DateTime.parse(json['dateIssued'] as String),
      extractedMedications:
          (json['extractedMedications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PrescriptionToJson(_Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'prescribedBy': instance.prescribedBy,
      'prescribedDate': instance.prescribedDate.toIso8601String(),
      'pharmacy': instance.pharmacy,
      'ocrData': instance.ocrData,
      'imageUrl': instance.imageUrl,
      'isVerified': instance.isVerified,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verifiedBy': instance.verifiedBy,
      'medications': instance.medications,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'dateIssued': instance.dateIssued?.toIso8601String(),
      'extractedMedications': instance.extractedMedications,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'PENDING',
  VerificationStatus.verified: 'VERIFIED',
  VerificationStatus.rejected: 'REJECTED',
  VerificationStatus.needsReview: 'NEEDS_REVIEW',
};

_CreatePrescriptionRequest _$CreatePrescriptionRequestFromJson(
  Map<String, dynamic> json,
) => _CreatePrescriptionRequest(
  prescribedBy: json['prescribedBy'] as String,
  prescribedDate: DateTime.parse(json['prescribedDate'] as String),
  pharmacy: json['pharmacy'] as String?,
  ocrData: json['ocrData'] == null
      ? null
      : OCRData.fromJson(json['ocrData'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  verifiedBy: json['verifiedBy'] as String?,
  medications:
      (json['medications'] as List<dynamic>?)
          ?.map(
            (e) => PrescriptionMedication.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$CreatePrescriptionRequestToJson(
  _CreatePrescriptionRequest instance,
) => <String, dynamic>{
  'prescribedBy': instance.prescribedBy,
  'prescribedDate': instance.prescribedDate.toIso8601String(),
  'pharmacy': instance.pharmacy,
  'ocrData': instance.ocrData,
  'imageUrl': instance.imageUrl,
  'isVerified': instance.isVerified,
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'verifiedBy': instance.verifiedBy,
  'medications': instance.medications,
};

_PrescriptionOCRResult _$PrescriptionOCRResultFromJson(
  Map<String, dynamic> json,
) => _PrescriptionOCRResult(
  extractedText: json['extractedText'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  extractedMedications:
      (json['extractedMedications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  prescribedBy: json['prescribedBy'] as String?,
  prescribedDate: json['prescribedDate'] == null
      ? null
      : DateTime.parse(json['prescribedDate'] as String),
  pharmacy: json['pharmacy'] as String?,
  medications:
      (json['medications'] as List<dynamic>?)
          ?.map((e) => OCRMedicationData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PrescriptionOCRResultToJson(
  _PrescriptionOCRResult instance,
) => <String, dynamic>{
  'extractedText': instance.extractedText,
  'confidence': instance.confidence,
  'extractedMedications': instance.extractedMedications,
  'prescribedBy': instance.prescribedBy,
  'prescribedDate': instance.prescribedDate?.toIso8601String(),
  'pharmacy': instance.pharmacy,
  'medications': instance.medications,
};

_UpdatePrescriptionRequest _$UpdatePrescriptionRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePrescriptionRequest(
  prescribedBy: json['prescribedBy'] as String?,
  prescribedDate: json['prescribedDate'] == null
      ? null
      : DateTime.parse(json['prescribedDate'] as String),
  pharmacy: json['pharmacy'] as String?,
  ocrData: json['ocrData'] == null
      ? null
      : OCRData.fromJson(json['ocrData'] as Map<String, dynamic>),
  imageUrl: json['imageUrl'] as String?,
  isVerified: json['isVerified'] as bool?,
  verifiedAt: json['verifiedAt'] == null
      ? null
      : DateTime.parse(json['verifiedAt'] as String),
  verifiedBy: json['verifiedBy'] as String?,
  medications: (json['medications'] as List<dynamic>?)
      ?.map((e) => PrescriptionMedication.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdatePrescriptionRequestToJson(
  _UpdatePrescriptionRequest instance,
) => <String, dynamic>{
  'prescribedBy': instance.prescribedBy,
  'prescribedDate': instance.prescribedDate?.toIso8601String(),
  'pharmacy': instance.pharmacy,
  'ocrData': instance.ocrData,
  'imageUrl': instance.imageUrl,
  'isVerified': instance.isVerified,
  'verifiedAt': instance.verifiedAt?.toIso8601String(),
  'verifiedBy': instance.verifiedBy,
  'medications': instance.medications,
};

_OCRProcessingRequest _$OCRProcessingRequestFromJson(
  Map<String, dynamic> json,
) => _OCRProcessingRequest(
  imageUrl: json['imageUrl'] as String?,
  base64Image: json['base64Image'] as String?,
  enhanceImage: json['enhanceImage'] as bool? ?? false,
  extractMedications: json['extractMedications'] as bool? ?? false,
);

Map<String, dynamic> _$OCRProcessingRequestToJson(
  _OCRProcessingRequest instance,
) => <String, dynamic>{
  'imageUrl': instance.imageUrl,
  'base64Image': instance.base64Image,
  'enhanceImage': instance.enhanceImage,
  'extractMedications': instance.extractMedications,
};

_OCRProcessingResult _$OCRProcessingResultFromJson(Map<String, dynamic> json) =>
    _OCRProcessingResult(
      success: json['success'] as bool,
      ocrData: json['ocrData'] == null
          ? null
          : OCRData.fromJson(json['ocrData'] as Map<String, dynamic>),
      extractedMedications:
          (json['extractedMedications'] as List<dynamic>?)
              ?.map(
                (e) =>
                    PrescriptionMedication.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      error: json['error'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$OCRProcessingResultToJson(
  _OCRProcessingResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'ocrData': instance.ocrData,
  'extractedMedications': instance.extractedMedications,
  'error': instance.error,
  'message': instance.message,
};

_PrescriptionResponse _$PrescriptionResponseFromJson(
  Map<String, dynamic> json,
) => _PrescriptionResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : Prescription.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$PrescriptionResponseToJson(
  _PrescriptionResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
  'error': instance.error,
};

_PrescriptionListResponse _$PrescriptionListResponseFromJson(
  Map<String, dynamic> json,
) => _PrescriptionListResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Prescription.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  count: (json['count'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$PrescriptionListResponseToJson(
  _PrescriptionListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
  'total': instance.total,
  'message': instance.message,
  'error': instance.error,
};
