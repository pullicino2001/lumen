import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';

/// Active subscription entitlements.
///
/// In v1 this is a simple in-memory placeholder until a billing SDK is
/// chosen and integrated. [SubscriptionNotifier] exposes the single
/// [hasEntitlement] gate — all tier checks in the app go through here.
class SubscriptionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {}; // free tier — no entitlements by default

  /// Returns true if the user has [entitlementId] active.
  bool hasEntitlement(String entitlementId) => state.contains(entitlementId);

  bool get isPro =>
      hasEntitlement(kEntitlementPro) || hasEntitlement(kEntitlementProMax);

  bool get isProMax => hasEntitlement(kEntitlementProMax);

  // — Dev helpers — remove before release —

  void devGrantPro() => state = {...state, kEntitlementPro};
  void devGrantProMax() =>
      state = {...state, kEntitlementPro, kEntitlementProMax};
  void devRevokeAll() => state = const {};
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, Set<String>>(
  () => SubscriptionNotifier(),
);
