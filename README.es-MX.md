# Everything-Windsurf-Codex / EWC

<p align="center">
  <strong>Un flujo de trabajo multiagente con Windsurf / Cascade como punto de entrada principal y Codex como agente de ejecución delegado</strong>
</p>

<p align="center">
  <a href="./LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
  <img alt="Windsurf" src="https://img.shields.io/badge/Windsurf-main%20workspace-0EA5E9.svg">
  <img alt="Codex" src="https://img.shields.io/badge/Codex-MCP%20%2F%20CLI%20fallback-7C3AED.svg">
  <img alt="Validation" src="https://img.shields.io/badge/Validation-PASS-brightgreen.svg">
</p>

<p align="center">
  <a href="./README.md">简体中文</a> |
  <a href="./README.en.md">English</a> |
  <strong>Español (México)</strong> |
  <a href="./README.fr.md">Français</a>
</p>

## Introducción del proyecto

Everything-Windsurf-Codex / EWC es un flujo de trabajo ligero de colaboración multiagente. No es un plugin de Windsurf ni busca reemplazar a Cascade con Codex dentro de Windsurf.

La idea central es sencilla: el usuario sigue trabajando en Windsurf, mientras Cascade se mantiene a cargo de entender la solicitud, dividir la tarea, elegir el canal de ejecución, limitar permisos, revisar resultados y entregar la respuesta final. Codex MCP y Codex CLI fallback funcionan como agentes de ejecución delegados para exploraciones ligeras, tareas largas, escaneos amplios, ejecución por lotes, respaldo de red y registros revisables.

Si este proyecto te ayuda de cualquier forma, considera darle una Star para apoyarme.

En pocas palabras:

- **Windsurf / Cascade**: punto de entrada principal de cara al usuario, orquestador, revisor y capa de entrega final.
- **Codex MCP**: agente de ejecución ligero delegado por Cascade para tareas pequeñas.
- **Codex CLI fallback**: agente de ejecución delegado por Cascade para tareas largas, escaneos amplios, respaldo de red, ejecución por lotes y registros revisables.

## Por qué EWC

A muchas personas les gusta Windsurf porque el IDE, el panel de chat, la vista previa de archivos y el ritmo de interacción están en un solo lugar.

Pero en el trabajo real, algunas tareas no son ideales para quedarse esperando dentro del panel de chat:

- Escanear un repositorio grande.
- Redactar documentos largos o borradores.
- Cambios por lotes, formateo o investigación de pruebas.
- Mantener un registro completo para revisión posterior.
- Llamadas MCP que tardan demasiado o no muestran progreso.
- Acceso directo inestable desde Windsurf / Cascade a GitHub u otros recursos del extranjero.

EWC no reemplaza Windsurf ni rodea a Cascade. Mantiene al usuario dentro de Windsurf y permite que Cascade delegue en distintos agentes de ejecución, mientras Codex procesa como agente backend delegado las tareas lentas, repetitivas, sensibles a los registros o sensibles a la red.

## Filosofía de diseño: no invasivo y sin dependencias

EWC no requiere instalar un nuevo plugin de IDE, desplegar un servicio SaaS ni mover tu proyecto a una plataforma específica.

Está compuesto principalmente por documentos Markdown, workflows, skills y reglas de prompt. Se apoya en una capacidad que Windsurf / Cascade ya tiene: leer documentos, entender reglas y colaborar bajo restricciones.

Esto hace que EWC sea más una metodología portable de colaboración que un sistema cerrado que encierra al usuario en una sola cadena de herramientas:

- **No invasivo**: puedes empezar leyendo el README y copiando un conjunto pequeño de reglas.
- **Sin bloqueo a una sola plataforma**: las ideas centrales son separación de roles, selección de canales, límites de seguridad y registros revisables.
- **Sin depender de servicios en segundo plano**: no hay un servicio adicional para registrar, desplegar o mantener.
- **Sin autoridad ilimitada para la IA**: el objetivo no es darle más libertad a la IA, sino hacer que varios agentes colaboren dentro de límites claros.

## Modelo central de colaboración

```text
El usuario sigue describiendo solicitudes en Windsurf
        
Cascade entiende la intención, divide la tarea y elige un canal
        
Tareas pequeñas: Cascade o Codex MCP
Tareas largas / de red / con registros: Codex CLI fallback
        
Codex ejecuta dentro de un sandbox y un alcance autorizado explícitamente
        
Cascade revisa salidas, diffs, registros y resultados de validación
        
El usuario acepta el resultado en Windsurf
```

