# UI Migration Execution Plan

## 1. Purpose

This document is the handoff spec for a brand-new AI with **no conversation context**. It must be enough to implement the requested UI foundation work in the current Flutter project without asking for design intent again.

The target is to migrate a small, reusable subset of the `spotoolfy_flutter` UI patterns into `read_it_later` and adapt them to the read-it-later domain.

This is an implementation document, not a proposal. Follow the order, constraints, file boundaries, and acceptance criteria exactly.

---

## 2. Project Baseline

Current repository: `read_it_later`

Environment observed during analysis:

- Flutter 3.47.1 stable
- Dart 3.13.1
- Android target/compile SDK 36
- Current app uses `MaterialApp.router` with `go_router`
- State management uses Riverpod
- Persistence uses Drift + SQLite
- Article workflow is local-first and already implemented

### Relevant current files

- `lib/app/app.dart`
- `lib/app/app_router.dart`
- `lib/app/app_theme.dart`
- `lib/app/providers.dart`
- `lib/features/articles/presentation/pages/library_page.dart`
- `lib/features/articles/presentation/pages/reader_page.dart`
- `lib/features/articles/presentation/widgets/add_article_sheet.dart`
- `lib/features/articles/presentation/widgets/article_list_tile.dart`
- `lib/features/articles/presentation/widgets/library_empty_state.dart`
- `lib/features/articles/presentation/controllers/save_article_controller.dart`
- `lib/features/articles/data/import/article_html_sanitizer.dart`
- `lib/features/articles/data/import/reader_mode_extractor.dart`
- `lib/features/articles/data/import/default_article_importer.dart`
- `lib/features/articles/data/import/web_page_downloader.dart`
- `test/widget_test.dart`
- `test/features/articles/data/import/article_html_sanitizer_test.dart`

### Existing theme baseline

`lib/app/app_theme.dart` already uses:

```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFF385DA8),
  brightness: brightness,
  dynamicSchemeVariant: DynamicSchemeVariant.expressive,
)
```

This is already the correct direction for a Material 3 Expressive-style palette. Do **not** replace it with a plain `ColorScheme.fromSeed` implementation copied from `spotoolfy_flutter`.

### Existing article UI baseline

Current article pages are already clean and minimal:

- `LibraryPage` shows a list of saved articles.
- `ReaderPage` shows article content rendered through `flutter_widget_from_html_core`.
- `AddArticleSheet` is a mobile bottom sheet form for URL input.

The requested work is not a rewrite. It is a UI foundation upgrade.

---

## 3. Source Project Findings

A local copy of `spotoolfy_flutter` was inspected during analysis. The useful parts are not its music UI itself, but its reusable patterns:

### Worth borrowing

- Responsive layout helpers
- Adaptive modal presentation
- Theme detail based on Material 3 color roles
- Shared axis page transitions
- Small, local `AnimatedSwitcher` usage for state changes

### Not worth borrowing as-is

- Spotify-specific fonts
- Music-player shell layout
- Library grid and carousel layouts tied to albums/playlists
- Wavy dividers and decorative page indicators
- Provider-based selector wrappers for Spotify state
- Any code that depends on audio, playlist, or login workflows

### Important conclusion

`spotoolfy_flutter` does **not** provide a standalone MD3E framework. It uses Flutter Material 3 components and combines them with a responsive shell. The real value here is the layout and motion approach, not a hidden reusable theme library.

---

## 4. Final Scope

The final work must implement these five items:

1. Migrate a **minimal responsive layout foundation**.
2. Make `AddArticleSheet` open as an **adaptive modal page**.
3. Refine `AppTheme` with **MD3 expressive color-role usage**.
4. Add **page transitions** through `go_router`.
5. Add **targeted `AnimatedSwitcher` state transitions**.

### Final product goal

The app should feel like a clean, article-focused Material 3 Expressive app on phones, tablets, and desktops, while keeping the codebase simple and local-first.

---

## 5. Non-Goals

Do not implement or copy these during this task:

- Spotify or music-specific UI patterns
- NavigationRail / bottom navigation shell refactor unless explicitly needed for this app
- Dynamic color extraction from images
- `dynamic_color` package integration
- Any player, carousel, or notes UI from `spotoolfy_flutter`
- WebView-based reading mode
- New data model changes
- New database migrations
- Full app redesign

