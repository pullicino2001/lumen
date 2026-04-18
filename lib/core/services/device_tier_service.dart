import 'dart:io';
import 'package:logger/logger.dart';

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
/// Detection is based on device model string. The app never crashes or shows
/// errors on a lower tier — it simply offers fewer options.
class DeviceTierService {
  DeviceTierService();

  static final _log = Logger();

  static const _fullTierModels = [
    'pixel 8 pro', 'pixel 9 pro', 'pixel 9 pro xl', 'pixel 9 pro fold',
    'pixel fold',
    'sm-s911', 'sm-s916', 'sm-s918', // S23 series
    'sm-s921', 'sm-s926', 'sm-s928', // S24 series
    'sm-s931', 'sm-s936', 'sm-s938', // S25 series
    'sm-f731', 'sm-f946', 'sm-f956', // Z Flip / Z Fold
  ];

  static const _basicTierKeywords = [
    'android sdk', // emulator
  ];

  /// Returns the [DeviceTier] for the current device.
  DeviceTier detect() {
    if (!Platform.isAndroid) {
      // iOS devices all get standard tier — iOS launch is v6+.
      return DeviceTier.standard;
    }

    final model = _getModelString().toLowerCase();
    _log.d('DeviceTierService: model = "$model"');

    if (_fullTierModels.any((m) => model.contains(m))) {
      return DeviceTier.full;
    }
    if (_basicTierKeywords.any((k) => model.contains(k))) {
      return DeviceTier.basic;
    }
    return DeviceTier.standard;
  }

  // Android MODEL property — readable without platform channels in v1.
  String _getModelString() {
    // Platform.operatingSystemVersion contains the full OS version string on
    // Android. The device model is accessed properly via platform channels in
    // v2+. For v1 we use a best-effort approach via environment.
    return Platform.environment['DEVICE_MODEL'] ??
        Platform.operatingSystemVersion;
  }
}
