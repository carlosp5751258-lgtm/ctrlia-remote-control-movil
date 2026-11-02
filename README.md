# Claude Code en el celular con Remote Control

🇬🇧 [Read in English](README.en.md)

English version: [README.en.md](README.en.md) (archivos en `en/`).

Guía para dirigir desde el móvil una sesión de Claude Code que corre en tu PC, con un script que comprueba los requisitos
sin imprimir secretos y el ajuste para apagar Remote Control del todo.

Página completa: [ctrlia.dev (ES)](https://ctrlia.dev/recetas/remote-control-movil.html) ·
[ctrlia.dev (EN)](https://ctrlia.dev/en/recetas/remote-control-movil.html)

## Qué incluye

- `guia.md` / `en/guide.md`: las cuatro formas oficiales de usar Claude Code desde el teléfono, requisitos, paso a paso,
  qué funciona en la app, privacidad y seguridad, y los errores con su texto literal.
- `comprobar-remote-control.sh`: comprueba que hay sesión de claude.ai (no clave de API), que el plan no es el gratis y que
  no hay variables que lo bloqueen (`ANTHROPIC_API_KEY`, `ANTHROPIC_AUTH_TOKEN`, `CLAUDE_CODE_OAUTH_TOKEN`,
  `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`, `DISABLE_GROWTHBOOK` o un `ANTHROPIC_BASE_URL` ajeno). De las variables solo
  muestra el nombre.
- `settings-desactivar.json`: `{"disableRemoteControl": true}` para apagarlo en una máquina (cópialo a tu `settings.json`).

## Cómo usarlo

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-remote-control-movil.git
bash ctrlia-remote-control-movil/comprobar-remote-control.sh
# si sale «Todo listo», en una carpeta SIN secretos:
claude remote-control --name "Mi proyecto"   # pulsa la barra espaciadora para ver el QR
```

Mientras Remote Control está conectado, la transcripción de la sesión se guarda en servidores de Anthropic. Activa
Trusted Devices en tu cuenta de claude.ai.

## Probado

- Claude Code **2.1.316** en Linux: `claude auth status`, `claude remote-control --help` y el script (`bash -n`, con
  sesión real de claude.ai, con variables que lo bloquean y con un `claude` simulado con clave de API y plan gratis).
- **La parte del móvil aún no está probada** (conectar con el QR, aprobar desde el teléfono, notificaciones).

## Licencia

MIT. Copyright (c) 2026 Ctrl+IA (Carlos P.). Ver [LICENSE](LICENSE).