This task is about UI infrastructure, not article import logic.

---

## 6. Target Architecture

Use the following structure for the new UI foundation:

```text
lib/
  app/
    app.dart
    app_router.dart
    app_theme.dart
    responsive.dart
    responsive_navigation.dart
    app_transitions.dart
    app_animations.dart   (optional, only if shared animation constants become useful)
  features/
    articles/
      presentation/
        pages/
        widgets/
```

### Rule

Keep reusable UI infrastructure in `lib/app/`. Keep article-specific screens in `lib/features/articles/presentation/`.

Do not move business logic into `app/`.

---

## 7. Implementation Plan Overview

Implement in this order:

1. Responsive layout foundation
2. Adaptive modal page wrapper
3. Theme refinement
4. Router page transitions
5. AnimatedSwitcher state transitions
6. Tests and final cleanup

This order matters because each later step depends on the earlier ones.

---

## 8. Step 1 - Minimal Responsive Layout Foundation

### Goal

Add a small, reusable responsive layout system modeled after the useful parts of `spotoolfy_flutter/lib/utils/responsive.dart`, but trimmed to the needs of a read-it-later app.

### New file

- `lib/app/responsive.dart`

### Keep from spotoolfy conceptually

- Breakpoints
- Device type classification
- Page layout specs
- Responsive width / padding decisions
- A simple constrained container for page content

### Do not copy

- Search-specific behavior
- Grid column logic for media libraries
- Preview page layout
- Any music shell code
- Any page types not useful to this app

### Required API shape

Implement a small set of types and helpers such as:

```dart
enum DeviceType {
  compact,
  mobile,
  tablet,
  desktop,
}

enum ResponsivePageType {
  shell,
  browse,
  detail,
  modal,
}

class ResponsiveLayoutSpec {
  final double maxWidth;
  final double horizontalPadding;
  final bool preferTwoPane;
  final double modalWidth;
  final double modalMaxHeightFactor;
}
```

And `BuildContext` helpers such as:

```dart
context.deviceType
context.isLargeScreen
context.isDesktop
context.responsive<T>(...)
context.layoutType(ResponsivePageType type)
```

### Suggested breakpoints

- `compact`: < 350
- `mobile`: 350 to < 600
- `tablet`: 600 to < 900
- `desktop`: >= 900

### Suggested page specs

#### `browse`
Used by the article library list.

- Mobile: full width with 16-20 dp horizontal padding
- Tablet: max width around 800-960 dp
- Desktop: max width around 1100-1200 dp
- Alignment: top center

#### `detail`
Used by the reader page.

- Max content width around 720 dp
- Mobile: 20-24 dp outer padding
- Tablet/Desktop: centered body with wider outer margins

#### `modal`
Used by the add-article UI.

- Mobile: bottom sheet width behavior
- Tablet/Desktop: centered modal width around 520-560 dp
- Height cap around 86-92% of viewport height

#### `shell`
Reserved for future top-level shell work if needed later.

### New widget

Add a lightweight wrapper such as:

```dart
ResponsivePageContainer(
  pageType: ResponsivePageType.detail,
  child: ...,
)
```

Responsibilities:

- Constrain maximum width
- Align content
- Avoid extra padding unless explicitly requested

### Integration points

#### `LibraryPage`
Wrap the body content in `ResponsivePageContainer(pageType: ResponsivePageType.browse)` and use layout padding from the spec.

#### `ReaderPage`
Wrap the readable content in `ResponsivePageContainer(pageType: ResponsivePageType.detail)` or keep the `ConstrainedBox` pattern but derive width from responsive layout constants.

#### `AddArticleSheet`
Use `ResponsivePageType.modal` when presented in an adaptive modal wrapper.

### Acceptance criteria

- Library content stays centered on large screens
- Reader content does not stretch too wide
- Modal content width differs between phone and tablet/desktop
- No overflow on narrow devices
- No new business logic added

---

## 9. Step 2 - Adaptive Modal Page Wrapper

### Goal

Change the article-add flow from a phone-only bottom sheet into an adaptive modal presentation that uses the right surface on each screen size.

