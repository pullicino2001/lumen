import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/camera_profiles.dart';
import '../data/film_stocks.dart';
import '../data/lens_profiles.dart';
import '../models/simulation_state.dart';
import '../providers/edit_state_provider.dart';
import '../services/atlas_cloud_service.dart';

final simulationProvider =
    NotifierProvider<SimulationNotifier, SimulationState>(
  SimulationNotifier.new,
);

class SimulationNotifier extends Notifier<SimulationState> {
  @override
  SimulationState build() => const SimulationState();

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

  Future<void> simulate() async {
    final editState = ref.read(editStateProvider);
    if (editState == null) return;

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
      clearResult: true,
      clearError: true,
    );

    try {
      final resultPath = await AtlasCloudService().simulateWithUrlFallback(
        imagePath: editState.proxyFilePath,
        prompt: prompt,
        strength: state.strength,
      );
      state = state.copyWith(
        status: SimulationStatus.success,
        resultPath: resultPath,
      );
    } on AtlasCloudException catch (e) {
      state = state.copyWith(
        status: SimulationStatus.error,
        errorMessage: e.message,
        clearResult: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: SimulationStatus.error,
        errorMessage: e.toString(),
        clearResult: true,
      );
    }
  }

  void dismiss() {
    state = state.copyWith(
      status: SimulationStatus.idle,
      clearResult: true,
      clearError: true,
    );
  }
}
