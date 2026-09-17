# GenAI Game Lab

Laboratorio breve para mostrar cómo una IA generativa puede modificar un videojuego web y cómo publicar los cambios en Amazon S3.

El juego está contenido en archivos HTML autocontenidos: no requiere librerías, imágenes externas ni instalación de dependencias.

## Versiones del juego

- `starter.html`: versión base estable. Se conserva como punto de partida y recuperación.
- `index.html`: versión de trabajo para la demostración en vivo. Es la que publica `aws/deploy.sh`.
- `final.html`: ejemplo de una versión extendida con nuevos enemigos, jefe y armas.

Durante la demostración modifica únicamente `index.html`. No uses `starter.html` como archivo de trabajo.

## Controles

- `A` / `←`: mover a la izquierda.
- `D` / `→`: mover a la derecha.
- `Espacio`: saltar / planear.
- `Z`: disparar.
- `R`: reiniciar después de ganar o perder.

## Ejecutar localmente

No se necesita servidor web.

1. Abre `index.html` en un navegador moderno.
2. Verifica el cambio localmente antes de publicarlo en AWS.

Para recuperar la versión base:

```bash
cp starter.html index.html
```

## Despliegue en AWS Academy

### Requisitos

- AWS CLI instalado.
- Laboratorio de AWS Academy iniciado.
- Credenciales temporales configuradas en `~/.aws/credentials`.

Verifica las credenciales antes de continuar:

```bash
aws sts get-caller-identity
```

La región utilizada por el proyecto es `us-east-1`. El nombre del bucket se genera con el ID de la cuenta activa para reducir colisiones de nombres.

### 1. Crear y configurar el bucket

Ejecuta una vez por cuenta/laboratorio:

```bash
./aws/setup-bucket.sh
```

El script crea el bucket, habilita el alojamiento web estático y configura lectura pública para los objetos del sitio.

### 2. Publicar el juego

```bash
./aws/deploy.sh
```

El script publica `index.html` y muestra la URL pública. Después de cada cambio probado localmente, vuelve a ejecutar el mismo comando y recarga la página en el navegador.

Flujo recomendado:

```text
modificar index.html
        ↓
probar localmente
        ↓
./aws/deploy.sh
        ↓
recargar la URL de S3
```

## Flujo de la actividad

1. El docente publica `index.html` en S3 y los estudiantes prueban el juego.
2. El docente solicita a una IA generativa cambios progresivos y verifica cada versión localmente.
3. Después de cada cambio válido, vuelve a publicar `index.html` para que el grupo observe el resultado.
4. Los estudiantes reciben una copia de `starter.html`, la renombran como `index.html` y crean su propia versión con apoyo de una IA generativa.
5. Cada equipo debe probar el resultado y poder explicar qué solicitó y qué cambió en el juego.

## Estructura

```text
.
├── index.html
├── starter.html
├── final.html
├── README.md
├── .gitignore
└── aws/
    ├── config.sh
    ├── deploy.sh
    ├── setup-bucket.sh
    └── fix-website.sh
```

## Notas

- No guardes credenciales de AWS dentro del repositorio.
- El bucket se configura como público porque se usa como sitio web estático de demostración. No almacenes allí información sensible.
- Las credenciales de AWS Academy son temporales; si expiran, actualiza `~/.aws/credentials`.
- `aws/fix-website.sh` se conserva como utilidad de recuperación si un bucket existente no tiene habilitado el alojamiento web estático.

## Origen

Proyecto adaptado a partir de `camilousa/mario-game` para una actividad educativa de IA generativa y AWS S3.
