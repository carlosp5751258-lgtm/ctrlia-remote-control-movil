#!/usr/bin/env bash
# comprobar-remote-control.sh — revisa los requisitos de Remote Control de Claude Code.
# No imprime secretos: de las variables solo muestra el nombre, nunca el valor.
set -euo pipefail
fallos=0
mal() { echo "✗ $1"; fallos=$((fallos + 1)); }

command -v claude >/dev/null || { echo "✗ claude no está instalado"; exit 1; }
echo "Versión: $(claude --version)"

estado=$(claude auth status 2>/dev/null || true)
metodo=$(sed -n 's/.*"authMethod": *"\([^"]*\)".*/\1/p' <<<"$estado")
plan=$(sed -n 's/.*"subscriptionType": *"\([^"]*\)".*/\1/p' <<<"$estado")
if [ "$metodo" = "claude.ai" ]; then echo "✓ Sesión de claude.ai (plan: ${plan:-desconocido})"
else mal "Hace falta sesión de claude.ai, no clave de API (método actual: ${metodo:-sin sesión}). Ejecuta: claude auth login"; fi
# shortcut: solo detecta el plan gratis; otros nombres de plan se dan por buenos
[ "$plan" != free ] || mal "El plan gratis no incluye Remote Control (hace falta Pro, Max, Ultra, Team o Enterprise)"

for v in ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN CLAUDE_CODE_OAUTH_TOKEN CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC DISABLE_GROWTHBOOK; do
  [ -z "${!v:-}" ] || mal "La variable $v está definida y bloquea Remote Control: quítala de tu entorno"
done
if [ -n "${ANTHROPIC_BASE_URL:-}" ] && [[ $ANTHROPIC_BASE_URL != https://api.anthropic.com* ]]; then
  mal "ANTHROPIC_BASE_URL apunta a otro servidor (proxy, gateway, Ollama u OpenRouter): Remote Control no funciona así"
fi

if [ "$fallos" -eq 0 ]; then
  echo "✓ Todo listo. En una carpeta sin secretos: claude remote-control --name \"Mi proyecto\" (barra espaciadora = QR)"
else
  echo "$fallos problema(s). Más ayuda: claude doctor"; exit 1
fi
