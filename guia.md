# Claude Code en el celular: guía de Remote Control

Revisada el 1-nov-2026 con Claude Code 2.1.316. Página completa: https://ctrlia.dev/recetas/remote-control-movil.html

## Cuatro formas oficiales de usar Claude Code desde el teléfono

No hay una app aparte de Claude Code: todo vive en la pestaña **Code** de la app de Claude para iOS y Android (en iPad, la misma app de iOS). Según la [documentación oficial](https://code.claude.com/docs/es/mobile) hay cuatro opciones:

| Opción | Dónde corre el código | Si apagas el PC | Cuándo usarla |
| --- | --- | --- | --- |
| Sesión en la nube | Infraestructura de Anthropic | Sigue funcionando | Tarea larga con el repositorio en GitHub |
| Remote Control | Tu PC | Se detiene (se reconecta al volver de la suspensión) | La tarea necesita tus archivos, herramientas o MCP locales |
| Dispatch | Tu PC, vía la app de escritorio | Se detiene | Mandar una tarea por mensaje y que la app decida cómo hacerla (solo Pro, Max y Ultra) |
| Channels | Tu PC, vía un plugin de canal | Se detiene | Enviar mensajes o eventos desde Telegram, Discord o iMessage |

La regla clave: **si tu PC va a estar apagado, usa la nube**. Remote Control y Dispatch manejan tu máquina, que tiene que seguir encendida con Claude Code o la app abiertos. Si dudas qué superficie abrir en cada caso, mira [¿Qué Claude abrir?](https://ctrlia.dev/recetas/que-claude-abrir.html).

## Requisitos antes de empezar

- **Plan:** Pro, Max, Ultra, Team o Enterprise. En Team y Enterprise viene apagado y un Owner tiene que activar el interruptor en la configuración de administración de Claude Code. Precios y planes en [¿Claude Code es gratis?](https://ctrlia.dev/recetas/claude-code-precio-gratis.html).
- **Sesión de claude.ai, no clave de API:** inicia sesión con `/login`. No funciona con Amazon Bedrock, Google Cloud o Microsoft Foundry, ni si `ANTHROPIC_BASE_URL` apunta a un servidor que no sea api.anthropic.com (un proxy, un gateway o los trucos de [Ollama y OpenRouter](https://ctrlia.dev/recetas/claude-code-ollama-openrouter.html)).
- **Variables que lo desactivan:** `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` o `DISABLE_GROWTHBOOK`. `DISABLE_TELEMETRY` y `DO_NOT_TRACK` ya no lo impiden desde la versión 2.1.283, salvo que tu organización exija Trusted Devices.
- **Confianza en la carpeta:** la primera vez en una carpeta te pregunta si confías en ella.
- **En el teléfono:** instala la app de Claude e inicia sesión con la misma cuenta y organización que usas en la terminal.

Compruébalo todo sin imprimir secretos (solo salen nombres de variables, nunca su valor):

```bash
claude auth status | grep -E 'authMethod|subscriptionType'
env | grep -E '^(ANTHROPIC_API_KEY|ANTHROPIC_BASE_URL|CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC|DISABLE_GROWTHBOOK)=' | cut -d= -f1
# si sale algún nombre, esa variable impide Remote Control
```

Dentro de una sesión, `/status` muestra la cuenta y el plan. El repositorio trae `comprobar-remote-control.sh`, que hace estas comprobaciones de una vez.

## Paso a paso: de la terminal al celular en 5 minutos

Hay tres formas de arrancar:

1. **Modo servidor**, en la carpeta del proyecto: `claude remote-control --name "Mi proyecto"`. La primera vez pregunta «Enable Remote Control? (y/n)»; responde `y`. El proceso queda esperando conexiones, muestra la URL de la sesión y, si pulsas la barra espaciadora, un código QR.
2. **Sesión interactiva con control remoto:** `claude --remote-control`.
3. **Dentro de una sesión ya abierta:** `/remote-control` (alias `/rc`), que conserva la conversación que llevabas.

```bash
cd ~/mi-proyecto
claude remote-control --name "Mi proyecto"
# varias sesiones a la vez, cada una en su worktree de git:
claude remote-control --spawn worktree
```

```bash
claude --remote-control
# o, dentro de una sesión ya abierta:
/remote-control
```

Mientras está conectada, la terminal muestra el indicador `/rc active`; ejecutar `/remote-control` otra vez abre el panel con la URL, el QR y la opción de desconectar.

En el móvil: escanea el QR, o abre la app, toca **Code** y elige la sesión por su nombre (las de Remote Control tienen un icono de ordenador con un punto verde). Si aún no tienes la app, `/mobile` muestra un QR que abre la tienda correcta. Para que todas tus sesiones se conecten solas, abre `/config` y activa «Enable Remote Control for all sessions».

Para volver a la última sesión remota de esta carpeta (de las últimas ~4 horas):

```bash
claude remote-control --continue
```

## Qué ves y qué puedes hacer desde el teléfono

- **Todo se sincroniza:** la conversación, el progreso de los subagentes y los flujos en segundo plano. Puedes escribir desde la terminal, el navegador o el móvil indistintamente, y detener una tarea desde el teléfono la detiene en tu PC.
- **Adjuntos:** fotos (Claude las ve y además se guardan en `~/.claude/uploads/`) y otros archivos, que se descargan a tu máquina como referencias `@`.
- **Comandos que funcionan** desde el móvil y la web, entre otros: `/compact`, `/clear`, `/context`, `/usage`, `/model sonnet`, `/effort high`, `/fast`, `/rename` y `/config clave=valor`. Los que solo existen en la terminal, como `/plugin` o `/resume`, no.
- **Modos de permiso** desde la app: Manual, Accept edits, Plan y Auto. Bypass permissions no se puede elegir desde el teléfono. Si quieres afinar qué se aprueba solo, mira [Permisos de Claude Code](https://ctrlia.dev/recetas/permisos-claude-code.html).
- **Notificaciones:** en `/config` activa «Push when Claude decides» y «Push when actions required» para que te avise cuando termine o necesite una aprobación. También puedes pedirlo en el prompt («avísame cuando terminen los tests»).

## Privacidad y seguridad: lo que conviene saber

- **Tu código se ejecuta y tus archivos se leen solo en tu PC.** La sesión local hace únicamente peticiones HTTPS salientes y nunca abre puertos de entrada: no tienes que tocar el router ni exponer nada a internet. Todo el tráfico pasa por la API de Anthropic con TLS, con credenciales de vida corta.
- **La transcripción sí sale de tu PC.** Mientras Remote Control está conectado, la transcripción de la sesión (tus mensajes, las respuestas de Claude y la actividad de las herramientas) se guarda en servidores de Anthropic para sincronizar dispositivos, y se conserva según su [política de uso de datos](https://code.claude.com/docs/en/data-usage). Eso incluye lo que Claude lea en pantalla: no lo uses en carpetas con secretos que no quieras que salgan de tu máquina.
- **El mayor riesgo es tu cuenta:** quien entre en tu cuenta de claude.ai puede dirigir tu PC. Activa **Trusted Devices** (beta; en Pro, Max y Ultra lo enciendes tú en Configuración, página Cowork o Cuenta): exige un dispositivo inscrito y un inicio de sesión de menos de 18 horas, renovable con huella, Face ID, Windows Hello o passkey.
- **Apagarlo del todo en una máquina:** pon `disableRemoteControl` en tu `settings.json`.

```json
{
  "disableRemoteControl": true
}
```

## Errores típicos y su arreglo

- **«Remote Control requires a claude.ai subscription»** → no has iniciado sesión con claude.ai → ejecuta `/login`.
- **«requires claude.ai subscription auth»** y nombra `ANTHROPIC_API_KEY`, `apiKeyHelper` o `ANTHROPIC_AUTH_TOKEN` → estás usando una clave → quítala de tu entorno.
- **«Remote Control isn't enabled for this account»** (antes de la 2.1.239 decía «Remote Control is not yet enabled for your account») → suele ser información del plan cacheada tras un cambio de plan → ejecuta `claude auth logout` y `claude auth login`, actualiza Claude Code y usa `claude doctor` para ver qué comprobación falla.
- **«Remote Control is disabled by your organization's policy»** → en Team o Enterprise un Owner no lo ha activado o tus roles no incluyen el permiso → pídeselo; si tu plan es Pro, Max o Ultra, puede que sigas con sesión de una organización antigua: mira `/status` y vuelve a iniciar sesión.
- **«Remote Control requires a full-scope login token»** → usas un token de `claude setup-token` o `CLAUDE_CODE_OAUTH_TOKEN` → inicia sesión con `claude auth login`.
- **El modo servidor se cierra solo** → estuvo sin red unos 10 minutos → vuelve a lanzarlo; la sesión interactiva se reconecta sola.

Más fallos generales en [Errores comunes de Claude Code](https://ctrlia.dev/recetas/errores-comunes-claude-code.html).

## Qué probamos y qué falta

En este PC (Linux, Claude Code 2.1.316) comprobamos que `claude auth status` devuelve `authMethod` claude.ai con plan Max, que no hay variables que lo bloqueen y que `claude remote-control --help` confirma `--name`, `--continue`, `--session-id`, `--permission-mode` y `--chrome`. **La parte del móvil aún no está probada** (conectar con el QR, aprobar un cambio desde el teléfono y recibir una notificación); no abrimos sesiones remotas sin el dueño delante. Cuando la probemos, actualizaremos esta página y su fecha. Si estás empezando, sigue antes la ruta de [Empieza aquí](https://ctrlia.dev/recetas/empieza-aqui.html).

## Preguntas frecuentes

### ¿Puedo usar Claude Code desde el celular si el PC está apagado?
Con Remote Control no: tu PC tiene que estar encendido con Claude Code abierto. Para trabajar con el PC apagado usa una sesión en la nube desde la pestaña Code de la app (requiere el repositorio en GitHub) o lánzala desde la terminal con `claude --cloud "tarea"`.
### ¿Hay una app de Claude Code para Android o iPhone?
No hay una app separada: se usa la app de Claude (iOS y Android), pestaña Code. En iPad se instala la misma app de iOS.
### ¿Funciona con el plan gratis o con clave de API?
No. Requiere una suscripción Pro, Max, Ultra, Team o Enterprise con sesión de claude.ai. Las claves de API y proveedores como Bedrock no son compatibles.
### ¿Tengo que abrir puertos o usar ngrok?
No. La sesión local solo hace peticiones HTTPS salientes (puerto 443) a la API de Anthropic y nunca abre puertos de entrada.
### ¿Puedo tener varias sesiones remotas?
Cada sesión interactiva admite una sesión remota. Para varias desde un solo proceso usa el modo servidor (`claude remote-control`), que admite hasta 32 por defecto (`--capacity`) y puede dar a cada una su propio worktree con `--spawn worktree`.
### ¿Y Telegram?
Es otra función: Channels, que envía mensajes o eventos de Telegram, Discord o iMessage a una sesión de tu PC mediante un plugin de canal. Está en Pro, Max y Ultra, y en Team o Enterprise si lo activa un administrador.
