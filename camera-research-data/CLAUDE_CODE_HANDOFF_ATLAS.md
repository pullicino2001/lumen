# Claude Code Session — Atlas Cloud Integration (Follow-Up to Handoff #1)

## Context

This is a follow-up to the previous session defined in:
```
/Users/pete/Git/lumen/camera-research-data/CLAUDE_CODE_HANDOFF.md
```

That session wired `toPromptFragment()` into the models and built the `GenerationPromptBuilder`. This session wires the assembled prompt to the Atlas Cloud API, connects it to the Simulate button in the editor, and returns the generated image back into the editor so the user can keep editing.

Read the full project spec first:
```
/Users/pete/Git/lumen/md files/lumen.md
```

---

## The Full Flow to Build

This is the complete user journey that must work by the end of this session:

```
User has a photo open in the editor
        ↓
User selects camera + lens + film stock (or any combination)
        ↓
User taps "Simulate" button
        ↓
App assembles prompt via GenerationPromptBuilder (camera → film stock → lens)
        ↓
App exports current working image as JPEG to a temp file
        ↓
App calls AtlasCloudService.simulateWithUrlFallback(imagePath, prompt)
        ↓
AtlasCloudService posts image + prompt to Atlas Cloud API
        ↓
Atlas Cloud runs the selected AI model (currently Flux Kontext Dev)
        ↓
Atlas Cloud returns the generated image (URL, base64, or binary)
        ↓
AtlasCloudService saves the result to a local temp file, returns the path
        ↓
App loads the returned image path into the editor as the new working image
        ↓
User continues editing the generated image (basic editor, export, etc.)
```

---

## What Already Exists — Read These First

Before writing anything, read these existing files in full:

```
/Users/pete/Git/lumen/lib/core/services/atlas_cloud_service.dart
/Users/pete/Git/lumen/lib/core/services/generation_service.dart
/Users/pete/Git/lumen/lib/core/services/generation_prompt_builder.dart
/Users/pete/Git/lumen/lib/core/providers/edit_state_provider.dart
/Users/pete/Git/lumen/lib/features/editor/widgets/generate_button.dart
/Users/pete/Git/lumen/lib/core/models/edit_state.dart
```

Key facts from reading those files:
- `AtlasCloudService` is substantially implemented — endpoint, auth, image sending, response parsing, and result saving are all there. Do not rewrite it. Only extend if needed.
- `GenerationService` is fully stubbed — throws `UnimplementedError`. This is what needs implementing.
- `GenerateButton` exists but is disabled and shows "coming in v4". This needs activating.
- `EditStateNotifier` has no generation method. One needs adding.
- Atlas Cloud uses `ATLAS_API_KEY` from `.env` via `flutter_dotenv`.

---

## Task 1 — Check and set up the `.env` file

File: `/Users/pete/Git/lumen/.env`

Check if this file exists. If it does not, create it:

```
ATLAS_API_KEY=your_atlas_cloud_api_key_here
```

Also check `/Users/pete/Git/lumen/.gitignore` — make sure `.env` is listed. If it is not, add it. The API key must never be committed to git.

Also check `/Users/pete/Git/lumen/pubspec.yaml` — confirm `flutter_dotenv` is listed as a dependency and that `.env` is listed under `assets`. If either is missing, add them.

---

## Task 2 — Create a `GenerationState` model

**New file:** `/Users/pete/Git/lumen/lib/core/models/generation_state.dart`

This is a simple sealed class (or enum + data class) representing the state of a generation request. It does not need Freezed — keep it simple:

```dart
sealed class GenerationState {
  const GenerationState();
}

/// No generation in progress.
class GenerationIdle extends GenerationState {
  const GenerationIdle();
}

/// Generation is in progress — show loading UI.
class GenerationLoading extends GenerationState {
  const GenerationLoading();
}

/// Generation succeeded. [resultPath] is the local path to the generated image.
class GenerationSuccess extends GenerationState {
  const GenerationSuccess(this.resultPath);
  final String resultPath;
}

/// Generation failed. [message] is a human-readable error description.
class GenerationError extends GenerationState {
  const GenerationError(this.message);
  final String message;
}
```

---

## Task 3 — Create a `GenerationNotifier` Riverpod provider

