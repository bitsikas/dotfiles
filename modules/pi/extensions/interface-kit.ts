/**
 * Interface Kit Extension
 *
 * Registers the interface-kit skill for on-demand loading via /skill:interface-kit.
 * The skill provides an authoritative guide for implementing stunning, accessible,
 * performant UI — covering design engineering philosophy, accessibility standards,
 * animation principles, spatial design, typography, color systems, and component craft.
 *
 * Unlike the other JuliusBrussee extensions, this one is NOT injected as an
 * always-on system prompt (it's ~21KB). Instead, it's registered as a pi skill
 * that loads on-demand when the user invokes /skill:interface-kit or when the
 * agent determines UI implementation guidance is needed.
 *
 * The actual skill content lives at ~/.pi/agent/skills/interface-kit/SKILL.md
 *
 * Based on: https://github.com/JuliusBrussee/skills
 *
 * Usage:
 * 1. Place this file in ~/.pi/agent/extensions/
 * 2. The skill auto-discovers from ~/.pi/agent/skills/interface-kit/
 * 3. Use /skill:interface-kit to load the skill on demand
 * 4. Or use /interface-kit to see info about the skill
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { existsSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const SKILL_DIR = join(homedir(), ".pi", "agent", "skills", "interface-kit");

export default function interfaceKitExtension(pi: ExtensionAPI) {
  // Register the skill path via resources_discover so pi knows about it
  pi.on("resources_discover", async (_event) => {
    const skillExists =
      existsSync(join(SKILL_DIR, "SKILL.md"));

    return {
      skillPaths: skillExists ? [SKILL_DIR] : [],
    };
  });

  // Convenience command to show info about the skill
  pi.registerCommand("interface-kit", {
    description:
      "Show info about the interface-kit skill. Load it with /skill:interface-kit",
    handler: async (_args, ctx) => {
      const skillExists =
        existsSync(join(SKILL_DIR, "SKILL.md"));

      if (skillExists) {
        ctx.ui.notify(
          "Interface Kit skill is available. Use /skill:interface-kit to load the full UI implementation guide (typography, color, spatial design, motion, accessibility, component patterns).",
          "info",
        );
      } else {
        ctx.ui.notify(
          "Interface Kit skill not found at " + SKILL_DIR,
          "warn",
        );
      }
    },
  });
}