## Selección de canal

| Escenario | Canal recomendado |
|---|---|
| Análisis rápido de solo lectura de uno o dos archivos locales | Cascade o Codex MCP |
| Cambios pequeños con alcance claro | Cascade o Codex MCP + `workspace-write` |
| Escaneos grandes, tareas largas, cambios por lotes, investigación de pruebas | Codex CLI fallback |
| Tareas que requieren registros completos o revisión de progreso | Codex CLI fallback |
| MCP tarda demasiado o no muestra progreso | Codex CLI fallback |
| GitHub / recursos del extranjero son inestables | Codex CLI fallback |
| Decisiones de negocio, decisiones técnicas y aceptación final | Usuario + Cascade |

## Adaptado naturalmente al modo de red dividida

En entornos donde los recursos nacionales se acceden de forma directa y los recursos extranjeros usan proxy, o en cualquier entorno de red complejo, EWC se adapta naturalmente a un modo de red dividida.

No obliga a que todas las herramientas, tareas y accesos de red pasen por una sola entrada. En su lugar, separa interacción, despacho, ejecución y acceso de red en canales que pueden configurarse de forma independiente:

- **Windsurf / Cascade**: mantiene la entrada principal para interacción local, comprensión de solicitudes, despacho de tareas, revisión de resultados y aceptación final.
- **Codex MCP**: maneja tareas pequeñas y ligeras, y puede ejecutarse en un entorno MCP independiente cuando sea necesario.
- **Codex CLI fallback**: maneja tareas largas, escaneos grandes, acceso a GitHub / recursos del extranjero, ejecución por lotes y registros completos.

Así, incluso si el acceso directo de Windsurf / Cascade a ciertos recursos extranjeros es inestable, no necesitas forzar cambios en el entorno de red de Windsurf. Puedes delegar esas tareas al canal más adecuado: Codex CLI fallback.

En otras palabras, EWC no trata la inestabilidad de red como un problema que deba arreglarse dentro de una sola herramienta. Mediante la separación multiagente, divide de forma natural la interacción local, el acceso directo nacional, el acceso extranjero con proxy y la ejecución en segundo plano.

## Cadena de registros revisables

El valor clave de CLI fallback es la revisión. Una ejecución estándar debería conservar al menos:

```text
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.prompt.txt
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.log
.windsurf/codex-runs/codex-<topic>-<yyyyMMdd-HHmmss>.last.md
```

Esto permite que el usuario y Cascade revisen:

- **Prompt**: qué se le pidió hacer a Codex.
- **Log**: qué ocurrió durante la ejecución.
- **Last answer**: cuál fue la respuesta final de Codex.

## Límites de seguridad

- **No leer secretos**: nunca leer ni mostrar secrets, tokens, `auth.json`, llaves privadas u otras credenciales.
- **Sin permiso de escritura por defecto**: Codex solo puede modificar archivos cuando el usuario o Cascade lo autorice explícitamente.
- **El alcance de escritura debe ser explícito**: el prompt debe listar los archivos o directorios permitidos.
- **Sin ediciones fuera de alcance**: no se deben modificar archivos fuera del alcance autorizado.
- **La revisión es obligatoria**: Cascade revisa diffs, ejecuta validaciones y pide correcciones si hace falta.
- **No reemplazar reglas de negocio**: EWC es una capa de orquestación y validación, no una fuente de reglas de negocio.
- **Codificación consistente**: README, workflows, skills y prompts deberían usar UTF-8 without BOM.

## Estructura del repositorio

```text
.
 README.md
 README.en.md
 README.es-MX.md
 README.fr.md
 LICENSE
 NOTICE.md
 .gitignore
 ewc/
   README.md
   verify-ewc.ps1
 workflows/
   ewc.md
 global_workflows/
   codex-collab.md
 skills/
   ewc-maintenance/
     SKILL.md
   codex-delegation/
      SKILL.md
 examples/
    mcp_config.codex.json
```

## Cómo usarlo

La forma más sencilla de usar EWC no es necesariamente copiar todos los archivos manualmente. Puedes empezar conversando con la IA en Windsurf y pasándole el enlace de este proyecto para que aprenda el modelo de colaboración de EWC.

Puedes decir esto en Windsurf / Cascade:

