# Claude Code on your phone: Remote Control guide

Reviewed on 1 Nov 2026 with Claude Code 2.1.316. Full page: https://ctrlia.dev/en/recetas/remote-control-movil.html

## Four official ways to use Claude Code from your phone

There is no separate Claude Code app: everything lives in the **Code** tab of the Claude app for iOS and Android (on iPad, the same iOS app). According to the [official documentation](https://code.claude.com/docs/en/mobile) there are four options:

| Option | Where the code runs | If you turn off the PC | When to use it |
| --- | --- | --- | --- |
| Cloud session | Anthropic's infrastructure | Keeps working | Long task with the repository on GitHub |
| Remote Control | Your PC | Stops (reconnects when it wakes from sleep) | The task needs your local files, tools or MCP servers |
| Dispatch | Your PC, via the desktop app | Stops | Send a task by message and let the app decide how to do it (Pro, Max and Ultra only) |
| Channels | Your PC, via a channel plugin | Stops | Send messages or events from Telegram, Discord or iMessage |

The key rule: **if your PC will be off, use the cloud**. Remote Control and Dispatch drive your machine, which has to stay on with Claude Code or the app open. If you're unsure which surface to open for each case, see [Which Claude should I open?](https://ctrlia.dev/en/recetas/que-claude-abrir.html).

## Requirements before you start

- **Plan:** Pro, Max, Ultra, Team or Enterprise. On Team and Enterprise it is off by default and an Owner has to turn on the toggle in the Claude Code admin settings. Prices and plans in [Is Claude Code free?](https://ctrlia.dev/en/recetas/claude-code-precio-gratis.html).
- **claude.ai sign-in, not an API key:** sign in with `/login`. It doesn't work with Amazon Bedrock, Google Cloud or Microsoft Foundry, nor if `ANTHROPIC_BASE_URL` points to a server other than api.anthropic.com (a proxy, a gateway or the [Ollama and OpenRouter](https://ctrlia.dev/en/recetas/claude-code-ollama-openrouter.html) tricks).
- **Variables that disable it:** `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` or `DISABLE_GROWTHBOOK`. `DISABLE_TELEMETRY` and `DO_NOT_TRACK` no longer block it since version 2.1.283, unless your organization requires Trusted Devices.
- **Folder trust:** the first time in a folder it asks whether you trust it.
- **On the phone:** install the Claude app and sign in with the same account and organization you use in the terminal.

Check it all without printing secrets (only variable names are shown, never their value):

```bash
claude auth status | grep -E 'authMethod|subscriptionType'
env | grep -E '^(ANTHROPIC_API_KEY|ANTHROPIC_BASE_URL|CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC|DISABLE_GROWTHBOOK)=' | cut -d= -f1
# if any name shows up, that variable blocks Remote Control
```

Inside a session, `/status` shows the account and plan. The repository includes `en/check-remote-control.sh`, which runs these checks in one go.

## Step by step: from the terminal to your phone in 5 minutes

There are three ways to start:

1. **Server mode**, in the project folder: `claude remote-control --name "My project"`. The first time it asks "Enable Remote Control? (y/n)"; answer `y`. The process waits for connections, shows the session URL and, if you press the space bar, a QR code.
2. **Interactive session with remote control:** `claude --remote-control`.
3. **Inside an already open session:** `/remote-control` (alias `/rc`), which keeps the conversation you were having.

```bash
cd ~/my-project
claude remote-control --name "My project"
# several sessions at once, each in its own git worktree:
claude remote-control --spawn worktree
```

```bash
claude --remote-control
# or, inside an already open session:
/remote-control
```

While connected, the terminal shows the `/rc active` indicator; running `/remote-control` again opens the panel with the URL, the QR and the option to disconnect.

On the phone: scan the QR, or open the app, tap **Code** and pick the session by name (Remote Control sessions have a computer icon with a green dot). If you don't have the app yet, `/mobile` shows a QR that opens the right store. To have all your sessions connect automatically, open `/config` and turn on "Enable Remote Control for all sessions".

To return to the last remote session in this folder (from the last ~4 hours):

```bash
claude remote-control --continue
```

## What you see and what you can do from your phone

- **Everything syncs:** the conversation, subagent progress and background workflows. You can type from the terminal, the browser or the phone interchangeably, and stopping a task from the phone stops it on your PC.
- **Attachments:** photos (Claude sees them and they are also saved in `~/.claude/uploads/`) and other files, which download to your machine as `@` references.
- **Commands that work** from mobile and web include: `/compact`, `/clear`, `/context`, `/usage`, `/model sonnet`, `/effort high`, `/fast`, `/rename` and `/config key=value`. Terminal-only commands, such as `/plugin` or `/resume`, don't.
- **Permission modes** from the app: Manual, Accept edits, Plan and Auto. Bypass permissions can't be chosen from the phone. To fine-tune what gets auto-approved, see [Claude Code permissions](https://ctrlia.dev/en/recetas/permisos-claude-code.html).
- **Notifications:** in `/config` turn on "Push when Claude decides" and "Push when actions required" so it alerts you when it finishes or needs an approval. You can also ask for it in the prompt ("let me know when the tests finish").

## Privacy and security: what you should know

- **Your code runs and your files are read only on your PC.** The local session only makes outbound HTTPS requests and never opens inbound ports: you don't have to touch your router or expose anything to the internet. All traffic goes through the Anthropic API over TLS, with short-lived credentials.
- **The transcript does leave your PC.** While Remote Control is connected, the session transcript (your messages, Claude's replies and tool activity) is stored on Anthropic's servers to sync devices, and kept according to its [data usage policy](https://code.claude.com/docs/en/data-usage). That includes whatever Claude reads on screen: don't use it in folders with secrets you don't want leaving your machine.
- **The biggest risk is your account:** whoever gets into your claude.ai account can drive your PC. Turn on **Trusted Devices** (beta; on Pro, Max and Ultra you enable it yourself in Settings, Cowork or Account page): it requires an enrolled device and a sign-in less than 18 hours old, renewable with fingerprint, Face ID, Windows Hello or a passkey.
- **Turn it off completely on a machine:** set `disableRemoteControl` in your `settings.json`.

```json
{
  "disableRemoteControl": true
}
```

## Common mistakes and their fix

- **"Remote Control requires a claude.ai subscription"** → you're not signed in with claude.ai → run `/login`.
- **"requires claude.ai subscription auth"** naming `ANTHROPIC_API_KEY`, `apiKeyHelper` or `ANTHROPIC_AUTH_TOKEN` → you're using a key → remove it from your environment.
- **"Remote Control isn't enabled for this account"** (before 2.1.239 it said "Remote Control is not yet enabled for your account") → usually plan info cached after a plan change → run `claude auth logout` and `claude auth login`, update Claude Code and use `claude doctor` to see which check fails.
- **"Remote Control is disabled by your organization's policy"** → on Team or Enterprise an Owner hasn't enabled it or your roles don't include the permission → ask for it; if your plan is Pro, Max or Ultra, you may still be signed in to an old organization: check `/status` and sign in again.
- **"Remote Control requires a full-scope login token"** → you're using a token from `claude setup-token` or `CLAUDE_CODE_OAUTH_TOKEN` → sign in with `claude auth login`.
- **Server mode exits on its own** → it was without network for about 10 minutes → launch it again; the interactive session reconnects by itself.

More general failures in [Common Claude Code errors](https://ctrlia.dev/en/recetas/errores-comunes-claude-code.html).

## What we tested and what's pending

On this PC (Linux, Claude Code 2.1.316) we checked that `claude auth status` returns `authMethod` claude.ai on the Max plan, that no variables block it, and that `claude remote-control --help` confirms `--name`, `--continue`, `--session-id`, `--permission-mode` and `--chrome`. **The phone part is not tested yet** (pairing with the QR, approving a change from the phone and receiving a notification); we don't open remote sessions without the owner present. When we test it, we'll update this page and its date. If you're just starting, follow the [Start here](https://ctrlia.dev/en/recetas/empieza-aqui.html) route first.

## FAQ

### Can I use Claude Code from my phone if my PC is off?
Not with Remote Control: your PC has to be on with Claude Code open. To work with the PC off, use a cloud session from the app's Code tab (requires the repository on GitHub) or launch it from the terminal with `claude --cloud "task"`.
### Is there a Claude Code app for Android or iPhone?
There's no separate app: you use the Claude app (iOS and Android), Code tab. On iPad you install the same iOS app.
### Does it work with the free plan or an API key?
No. It requires a Pro, Max, Ultra, Team or Enterprise subscription with a claude.ai sign-in. API keys and providers like Bedrock aren't supported.
### Do I need to open ports or use ngrok?
No. The local session only makes outbound HTTPS requests (port 443) to the Anthropic API and never opens inbound ports.
### Can I have several remote sessions?
Each interactive session supports one remote session. For several from a single process use server mode (`claude remote-control`), which supports up to 32 by default (`--capacity`) and can give each its own worktree with `--spawn worktree`.
### What about Telegram?
That's a different feature: Channels, which sends messages or events from Telegram, Discord or iMessage to a session on your PC through a channel plugin. It's on Pro, Max and Ultra, and on Team or Enterprise if an admin enables it.