### New file

- `lib/app/responsive_navigation.dart`

### Required behavior

#### On phones
Use `showModalBottomSheet` with:

- `isScrollControlled: true`
- `useSafeArea: true`
- `showDragHandle: true`
- rounded top surface
- keyboard-aware bottom inset handling

#### On tablets and desktops
Use `showDialog` or a centered modal panel with:

- constrained width
- surface background
- explicit close affordance
- content that does not depend on bottom-sheet drag interaction

### Suggested public API

Implement a single entry point similar to:

```dart
static Future<T?> showAdaptiveModalPage<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  double? maxWidth,
  bool showCloseButton = true,
  bool showDragHandle = true,
  bool barrierDismissible = true,
  AdaptiveModalContentLayout contentLayout = AdaptiveModalContentLayout.wrapContent,
})
```

### Suggested supporting enum

```dart
enum AdaptiveModalContentLayout {
  wrapContent,
  fillHeight,
}
```

### External rules

Do not put add-article business logic in this wrapper. It only decides:

- which surface to use
- how to constrain the content
- whether to show a close button or drag handle

### AddArticleSheet integration

Current code in `library_page.dart` uses `showModalBottomSheet<int>(...)`. Replace that call with the adaptive wrapper.

`AddArticleSheet` itself should remain the URL entry form. It should not decide whether it is displayed as a bottom sheet or a dialog.

### UI behavior expectations

- Mobile: preserve existing bottom-sheet feel
- Tablet/Desktop: centered modal with good spacing and explicit close action
- Save success should still return the created article ID to the caller
- Dismissal should not break state management or navigation

### Acceptance criteria

- Add article opens as bottom sheet on phones
- Add article opens as centered modal on larger screens
- The returned article ID still navigates to the reader page
- Keyboard and safe-area handling remain correct
- No duplicated outer padding or duplicated titles

---

## 10. Step 3 - Theme Refinement Using MD3 Color Roles

### Goal

Keep the current expressive theme, but make the theme more explicit and consistent in how it uses Material 3 color roles.

### Current baseline

`lib/app/app_theme.dart` already uses a correct expressive seed. The task is not to replace it. The task is to expand and standardize the rest of the theme.

### Recommended theme responsibilities

Update `AppTheme` to configure the following consistently:

- `AppBarTheme`
- `InputDecorationTheme`
- `FloatingActionButtonThemeData`
- `DialogTheme`
- `BottomSheetThemeData`
- `DividerThemeData`
- `FilledButtonThemeData`
- `OutlinedButtonThemeData`
- `CardTheme`
- `ListTileThemeData`

### Recommended color-role usage

Use these roles consistently across the app:

| Area | Color roles |
|---|---|
| App background | `surface` |
| Secondary content blocks | `surfaceContainerLow` |
| Input fields | `surfaceContainerHighest` |
| Primary action | `primary`, `onPrimary` |
| Accent action / FAB | `primaryContainer`, `onPrimaryContainer` |
| Muted metadata | `onSurfaceVariant` |
| Dividers | `outlineVariant` |
| Modal surfaces | `surface` |
| Errors | `error` or `errorContainer` where appropriate |

### Recommended visual rules

- Avoid hard-coded `Colors.grey`, `Colors.black`, and `Colors.white` except in deliberate cases like icons or purely structural paint.
- Keep cards and modal surfaces close to the theme’s surface roles.
- Do not create a dominant monochrome or purple-heavy UI.
- Use shape and spacing to create hierarchy, not just color.

### Likely theme-level updates

#### Input fields
Continue the current rounded, filled input style. Use `surfaceContainerHighest` with a focused border in `primary`.

#### Buttons
Ensure primary actions use `FilledButton` and supporting actions use `OutlinedButton` or `FilledButton.tonal` only where semantically appropriate.

#### Lists
Keep list rows mostly unframed. Use `onSurfaceVariant` for supporting text and `outlineVariant` for separators.

#### Modals
Make bottom sheets and dialogs feel like part of the same system by setting modal surface colors and radius in the theme.

### Integration points

- `LibraryPage`
- `AddArticleSheet`
- `ReaderPage`
- `ArticleListTile`
- `LibraryEmptyState`

