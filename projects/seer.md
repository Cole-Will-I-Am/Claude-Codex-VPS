# SEER (Ollama Cloud App)

Native SwiftUI AI chat client for iOS and macOS.

## Location

- **Path**: `/root/Ollama-Cloud-App`
- **Repo**: [Cole-Will-I-Am/Ollama-Cloud-App](https://github.com/Cole-Will-I-Am/Ollama-Cloud-App)

## Stack

- SwiftUI + SwiftData + MarkdownUI
- iOS 17+ / macOS 14+ (Sonoma)
- Xcode 16, xcodegen

## Structure

```
OllamaCloud/Sources/
  App/        — Entry point, root navigation, commands
  Models/     — SwiftData models
  Services/   — Streaming chat, code execution, MCP client
  Utils/      — Theme, haptics, config, helpers
  Views/      — All UI (chat, composer, model picker, scaffolds, settings)
backend/      — Optional Node.js relay server
```

## Key Features

- Streaming chat with 100+ cloud models via Ollama
- Reasoning Scaffolds (structured thinking frameworks)
- Inline code execution (Python/JS/Shell on Mac, JS on iOS)
- MCP tool calling on macOS
- Dark-mode-first OLED interface

## VPS Role

Source code cloned for reference/review. Not deployed on this VPS — ships as native app via App Store and direct macOS DMG.

## UX Review

Full frontend/UX review completed 2026-03-19. Key issues identified:
- Hardcoded sheet sizing breaks iPhone SE
- Accessibility gaps (contrast, VoiceOver, focus rings)
- No design token system
- Error recovery actions hidden
- See full review in Claude Code memory