**New file:** `/Users/pete/Git/lumen/lib/core/providers/generation_provider.dart`

This provider manages the generation lifecycle. It uses `GenerationService` and exposes the `GenerationState`.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/generation_state.dart';
import '../models/edit_state.dart';
import '../services/generation_service.dart';

class GenerationNotifier extends Notifier<GenerationState> {
  @override
  GenerationState build() => const GenerationIdle();

  /// Starts a generation request for the given [editState].
  /// Updates state through Loading → Success or Error.
  Future<void> generate(EditState editState) async {
    state = const GenerationLoading();
    try {
      final service = ref.read(generationServiceProvider);
      final resultPath = await service.generate(editState);
      state = GenerationSuccess(resultPath);
    } catch (e) {
      state = GenerationError(e.toString());
    }
  }

  /// Resets back to idle (e.g. after the result has been loaded into the editor).
  void reset() => state = const GenerationIdle();
}

final generationProvider =
    NotifierProvider<GenerationNotifier, GenerationState>(
        () => GenerationNotifier());
```

---

## Task 4 — Implement `GenerationService`

File: `/Users/pete/Git/lumen/lib/core/services/generation_service.dart`

Replace the stub with a real implementation. The service must:

1. Use `GenerationPromptBuilder` to assemble the prompt from `EditState`
2. Export the current working image to a JPEG temp file if it isn't already a JPEG/PNG on disk (use the `workingFilePath` from `EditState`)
3. Call `AtlasCloudService.simulateWithUrlFallback()` with the image path and assembled prompt
4. Return the result path

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/edit_state.dart';
import '../services/atlas_cloud_service.dart';
import '../services/generation_prompt_builder.dart';

class GenerationService {
  const GenerationService(this._atlasCloud, this._promptBuilder);

  final AtlasCloudService _atlasCloud;
  final GenerationPromptBuilder _promptBuilder;

  /// Assembles a prompt from [state] and submits an img2img request to Atlas Cloud.
  /// Returns the local file path of the generated image.
  Future<String> generate(EditState state) async {
    final prompt = _promptBuilder.build(state);

    if (prompt.isEmpty) {
      throw GenerationException(
          'No prompt could be assembled — select at least one lens profile, film stock, or camera.');
    }

    final imagePath = state.workingFilePath;

    return _atlasCloud.simulateWithUrlFallback(
      imagePath: imagePath,
      prompt: prompt,
      strength: 0.75,
    );
  }
}

class GenerationException implements Exception {
  const GenerationException(this.message);
  final String message;

  @override
  String toString() => 'GenerationException: $message';
}

/// Riverpod provider for GenerationService.
final generationServiceProvider = Provider<GenerationService>((ref) {
  return GenerationService(
    AtlasCloudService(),
    const GenerationPromptBuilder(),
  );
});
```

---

## Task 5 — Add `loadGeneratedResult` to `EditStateNotifier`

File: `/Users/pete/Git/lumen/lib/core/providers/edit_state_provider.dart`

Add a method that loads a generation result (a file path) into the edit state as the new working image. The result replaces the working image but preserves the original — the user can keep editing on top of the generated result.

Add this method to `EditStateNotifier`:

```dart
/// Loads a generated image result back into the editor.
/// 
/// The [resultPath] becomes the new working file. The original source image
/// is preserved in [originalFilePath] — it is never replaced.
/// All effect settings (lens, film stock, etc.) are preserved so the user
/// can continue editing or re-generate.
void loadGeneratedResult(String resultPath) {
  if (state == null) return;
  _pushUndoImmediate();
  state = state!.copyWith(
    workingFilePath: resultPath,
    proxyFilePath: resultPath, // Use the generated image as the new preview too
  );
  _scheduleAutoSave();
}
```

---

## Task 6 — Update `GenerateButton` to actually work

File: `/Users/pete/Git/lumen/lib/features/editor/widgets/generate_button.dart`

The button currently does nothing for Pro Max users. Replace it with a fully working implementation:

