/// Thrown when an [EnhancementService] method is called before v5 ships.
/// Callers should catch this and degrade gracefully rather than crashing.
class EnhancementUnavailableException implements Exception {
  const EnhancementUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'EnhancementUnavailableException: $message';
}

/// STUBBED — active in v5.
///
/// Handles AI-powered upscaling (2x / 4x) and shadow/detail recovery.
/// Runs after the full simulation pipeline, immediately before export.
class EnhancementService {
  const EnhancementService();

  /// Upscales [inputFilePath] by [scale] (2 or 4).
  Future<String> upscale(String inputFilePath, {int scale = 2}) async {
    throw const EnhancementUnavailableException(
        'Upscaling is not active until v5.');
  }

  /// Recovers shadow and highlight detail in [inputFilePath].
  Future<String> recoverDetail(String inputFilePath) async {
    throw const EnhancementUnavailableException(
        'Detail recovery is not active until v5.');
  }
}