### Acceptance criteria

- Theme still uses expressive color generation
- UI roles are consistent across pages
- Light and dark modes both read well
- No regression in input fields, dialogs, or buttons

---

## 11. Step 4 - Page Transitions Through GoRouter

### Goal

Add a consistent transition model for navigation between the article list and article reader.

### New file

- `lib/app/app_transitions.dart`

### Required change

The current router uses `GoRoute.builder`. Replace that with `GoRoute.pageBuilder` so transitions can be controlled.

### Recommended transition model

Use a shared-axis or similar directional transition for article navigation:

- From list to reader: horizontal shared-axis transition
- From reader back to list: reverse transition
- Root page can be simple fade or the same shared-axis style depending on implementation simplicity

### Suggested implementation strategy

Create a helper that returns a `Page` with a transition:

- Keep the page key from `state.pageKey`
- Do not interfere with Riverpod providers
- Do not add custom navigation logic inside page widgets

### Suggested rules

- Respect reduced-motion settings if possible
- Use short durations around 200-300 ms
- Keep the transition subtle; this is an article app, not a flashy media shell

### Route mapping

Current routes remain the same:

- `/` -> `LibraryPage`
- `/article/:id` -> `ReaderPage`

Only the route construction changes.

### Acceptance criteria

- Transition appears when opening an article
- Transition appears when returning from an article
- Invalid IDs still go to the not-found reader state
- No duplicate fetches or navigation side effects

---

## 12. Step 5 - Targeted AnimatedSwitcher Usage

### Goal

Use `AnimatedSwitcher` only where state transitions benefit the user and do not destabilize layout.

### Important rule

Do **not** wrap entire scroll views or the whole app in `AnimatedSwitcher`. Use it only for local state regions.

### Recommended use cases

#### In `LibraryPage`
Animate transitions between:

- loading
- error
- empty
- data

This makes the list screen feel polished without changing the list structure.

#### In `AddArticleSheet`
Animate only local status blocks such as:

- saving progress area
- error message area
- maybe button state if needed

Do not animate the whole form.

#### In `ReaderPage`
Animate only high-level page state transitions such as:

- loading -> content
- loading -> not found

Do not animate the article body paragraph by paragraph.

### Suggested animation style

Use a small, predictable transition such as:

- `FadeTransition`
- `SizeTransition`
- possibly `ScaleTransition` for tiny status chips, but keep it restrained

### Suggested timing

- 180-250 ms for local status changes
- Avoid long easing curves for content that changes often

### Keys

Always give each animated state a stable `Key`, for example:

- `ValueKey('loading')`
- `ValueKey('empty')`
- `ValueKey('error')`
- `ValueKey('data')`

### Acceptance criteria

- Library state changes feel smooth
- Add article status messages do not jump abruptly
- Reader loading does not flash raw layout errors
- No layout overflow introduced by animation

---

## 13. File-by-File Implementation Checklist

### Add new files

- `lib/app/responsive.dart`
- `lib/app/responsive_navigation.dart`
- `lib/app/app_transitions.dart`
- `lib/app/app_animations.dart` only if shared constants are actually needed

### Modify existing files

- `lib/app/app.dart`
- `lib/app/app_router.dart`
- `lib/app/app_theme.dart`
- `lib/features/articles/presentation/pages/library_page.dart`
- `lib/features/articles/presentation/pages/reader_page.dart`
- `lib/features/articles/presentation/widgets/add_article_sheet.dart`
- `lib/features/articles/presentation/widgets/library_empty_state.dart` if theme spacing needs alignment
- `lib/features/articles/presentation/widgets/article_list_tile.dart` if theme colors or width rules need alignment

### Do not modify unless required by tests

- database schema files
- importer business logic
- reader-mode extraction logic
- controller logic

---

## 14. Exact Integration Expectations

### `LibraryPage`

Current shape:

- `Scaffold`
- `AppBar`
- body contains `articles.when(...)`
- `FloatingActionButton.extended`

After migration:

- Keep the same page structure
- Add responsive content width
- Add AnimatedSwitcher for loading/error/empty/data state changes
- Call adaptive modal instead of plain bottom sheet

