import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/simulation_presets.dart';
import '../data/film_stocks.dart';
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

  Future<void> simulate() async {
    final editState = ref.read(editStateProvider);
    if (editState == null) return;

    final camera = kSimulationCameras[state.cameraIndex];
    final lens = kSimulationLenses[state.lensIndex];
    final stock =
        state.stockIndex >= 0 ? kFilmStocks[state.stockIndex] : null;

    final prompt = buildSimulationPrompt(
        camera: camera, lens: lens, stock: stock);

    state = state.copyWith(
      status: SimulationStatus.loading,
      clearResult: true,
      clearError: true,
    );

    try {
      final resultPath = await AtlasCloudService().simulateWithUrlFallback(
        imagePath: editState.proxyFilePath,
        prompt: prompt,
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
