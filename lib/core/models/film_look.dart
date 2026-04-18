import 'package:freezed_annotation/freezed_annotation.dart';
import 'prompt_contributor.dart';

part 'film_look.freezed.dart';
part 'film_look.g.dart';

/// Subscription tier a film look belongs to.
enum LookTier { free, pro }

/// A named film look, backed by a .cube LUT file.
///
/// LUT files live in assets/luts/.
/// Naming convention: look_[name]_[variant].cube
@freezed
abstract class FilmLook with _$FilmLook implements PromptContributor {
  const FilmLook._();

  const factory FilmLook({
    /// Unique identifier.
    required String id,

    /// Display name shown in the UI.
    required String name,

    /// Short description of the aesthetic.
    required String description,

    /// Asset path to the .cube LUT file.
    required String lutAssetPath,

    /// Asset path to the preview thumbnail image.
    required String thumbnailAssetPath,

    /// Subscription tier required to use this look.
    @Default(LookTier.free) LookTier tier,

    /// Overall look intensity applied on top of the raw LUT. 0–100.
    @Default(100.0) double intensity,
  }) = _FilmLook;

  factory FilmLook.fromJson(Map<String, dynamic> json) =>
      _$FilmLookFromJson(json);

  @override
  String toPromptFragment() => '';
}
