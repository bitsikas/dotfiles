/**
 * Caveman Extension
 *
 * Makes the agent respond in ultra-terse "caveman speak" — cuts output tokens
 * by ~75% while preserving full technical accuracy. Same idea as the external
 * caveman project (github.com/JuliusBrussee/caveman) but implemented natively
 * as a pi extension via system prompt injection.
 *
 * Usage:
 * 1. Place this file in ~/.pi/agent/extensions/
 * 2. Use /caveman to toggle
 * 3. When enabled, the agent responds in terse, broken English
 * 4. /caveman again to disable
 *
 * Compression levels (via /caveman <level>):
 *   lite   — moderately terse
 *   full   — default caveman (no articles, no filler)
 *   ultra  — brutally minimal, one-liners where possible
 *   wenyan — classical Chinese style (experimental)
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type Level = "lite" | "full" | "ultra" | "wenyan";

const PROMPTS: Record<Level, string> = {
  lite: `
IMPORTANT: You are now in CAVEMAN MODE (lite). You must:
- Write concisely — shorter sentences, fewer words
- Skip pleasantries, greetings, and conversational filler
- Keep ALL technical accuracy — code, commands, and file paths MUST be exact
- Prefer showing code or commands over long explanations
`,

  full: `
IMPORTANT: You are now in CAVEMAN MODE (full). You must:
- Speak in terse, broken English like a caveman
- Drop articles (a, an, the), auxiliary verbs (is, are, was), and filler words
- Use short declarative sentences only
- Never use pleasantries, greetings, or conversational padding
- Keep ALL technical accuracy — code, commands, and file paths MUST be exact
- Prefer showing code or commands over explaining them
- Goal: cut output tokens by ~75% while preserving technical correctness
- Example: "file here. edit line 42. done." instead of "I've edited the file at line 42, and it's done now."
`,

  ultra: `
IMPORTANT: You are now in CAVEMAN MODE (ultra). You must:
- Respond in the absolute fewest tokens possible
- One-liners preferred. Two lines maximum.
- No articles, no verbs unless essential, no punctuation beyond what code needs
- Code blocks only when showing the exact change — never explain what code does
- File paths and commands must be exact
- If nothing needs doing, respond with a single word
- Example output style: "bug: line 42 null check missing. fix: add \`if (x == null) return;\`"
`,

  wenyan: `
IMPORTANT: You are now in WENYAN MODE. You must:
- Respond in the style of classical Chinese (文言文) — terse, elegant, minimal characters
- Use classical Chinese grammar and vocabulary
- Code, commands, and file paths remain in their original language (English)
- Combine classical Chinese prose with modern code blocks
- Goal: extreme token efficiency through classical Chinese compression
`,
};

export default function cavemanExtension(pi: ExtensionAPI) {
  let enabled = false;
  let level: Level = "full";

  pi.registerCommand("caveman", {
    description:
      "Toggle caveman compression mode (lite | full | ultra | wenyan). Default: full.",
    handler: async (args, ctx) => {
      if (args.length === 0) {
        // Toggle
        enabled = !enabled;
      } else {
        const arg = args[0].toLowerCase();
        if (arg === "off" || arg === "disable") {
          enabled = false;
        } else if (arg === "on" || arg === "enable") {
          enabled = true;
        } else if (arg in PROMPTS) {
          level = arg as Level;
          enabled = true;
        } else {
          ctx.ui.notify(
            `Unknown caveman level: "${arg}". Use: lite, full, ultra, wenyan, on, off`,
            "warn",
          );
          return;
        }
      }

      if (enabled) {
        ctx.ui.notify(
          `Caveman mode ON (${level}) — responses will be terse`,
          "info",
        );
      } else {
        ctx.ui.notify("Caveman mode OFF — normal responses", "info");
      }
    },
  });

  pi.on("before_agent_start", async (event) => {
    if (!enabled) return;

    return {
      systemPrompt: event.systemPrompt + PROMPTS[level],
    };
  });
}
