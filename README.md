# EDFViewer-MacOS

A macOS-focused EDF/BDF viewer scaffold using **SwiftUI** for rendering and a clean core boundary intended for **EDFlib** (`edflib.c/.h`) integration.

## What is included

- Swift Package project layout so the repository is runnable and versionable.
- SwiftUI app shell (macOS) with:
  - File open flow (`.edf`, `.bdf`)
  - Channel list panel
  - Waveform rendering area
  - Zoom and pan controls
- Min/Max downsampling renderer (`Canvas`) for responsive waveform drawing.
- `EDFService` abstraction:
  - `MockEDFService` for immediate UI bring-up
  - `EDFLibService` placeholder where real C interop goes

## Current status

This repository now has a practical macOS app skeleton, but real EDF/BDF decode is still a TODO in `EDFLibService`.

That design keeps UI and data-access cleanly separated, so once EDFlib is wired in, the SwiftUI surface should require little-to-no restructuring.

## Run (in this repo)

```bash
swift run EDFViewerMacOS
```

- On **macOS**, this starts the SwiftUI app.
- On **Linux CI/dev containers**, it prints a friendly message because SwiftUI/AppKit are macOS-only.

## Wiring EDFlib in Xcode (recommended next step)

1. Add `edflib.c` + `edflib.h` to your app target.
2. Create a bridging header (if using an Xcode app target) and import `edflib.h`.
3. Implement `EDFLibService` methods:
   - open/close file handle
   - enumerate channels
   - read samples for a viewport
4. Keep the downsampling logic in Swift (already present), or move it to C if profiling justifies it.

## Suggested roadmap

1. Implement `EDFLibService` open + channel metadata.
2. Implement random/semi-random access sample reads for viewport windows.
3. Add annotation lane and cursor tools.
4. Add export pipeline (PNG/SVG/CSV segments).
