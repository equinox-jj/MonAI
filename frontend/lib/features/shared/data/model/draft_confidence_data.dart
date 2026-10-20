import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monai/features/shared/domain/entity/draft_confidence.dart';

part 'draft_confidence_data.freezed.dart';
part 'draft_confidence_data.g.dart';

/// The AI's confidence per draft field, as `/ai/*` responses send it.
@freezed
abstract class DraftConfidenceData with _$DraftConfidenceData {
  const factory DraftConfidenceData({
    @JsonKey(name: 'type') double? type,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'wallet') double? wallet,
    @JsonKey(name: 'category') double? category,
    @JsonKey(name: 'date') double? date,
  }) = _DraftConfidenceData;

  factory DraftConfidenceData.fromJson(Map<String, dynamic> json) =>
      _$DraftConfidenceDataFromJson(json);
}

extension DraftConfidenceDataMapper on DraftConfidenceData {
  DraftConfidence toEntity() => DraftConfidence(
    type: type ?? 0,
    amount: amount ?? 0,
    wallet: wallet ?? 0,
    category: category ?? 0,
    date: date ?? 0,
  );
}
