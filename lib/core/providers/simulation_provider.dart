import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/camera_profiles.dart';
import '../data/film_stocks.dart';
import '../data/lens_profiles.dart';
import '../models/simulation_state.dart';
import '../providers/edit_state_provider.dart';
import '../services/atlas_cloud_service.dart';
import '../services/generation_service.dart';

final simulationProvider =
    NotifierProvider<SimulationNotifier, SimulationState>(
  SimulationNotifier.new,
);

class SimulationNotifier extends Notifier<SimulationState> {
  bool _cancelled = false;
  Timer? _elapsedTimer;

  @override
  SimulationState build() {
    ref.onDispose(() => _elapsedTimer?.cancel());
    return const SimulationState();
  }

  void selectCamera(int index) {
    state = state.copyWith(
      cameraIndex: index,
      status: SimulationStatus.idle,
      clearResult: true,
      clearError: true,
    );
  }

  void selectLens(int index) {
    state = state.copyWith(
      lensIndex: index,
      status: SimulationStatus.idle,
      clearResult: true,
      clearError: true,
    );
  }

  void selectStock(int index) {
    state = state.copyWith(
      stockIndex: index,
      status: SimulationStatus.idle,
      clearResult: true,
      clearError: true,
    );
  }

  void setStrength(double value) {
    state = state.copyWith(strength: value);
  }

  /// Cancels an in-progress generation. No-op if not loading.
  void cancel() {
    if (state.status != SimulationStatus.loading) return;
    _cancelled = true;
    _elapsedTimer?.cancel();
    state = state.copyWith(
      status: SimulationStatus.idle,
      elapsedSeconds: 0,
      clearResult: true,
      clearError: true,
    );
  }

  Future<void> simulate() async {
    final editState = ref.read(editStateProvider);
    if (editState == null) return;

    _cancelled = false;
    _elapsedTimer?.cancel();

    final camera = kCameraProfiles[state.cameraIndex.clamp(0, kCameraProfiles.length - 1)];
    final lens = kLensProfiles[state.lensIndex.clamp(0, kLensProfiles.length - 1)];
    final stock = state.stockIndex >= 0 && state.stockIndex < kFilmStocks.length
        ? kFilmStocks[state.stockIndex]
        : null;

    final parts = <String>[
      camera.toPromptFragment(),
      if (stock != null) stock.toPromptFragment(),
      lens.toPromptFragment(),
    ].where((s) => s.isNotEmpty).toList();
    final prompt = parts.join(', ');

    state = state.copyWith(
      status: SimulationStatus.loading,
      elapsedSeconds: 0,
      clearResult: true,
      clearError: true,
    );

    // Tick elapsed time every second while loading.
    final startTime = DateTime.now();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == SimulationStatus.loading) {
        state = state.copyWith(
          elapsedSeconds: DateTime.now().difference(startTime).inSeconds,
        );
      }
    });

    try {
      // Use the config-aware AtlasCloudService from the provider when available,
      // falling back to a default instance gracefully.
      AtlasCloudService atlas;
      try {
        atlas = await ref.read(atlasCloudServiceProvider.future);
      } catch (_) {
        atlas = AtlasCloudService();
      }

      final resultPath = await atlas.simulateWithUrlFallback(
        imagePath: editState.proxyFilePath,
        prompt: prompt,
        strength: state.strength,
        isCancelled: () => _cancelled,
      );

      _elapsedTimer?.cancel();
      state = state.copyWith(
        status: SimulationStatus.success,
        elapsedSeconds: 0,
        resultPath: resultPath,
      );
    } on AtlasCloudCancelledException {
      _elapsedTimer?.cancel();
      // State was already reset by cancel(); nothing more to do.
    } on AtlasCloudException catch (e) {
      _elapsedTimer?.cancel();
      state = state.copyWith(
        status: SimulationStatus.error,
        elapsedSeconds: 0,
        errorMessage: e.message,
        clearResult: true,
      );
    } catch (e) {
      _elapsedTimer?.cancel();
      state = state.copyWith(
        status: SimulationStatus.error,
        elapsedSeconds: 0,
        errorMessage: e.toString(),
        clearResult: true,
      );
    }
  }

  void dismiss() {
    state = state.copyWith(
      status: SimulationStatus.idle,
      elapsedSeconds: 0,
      clearResult: true,
      clearError: true,
    );
  }
}
