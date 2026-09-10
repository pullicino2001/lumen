// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilmStockImpl _$$FilmStockImplFromJson(
  Map<String, dynamic> json,
) => _$FilmStockImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  tier: $enumDecodeNullable(_$StockTierEnumMap, json['tier']) ?? StockTier.free,
  iso: (json['iso'] as num?)?.toInt() ?? 400,
  code: json['code'] as String? ?? '',
  colourMatrix:
      (json['colourMatrix'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0],
  redCurve:
      (json['redCurve'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [0.02, 0.9, 0.82, 2.0],
  greenCurve:
      (json['greenCurve'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [0.02, 0.9, 0.82, 2.0],
  blueCurve:
      (json['blueCurve'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [0.02, 0.9, 0.82, 2.0],
  shadowHueDeg: (json['shadowHueDeg'] as num?)?.toDouble() ?? 0.0,
  shadowHueStrength: (json['shadowHueStrength'] as num?)?.toDouble() ?? 0.0,
  highlightHueDeg: (json['highlightHueDeg'] as num?)?.toDouble() ?? 0.0,
  highlightHueStrength:
      (json['highlightHueStrength'] as num?)?.toDouble() ?? 0.0,
  halationTint:
      (json['halationTint'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [1.0, 0.35, 0.05],
  intensity: (json['intensity'] as num?)?.toDouble() ?? 85.0,
  promptFragment: json['promptFragment'] as String? ?? '',
);

Map<String, dynamic> _$$FilmStockImplToJson(_$FilmStockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'tier': _$StockTierEnumMap[instance.tier]!,
      'iso': instance.iso,
      'code': instance.code,
      'colourMatrix': instance.colourMatrix,
      'redCurve': instance.redCurve,
      'greenCurve': instance.greenCurve,
      'blueCurve': instance.blueCurve,
      'shadowHueDeg': instance.shadowHueDeg,
      'shadowHueStrength': instance.shadowHueStrength,
      'highlightHueDeg': instance.highlightHueDeg,
      'highlightHueStrength': instance.highlightHueStrength,
      'halationTint': instance.halationTint,
      'intensity': instance.intensity,
      'promptFragment': instance.promptFragment,
    };

const _$StockTierEnumMap = {StockTier.free: 'free', StockTier.pro: 'pro'};
