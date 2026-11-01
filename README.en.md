# Claude Code on your phone with Remote Control

🇪🇸 [Leer en español](README.md)

A guide to drive, from your phone, a Claude Code session running on your PC, with a script that checks the requirements
without printing secrets and the setting to turn Remote Control off completely.

Full page: [ctrlia.dev (EN)](https://ctrlia.dev/en/recetas/remote-control-movil.html) ·
[ctrlia.dev (ES)](https://ctrlia.dev/recetas/remote-control-movil.html)

## What's included

- `guide.en.md` / `guia.md`: the four official ways to use Claude Code from your phone, requirements, step by step, what
  works in the app, privacy and security, and the errors with their exact text.
- `comprobar-remote-control.sh` (output in Spanish): checks there's a claude.ai sign-in (not an API key), that the plan
  isn't the free one, and that no variables block it (`ANTHROPIC_API_KEY`, `ANTHROPIC_AUTH_TOKEN`,
  `CLAUDE_CODE_OAUTH_TOKEN`, `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`, `DISABLE_GROWTHBOOK` or a foreign
  `ANTHROPIC_BASE_URL`). For variables it only shows the name.
- `settings-desactivar.json`: `{"disableRemoteControl": true}` to turn it off on a machine (copy it into your
  `settings.json`).

## How to use it

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-remote-control-movil.git
bash ctrlia-remote-control-movil/comprobar-remote-control.sh
# if it says «Todo listo» (all set), in a folder WITHOUT secrets:
claude remote-control --name "My project"   # press the space bar to see the QR
```

While Remote Control is connected, the session transcript is stored on Anthropic's servers. Turn on Trusted Devices in
your claude.ai account.

## Tested

- Claude Code **2.1.316** on Linux: `claude auth status`, `claude remote-control --help` and the script (`bash -n`, with a
  real claude.ai sign-in, with blocking variables and with a simulated `claude` using an API key and the free plan).
- **The phone part is not tested yet** (pairing with the QR, approving from the phone, notifications).

## License

MIT. Copyright (c) 2026 Ctrl+IA (Carlos P.). See [LICENSE](LICENSE).