Requirements:
- When generation is `GenerationIdle`: show the "Simulate" button, enabled for all users (remove the Pro Max gate for now — that can be re-added in a later session once the feature is confirmed working)
- When generation is `GenerationLoading`: show a loading indicator with "Simulating…" text. The button must be disabled while loading to prevent double-taps.
- When generation is `GenerationSuccess`: automatically call `editStateProvider.loadGeneratedResult(resultPath)` and reset the generation state back to idle. No extra step needed from the user — the result loads automatically.
- When generation is `GenerationError`: show a `SnackBar` with the error message. Reset state to idle after showing it.
- If no lens, film stock, or camera is selected in the current `EditState`, show a brief `SnackBar` telling the user to select at least one profile before simulating.

The button should read "Simulate" (not "Generate") — this better describes what it does: it simulates how the image would look as if shot with the selected combination.

---

## Task 7 — Add a strength slider to the generate button area (optional but recommended)

The `AtlasCloudService.simulateWithUrlFallback()` takes a `strength` parameter (0.0–1.0). This controls how much the AI departs from the original image:
- 0.3–0.5: subtle — colour and grain change, but the image is clearly the same photo
- 0.7–0.8: moderate — significant reinterpretation of texture and rendering
- 0.9–1.0: strong — the AI produces a significantly different version

Consider adding a simple `Slider` widget above the Simulate button with label "Strength" that maps to 0.3–0.95. Default to 0.75. Pass this value into `GenerationNotifier.generate()` and thread it through to `AtlasCloudService`.

This is optional for the first pass — implement it if time allows, skip if it complicates the build.

---

## Task 8 — Wire `GenerationNotifier` into the editor screen

File: `/Users/pete/Git/lumen/lib/features/editor/screens/editor_screen.dart`

Read this file first to understand the existing structure.

Add a listener that watches `generationProvider` for `GenerationSuccess` state and automatically calls `editStateProvider.notifier.loadGeneratedResult()`. This ensures the result loads into the editor as soon as it arrives, regardless of which widget detected the state change.

Use a `ref.listen` in the editor's `ConsumerWidget` or `ConsumerStatefulWidget`:

```dart
ref.listen<GenerationState>(generationProvider, (previous, next) {
  if (next is GenerationSuccess) {
    ref.read(editStateProvider.notifier).loadGeneratedResult(next.resultPath);
    ref.read(generationProvider.notifier).reset();
  }
  if (next is GenerationError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.message)),
    );
    ref.read(generationProvider.notifier).reset();
  }
});
```

---

## Task 9 — Write an integration test for the generation flow

**New file:** `/Users/pete/Git/lumen/test/core/services/generation_service_test.dart`

Write a test that:
1. Creates a mock `AtlasCloudService` that returns a known temp file path without making a real network call
2. Creates a `GenerationService` with the mock
3. Builds an `EditState` with at least a film stock selected (use Portra 400 from `kFilmStocks`)
4. Calls `GenerationService.generate(state)`
5. Asserts it returns a non-empty string (the result path)
6. Prints the assembled prompt so it can be reviewed

Also verify the failure case: an `EditState` with no selections should throw `GenerationException`.

---

## Rules for This Session

- Do not modify `AtlasCloudService` unless a specific bug or missing feature is identified. It is substantially complete — treat it as a dependency.
- The `GenerationService` must use `GenerationPromptBuilder` — do not build a separate prompt inside the service.
- The returned image must be loaded back into the editor automatically without requiring the user to take any extra action.
- The original image must never be overwritten — only `workingFilePath` and `proxyFilePath` in `EditState` are updated.
- All error cases must be handled gracefully with a `SnackBar` message. No crashes.
- Run `flutter analyze` after every file change.
- `flutter build apk --debug` must succeed at the end.

---

## Definition of Done

- [ ] `.env` file exists with `ATLAS_API_KEY` placeholder and is in `.gitignore`
- [ ] `GenerationState` sealed class exists and compiles
- [ ] `GenerationNotifier` provider exists and manages state correctly
- [ ] `GenerationService.generate()` assembles a prompt and calls `AtlasCloudService`
- [ ] `EditStateNotifier.loadGeneratedResult()` exists and loads the returned image
- [ ] "Simulate" button triggers the full flow end to end
- [ ] Loading state shows correctly during the API call
- [ ] Success loads the generated image into the editor automatically
- [ ] Errors show a `SnackBar` and reset state to idle
- [ ] Integration test passes
- [ ] `flutter analyze` clean
- [ ] `flutter build apk --debug` succeeds
