import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/subscription_provider.dart';

/// Generate button — visible but disabled until Pro Max (v4).
///
/// Tapping while not Pro Max shows the paywall bottom sheet.
class GenerateButton extends ConsumerWidget {
  const GenerateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProMax = ref.watch(
      subscriptionProvider.select(
        (entitlements) => entitlements.contains('pro_max'),
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isProMax ? null : () => _showPaywall(context),
        icon: const Icon(Icons.auto_awesome),
        label: Text(isProMax ? 'Generate (coming in v4)' : 'Generate — Pro Max'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  void _showPaywall(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _PaywallSheet(),
    );
  }
}

class _PaywallSheet extends StatelessWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'LUMEN Pro Max',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'AI generation is a Pro Max feature — coming in a future update.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
