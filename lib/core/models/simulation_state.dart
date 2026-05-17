enum SimulationStatus { idle, loading, success, error }

class SimulationState {
  const SimulationState({
    this.cameraIndex = 0,
    this.lensIndex = 0,
    this.stockIndex = -1,
    this.strength = 0.75,
    this.status = SimulationStatus.idle,
    this.elapsedSeconds = 0,
    this.resultPath,
    this.errorMessage,
  });

  final int cameraIndex;
  final int lensIndex;
  final int stockIndex; // -1 = no film stock override
  /// How much the AI departs from the original image. 0.3 = subtle, 0.95 = strong.
  final double strength;
  final SimulationStatus status;
  /// Seconds elapsed since the current generation started. 0 when not loading.
  final int elapsedSeconds;
  final String? resultPath;
  final String? errorMessage;

  SimulationState copyWith({
    int? cameraIndex,
    int? lensIndex,
    int? stockIndex,
    double? strength,
    SimulationStatus? status,
    int? elapsedSeconds,
    String? resultPath,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return SimulationState(
      cameraIndex: cameraIndex ?? this.cameraIndex,
      lensIndex: lensIndex ?? this.lensIndex,
      stockIndex: stockIndex ?? this.stockIndex,
      strength: strength ?? this.strength,
      status: status ?? this.status,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      resultPath: clearResult ? null : (resultPath ?? this.resultPath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
