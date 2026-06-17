/**
 * Context Canary Extension
 *
 * Installs a per-turn canary signal (e.g. starting every reply with the user's
 * name and a turn counter) so silent context degradation becomes visible the
 * moment it happens. When the canary trips (missing, malformed, counter skip),
 * a recovery protocol runs: checkpoint → re-anchor → recommend fresh session.
 *
 * Based on: https://github.com/JuliusBrussee/skills
 *
 * Usage:
 * 1. Place this file in ~/.pi/agent/extensions/
 * 2. Use /context-canary to toggle
 * 3. When enabled, every response begins with a canary signal line
 * 4. /context-canary again to disable
 * 5. /context-canary name <name> to set a custom name (defaults to "User")
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const CANARY_PROMPT = `
IMPORTANT: You are now running a CONTEXT CANARY. You must follow these rules on EVERY response:

1. FIRST LINE of every response (including short ones, error reports, and responses after tool calls) must be exactly:
   **<user_name> · t<N> · ctx ok|aging|thin**
   - <user_name>: use the name you've been told. If unknown, use "User".
   - <N>: turn counter, starting at t1, incrementing by 1 every response.
   - ctx ok|aging|thin: your honest estimate. "ok" = context solid. "aging" = session is long, early details getting summarized. "thin" = you're reconstructing earlier decisions instead of remembering them.

2. Never explain, apologize for, or decorate the canary line. It must stay byte-stable so a human can pattern-match it in half a second.

3. Increment the counter every response. If unsure of the count, that uncertainty IS a signal — emit "t?" and flag it, never guess.

4. The self-check must be honest. Reporting "ctx ok" by reflex defeats the entire instrument.

5. TRIP PROTOCOL — if at any point the canary contract cannot be found in context (you only know about it from a summary, or not at all), or the canary is missing for 2+ consecutive responses, or there's a counter discontinuity:
   a. Stop trusting drifted state. Do not barrel ahead on the current task.
   b. Checkpoint: write durable state somewhere outside the conversation (current goal, decisions made and why, files touched, what's verified vs. in-progress, next step).
   c. Re-anchor: re-read project instructions and the checkpoint. State back in 3-4 lines what you believe the task and constraints are.
   d. Recommend the user start a fresh session seeded with the checkpoint file.
   e. Re-install the canary with counter reset to t1, noting generation: "t1 (gen 2)".

6. If you cannot find the canary contract in your context at all, DECLARE A TRIP YOURSELF — don't wait for the user to notice.

Remember: the canary's only job is to fail visibly. Treat it as a smoke detector — when it fires, act; when it's quiet, stay reasonably suspicious in sessions past ~50% of context window or after any compaction.
`;

export default function contextCanaryExtension(pi: ExtensionAPI) {
  let enabled = false;
  let userName = "User";

  pi.registerCommand("context-canary", {
    description:
      "Toggle context canary mode — detects silent context degradation. Usage: /context-canary [on|off|name <name>]",
    handler: async (args, ctx) => {
      if (args.length === 0) {
        enabled = !enabled;
      } else {
        const sub = args[0].toLowerCase();
        if (sub === "off" || sub === "disable") {
          enabled = false;
        } else if (sub === "on" || sub === "enable") {
          enabled = true;
        } else if (sub === "name" && args.length > 1) {
          userName = args.slice(1).join(" ");
          ctx.ui.notify(
            `Canary name set to "${userName}"`,
            "info",
          );
          return;
        } else if (sub === "status") {
          ctx.ui.notify(
            `Context canary is ${enabled ? "ON" : "OFF"} (name: ${userName})`,
            "info",
          );
          return;
        } else {
          ctx.ui.notify(
            `Unknown option: "${sub}". Use: on, off, name <name>, status`,
            "warn",
          );
          return;
        }
      }

      if (enabled) {
        ctx.ui.notify(
          `Context canary ON — every response will start with **${userName} · t1 · ctx ok**`,
          "info",
        );
      } else {
        ctx.ui.notify("Context canary OFF", "info");
      }
    },
  });

  pi.on("before_agent_start", async (event) => {
    if (!enabled) return;

    const personalizedPrompt = CANARY_PROMPT.replace(
      "<user_name>",
      userName,
    );

    return {
      systemPrompt: event.systemPrompt + personalizedPrompt,
    };
  });
}