### `AddArticleSheet`

Current shape:

- URL text field
- paste icon
- save button
- progress line
- error line

After migration:

- Keep the same fields and behavior
- Make the outer presentation adaptive via the new modal wrapper
- Keep keyboard handling correct
- Keep the save controller untouched

### `ReaderPage`

Current shape:

- `SelectionArea`
- `SingleChildScrollView`
- `ConstrainedBox(maxWidth: 720)`
- `HtmlWidget`

After migration:

- Keep the same data model and route behavior
- Derive width and padding from responsive helpers or theme constants
- Add transition-friendly state handling
- Add richer HTML styling hooks if needed by separate tasks

### `AppTheme`

Current shape:

- expressive seed
- input decoration
- FAB theme
- divider theme

After migration:

- Add modal, button, list, and card-related theme details
- Keep expressive seed and Material 3 enabled
- Keep the typography readable

### `GoRouter`

Current shape:

- route builders returning widgets directly

After migration:

- use `pageBuilder`
- route transitions come from app transition helper
- preserve existing route paths

---

## 15. Testing Plan

### Required commands

Run these after implementation:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

If the project builds an app target in the current environment, also run:

```powershell
flutter build apk --debug
```

### Required test coverage

#### Responsive layout tests
- narrow phone width
- normal phone width
- tablet width
- desktop width
- text scaling behavior

#### Modal presentation tests
- phone uses bottom sheet
- tablet/desktop uses dialog
- save success still returns article ID

#### Theme tests
- light mode
- dark mode
- input field focus / disabled / error
- modal surface and button appearance

#### Transition tests
- list to reader
- reader back to list
- invalid article ID

#### AnimatedSwitcher tests
- library loading / empty / error / data states
- add article saving and error states
- reader loading / content / not found states

### Regression risks to test manually

- Keyboard overlap in add-article form
- Overflow on narrow phone screens
- Excessive width on desktop
- Back navigation after transitions
- Existing article save flow after modal refactor

---

## 16. Acceptance Criteria

The task is complete only if all of the following are true:

1. A minimal responsive layout foundation exists in `lib/app/` and is used by the article pages.
2. `AddArticleSheet` opens as an adaptive modal surface, not only as a mobile bottom sheet.
3. `AppTheme` uses expressive color roles consistently and still feels like Material 3.
4. GoRouter routes use page transitions instead of plain widget builders.
5. `AnimatedSwitcher` is used for local state transitions only, not as a blanket wrapper.
6. Existing article save and reader flows still work.
7. `flutter analyze` passes.
8. `flutter test` passes.
9. No unrelated business logic is rewritten.

---

## 17. Implementation Order for the Next AI

Follow this exact order:

1. Read the current files listed in Section 2.
2. Add `lib/app/responsive.dart`.
3. Wire `LibraryPage` and `ReaderPage` to the responsive helpers.
4. Add `lib/app/responsive_navigation.dart`.
5. Replace the bottom-sheet call in `LibraryPage` with the adaptive modal call.
6. Expand `AppTheme` with explicit Material 3 color-role usage.
7. Add `lib/app/app_transitions.dart` and switch `GoRouter` to `pageBuilder`.
8. Add localized `AnimatedSwitcher` states in `LibraryPage`, `AddArticleSheet`, and `ReaderPage`.
9. Run format, analyze, and tests.
10. Fix any regressions without expanding scope.

---

## 18. What the next AI must not do

- Do not delete the existing `TEXT_RENDERING_REFACTOR_PLAN.md`.
- Do not touch the article import logic for this task.
- Do not copy spotoolfy player or library code wholesale.
- Do not introduce new architecture layers.
- Do not redesign the app navigation shell.
- Do not add unrelated features while completing the UI migration.

---

## 19. Handoff Notes

This app is a local-first read-it-later product. The requested work is about making the UI foundation feel intentional and adaptive, not about changing article storage or parsing.

The safest strategy is:

- keep the current business logic
- build a small reusable UI foundation in `lib/app/`
- use Material 3 expressive color roles consistently
- keep animation local and restrained
- verify each step with tests

If a choice is unclear, prefer the simplest option that preserves the current read-it-later flow.