```text
Por favor lee y aprende el modelo de colaboración de este proyecto:
https://github.com/LOrz-3/everything-windsurf-codex

Después, colabora conmigo usando el modelo EWC:
1. Mantén a Windsurf / Cascade como punto de entrada principal, orquestador, revisor y capa de entrega final.
2. Usa Codex MCP solo para tareas pequeñas y ligeras.
3. Usa Codex CLI fallback para tareas largas, escaneos grandes, ejecución por lotes, respaldo de red o tareas que requieran registros completos.
4. Antes de que Codex escriba archivos, el alcance permitido debe autorizarse explícitamente.
5. Al terminar, explica el canal de ejecución, archivos modificados, resultado de validación y riesgos.
```

Si tu IA puede acceder a GitHub, puede leer directamente el README, workflows, skills y reglas de contribución. Si el acceso a GitHub es inestable, primero clona este repositorio o copia los archivos clave en tu workspace actual de Windsurf antes de pedirle a la IA que los lea.

## Inicio rápido

### 1. Copia el workflow

Copia el archivo de workflow al directorio de workflows de tu proyecto Windsurf:

```text
workflows/ewc.md -> <workspace>/.windsurf/workflows/ewc.md
```

### 2. Copia los skills

Copia los archivos de skills al directorio de skills de Windsurf:

```text
skills/ewc-maintenance/SKILL.md
skills/codex-delegation/SKILL.md
```

### 3. Configura Codex MCP

Usa esta plantilla como referencia:

```text
examples/mcp_config.codex.json
```

La plantilla no contiene ninguna API key real ni rutas privadas locales.

### 4. Ejecuta la validación

Desde la raíz del repositorio:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\ewc\verify-ewc.ps1
```

Resultado esperado:

```text
Result: PASS
```

## Para quién es

- Usuarios a quienes les gusta el flujo de Windsurf y quieren seguir pidiendo y aceptando trabajo dentro de Windsurf.
- Usuarios que quieren usar Codex para tareas largas, escaneos grandes y ejecución por lotes.
- Usuarios que quieren registros revisables y auditables del trabajo de la IA.
- Usuarios que quieren límites claros entre MCP y CLI fallback.
- Usuarios que quieren construir su propio flujo ligero Everything-Windsurf-Codex.

## Para qué no es

- Reemplazar reglas de negocio del proyecto.
- Saltarse Cascade o la revisión humana.
- Manejar secrets, tokens o llaves privadas.
- Tratar a Codex como un agente con escritura ilimitada.
- Copiarlo directamente a todos los proyectos sin adaptar rutas locales y permisos.

## Contribución y mantenimiento

Se aceptan Issues y Pull Requests para sugerencias, correcciones y mejoras de documentación.

Este proyecto prioriza la siguiente posición: Windsurf es la entrada principal, Cascade se encarga del despacho y la revisión, y Codex MCP/CLI fallback realiza ejecución controlada. Los cambios que afecten la posición central del proyecto, límites de permisos, estrategia de registros o reglas de seguridad deben discutirse y validarse con cuidado.

Si contribuyes de forma constante y entiendes los límites de seguridad y principios de mantenimiento del proyecto, puedes contactar al autor para discutir una colaboración de mantenimiento.

Lee antes de contribuir:

- [Guía de contribución](CONTRIBUTING.md)
- [Código de conducta](CODE_OF_CONDUCT.md)
- [Política de seguridad](SECURITY.md)

## Topics sugeridos para GitHub

Si publicas o haces fork de este proyecto en GitHub, se sugieren estos topics:

```text
windsurf
codex
cascade
mcp
workflow
ai-coding
cli-fallback
developer-tools
```

## Agradecimientos

EWC está inspirado por las ideas de colaboración multiherramienta exploradas en [`everything-claude-code`](https://github.com/affaan-m/everything-claude-code).

Gracias al proyecto `everything-claude-code` por explorar workflows entre distintos AI coding harnesses, reglas compartidas, acumulación de skills y patrones de adaptación de herramientas. EWC toma la idea de convenciones de colaboración compartidas más adaptadores por herramienta, y la reorganiza de forma independiente para el escenario Windsurf + Cascade + Codex MCP/CLI fallback.

Un agradecimiento especial a [@why41bg](https://github.com/why41bg) por apoyar la exploración de este proyecto y por darme la oportunidad de experimentar y validar el workflow de Codex GPT-5.4.

Este proyecto es un sistema independiente de workflow Windsurf + Cascade + Codex MCP/CLI fallback. No está afiliado, respaldado ni mantenido por los autores originales de ECC.

Si copias o redistribuyes código, scripts, plantillas o documentación de terceros, conserva los avisos de copyright y textos de licencia correspondientes.

## Licencia

MIT License. Consulta [LICENSE](LICENSE).
