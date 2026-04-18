/// STUBBED — active in v5.
///
/// Handles AI-powered upscaling (2x / 4x) and shadow/detail recovery.
/// Runs after the full simulation pipeline, immediately before export.
class EnhancementService {
  const EnhancementService();

  /// Upscales [inputFilePath] by [scale] (2 or 4).
  ///
  /// Throws [UnimplementedError] until v5.
  Future<String> upscale(String inputFilePath, {int scale = 2}) async {
    throw UnimplementedError('EnhancementService is not active until v5.');
  }

  /// Recovers shadow and highlight detail in [inputFilePath].
  ///
  /// Throws [UnimplementedError] until v5.
  Future<String> recoverDetail(String inputFilePath) async {
    throw UnimplementedError('EnhancementService is not active until v5.');
  }
}
