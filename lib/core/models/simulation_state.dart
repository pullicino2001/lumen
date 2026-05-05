enum SimulationStatus { idle, loading, success, error }

class SimulationState {
  const SimulationState({
    this.cameraIndex = 0,
    this.lensIndex = 2,
    this.stockIndex = -1,
    this.status = SimulationStatus.idle,
    this.resultPath,
    this.errorMessage,
  });

  final int cameraIndex;
  final int lensIndex;
  final int stockIndex; // -1 = no film stock override
  final SimulationStatus status;
  final String? resultPath;
  final String? errorMessage;

  SimulationState copyWith({
    int? cameraIndex,
    int? lensIndex,
    int? stockIndex,
    SimulationStatus? status,
    String? resultPath,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return SimulationState(
      cameraIndex: cameraIndex ?? this.cameraIndex,
      lensIndex: lensIndex ?? this.lensIndex,
      stockIndex: stockIndex ?? this.stockIndex,
      status: status ?? this.status,
      resultPath: clearResult ? null : (resultPath ?? this.resultPath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
