import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/device_tier_service.dart';

/// Provides the detected [DeviceTier] for the current device.
///
/// Read once at startup — device tier does not change at runtime.
final deviceTierProvider = Provider<DeviceTier>((ref) {
  return DeviceTierService().detect();
});
