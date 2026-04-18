/// Every effect model must implement this interface.
///
/// [toPromptFragment] returns a plain-text description of the aesthetic
/// suitable for inclusion in an AI generation prompt. Returns an empty
/// string in v1 — fully implemented in v4 when GenerationService goes live.
abstract interface class PromptContributor {
  String toPromptFragment();
}
