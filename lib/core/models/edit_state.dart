import 'package:freezed_annotation/freezed_annotation.dart';
import 'basic_editor_settings.dart';
import 'bloom_settings.dart';
import 'film_stock.dart';
import 'grain_settings.dart';
import 'import_profile.dart';
import 'lens_profile.dart';

part 'edit_state.freezed.dart';
part 'edit_state.g.dart';

/// The complete non-destructive edit state for a single photo session.
///
/// This is the single object that flows through the entire pipeline.
/// The original file is never modified — [originalFilePath] is read-only.
/// [workingFilePath] points to the decoded working-format copy in temp storage.
@freezed
abstract class EditState with _$EditState {
  const EditState._();

  const factory EditState({
    /// Path to the original imported file. Never modified.
    required String originalFilePath,

    /// Path to the decoded working copy in app temp storage. Used for export only.
    required String workingFilePath,

    /// Path to the downscaled JPEG proxy. Used for all live preview rendering.
    required String proxyFilePath,

    /// Basic editor adjustments — applied as a separate shader pass.
    @Default(BasicEditorSettings()) BasicEditorSettings basicEditor,

    /// Active lens profile. Null means lens layer is bypassed.
    LensProfile? lensProfile,

    /// Active film stock. Null means the stock layer is bypassed.
    FilmStock? filmStock,

    /// Grain simulation parameters.
    @Default(GrainSettings()) GrainSettings grain,

    /// Bloom and halation parameters.
    @Default(BloomSettings()) BloomSettings bloom,

    // — Layer toggles —

    @Default(true) bool lensEnabled,
    @Default(true) bool stockEnabled,
    @Default(true) bool grainEnabled,
    @Default(true) bool bloomEnabled,
    @Default(true) bool basicEditorEnabled,

    // — LUMEN Look —

    /// Whether the LUMEN colour-science rendering is active.
    @Default(ImportProfile.lumen) ImportProfile importProfile,

    /// Path to the LUMEN-processed proxy JPEG. Null until generation completes.
    @Default(null) String? lumenProxyPath,

    // — Generation (v4) —

    /// Path to a generated image returned from the AI service.
    /// Non-null only after a successful Pro Max generation.
    @Default(null) String? generatedFilePath,
  }) = _EditState;

  factory EditState.fromJson(Map<String, dynamic> json) =>
      _$EditStateFromJson(json);

  /// True if this edit session includes an AI-generated image.
  bool get hasGeneratedImage => generatedFilePath != null;
}
