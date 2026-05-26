# Changelog

All notable changes to this project are documented in this file.

The format is inspired by Keep a Changelog and follows semantic versioning where practical for MVP stages.

## [Unreleased]

## [0.0.1] - 2026-05-25

### Added
- Initial CycleAI MVP application shell with Material 3 and responsive mobile-first layouts.
- Bottom navigation with five primary sections: Dashboard, Tracker, Calendar, Reminders, and Settings.
- Dashboard card grid with 10 actions matching the v0.01 visual target and color system.
- Tracker screen with current cycle summary, circular progress indicator, prediction cards, and period start logging.
- Calendar screen with monthly cycle visualization using period, fertile, and ovulation highlights.
- Calendar date details panel with local notes per day and add-entry flow placeholder.
- Reminders screen with local reminder cards and enable/disable toggles.
- Settings screen with theme toggle, default cycle settings, export placeholder, and version label.
- Core models for cycle data, moods, and reminders.
- Providers for cycle state, mood state, and reminder state.
- SharedPreferences local persistence for all MVP state (no backend).
- Reusable UI widgets for cards, indicators, legend chips, and primary buttons.
- Local storage service and date utility helpers.
- Project script support for web target app launching.

### Changed
- Updated package metadata and description for CycleAI MVP identity.
- Set project version to 0.0.1+1.
- Added dependencies: provider, shared_preferences, table_calendar, intl.

### MVP Scope Notes
- Local-only implementation.
- No authentication.
- No backend or cloud sync.
- No API integrations.
- No notifications.
- No AI calls.
- No analytics or monetization.
