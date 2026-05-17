import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/device_tier_service.dart';

/// Provides the detected [DeviceTier] for the current device.
///
/// Loads tier definitions from the JSON asset at first access.
/// Read once at startup — device tier does not change at runtime.
final deviceTierProvider = FutureProvider<DeviceTier>((ref) async {
  final service = await DeviceTierService.create();
  return service.detect();
});
