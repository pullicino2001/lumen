import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import '../constants.dart';

/// Hardware capability tiers — controls which features are available.
enum DeviceTier {
  /// Full effect stack, RAW support, depth-based bokeh (v3+).
  /// Pixel 8 Pro+, Samsung S23+, Z Fold/Flip.
  full,

  /// Full colour/grain/bloom stack, software vignette only.
  /// Most mid-range Android.
  standard,

  /// Film looks and grain only — no real-time preview.
  /// Older or low-power devices.
  basic,
}

/// Detects the device's hardware capability tier at startup.
///
/// Tier model lists are loaded from [kAssetDeviceTiers] so new devices
/// can be added by updating the JSON asset without changing service code.
/// Falls back to hardcoded defaults if the asset fails to load.
class DeviceTierService {
  DeviceTierService._({
    required List<String> fullTierModels,
    required List<String> basicTierKeywords,
  })  : _fullTierModels = fullTierModels,
        _basicTierKeywords = basicTierKeywords;

  static final _log = Logger();

  // Fallback lists used when the asset cannot be loaded.
  static const _defaultFullTier = [
    'pixel 8 pro', 'pixel 9 pro', 'pixel 9 pro xl', 'pixel 9 pro fold',
    'pixel fold',
    'sm-s911', 'sm-s916', 'sm-s918',
    'sm-s921', 'sm-s926', 'sm-s928',
    'sm-s931', 'sm-s936', 'sm-s938',
    'sm-f731', 'sm-f946', 'sm-f956',
  ];
  static const _defaultBasicTier = ['android sdk'];

  final List<String> _fullTierModels;
  final List<String> _basicTierKeywords;

  /// Loads tier data from [kAssetDeviceTiers] and returns a ready service.
  /// Never throws — falls back to hardcoded defaults on any error.
  static Future<DeviceTierService> create() async {
    try {
      final raw = await rootBundle.loadString(kAssetDeviceTiers);
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final full = (json['full'] as List<dynamic>).cast<String>();
      final basic = (json['basic'] as List<dynamic>).cast<String>();
      return DeviceTierService._(fullTierModels: full, basicTierKeywords: basic);
    } catch (e) {
      _log.w('DeviceTierService: failed to load tier config, using defaults. $e');
      return DeviceTierService._(
        fullTierModels: _defaultFullTier,
        basicTierKeywords: _defaultBasicTier,
      );
    }
  }

  /// Returns the [DeviceTier] for the current device.
  DeviceTier detect() {
    if (!Platform.isAndroid) {
      // iOS devices all get standard tier — iOS launch is v6+.
      return DeviceTier.standard;
    }

    final model = _getModelString().toLowerCase();
    _log.d('DeviceTierService: model = "$model"');

    if (_fullTierModels.any((m) => model.contains(m))) return DeviceTier.full;
    if (_basicTierKeywords.any((k) => model.contains(k))) return DeviceTier.basic;
    return DeviceTier.standard;
  }

  String _getModelString() {
    return Platform.environment['DEVICE_MODEL'] ??
        Platform.operatingSystemVersion;
  }
}
