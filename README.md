# Cuadra — caja, préstamos y personal para pequeños negocios

**Cuadra** es una aplicación Android para comerciantes y emprendedores que quieren llevar las cuentas de su negocio desde el celular, sin internet, sin crear cuenta y sin pagar servidores. Todo se guarda en el propio teléfono.

- **Plataforma:** Android (Flutter), pensada para celular y también ordenada para tablet.
- **Modelo:** gratis con anuncios (Inicio y Caja) y suscripción **Cuadra PRO** de 2.50 USD al mes (Préstamos, Personal/Empleados, Mis reportes, Copia de seguridad y sin anuncios).
- **Costo de infraestructura:** cero. No hay backend, base de datos en la nube ni cuentas de usuario.
- **Autor:** Ronny Villa — proyecto de portafolio.

## Contenido

1. [Manual de usuario y comandos](#1-manual-de-usuario-y-comandos)
2. [Todo lo que tiene el sistema](#2-todo-lo-que-tiene-el-sistema)

---

# 1. Manual de usuario y comandos

Esta sección explica cómo preparar el proyecto, ejecutarlo, probarlo, compilarlo y publicarlo, y cómo se usa la app paso a paso.


## 1.0 Descargar y ejecutar el proyecto

Cuadra es una app Flutter (no usa npm). Para correrla en otro computador:

​
git clone https://github.com/Ronnyvilla3021/Cuadra-mobile.git
cd Cuadra-mobile
flutter pub get
flutter run

- Si al compilar faltan archivos `.g.dart` de Drift, genera el código con:
  `dart run build_runner build --delete-conflicting-outputs`
- No necesitas `ids_admob.json`: sin él la app usa los anuncios de prueba de Google.
- No necesitas la llave de firma: solo sirve para publicar. En modo debug no se usa.
- Necesitas Flutter 3.47.1 y un celular Android o un emulador (mira la sección 1.1).


## 1.1 Requisitos

| Herramienta | Versión usada |
|---|---|
| Flutter | 3.47.1 |
| Dart | 3.13.1 |
| Android Studio o VS Code | cualquiera reciente |
| JDK | el que trae Android Studio |
| Celular Android | con depuración USB activada, o un emulador |

Comprueba que todo esté bien instalado:

```
flutter doctor
```

## 1.2 Primer arranque del proyecto

Desde la carpeta raíz del proyecto:

```
flutter pub get
```

Si falta el paquete de compras dentro de la app:

```
flutter pub add in_app_purchase
```

Si cambias las tablas de la base de datos (carpeta `lib/data/database`), se vuelve a generar el código de Drift:

```
dart run build_runner build --delete-conflicting-outputs
```

## 1.3 Ejecutar la app

Ver los dispositivos conectados:

```
flutter devices
```

Ejecutar en tu celular (cambia el identificador por el tuyo):

```
flutter run -d R5CW51TER5T
```

Durante la ejecución, en la terminal:

| Tecla | Qué hace |
|---|---|
| `r` | Recarga en caliente (conserva los datos en pantalla) |
| `R` | Reinicio completo de la app |
| `q` | Cierra la ejecución |

Ejecutar con tus IDs reales de AdMob (mira la sección 1.7):

```
flutter run -d R5CW51TER5T --dart-define-from-file=ids_admob.json
```

## 1.4 Calidad del código

Análisis estático (debe terminar con "No issues found"):

```
flutter analyze
```

Pruebas automáticas (deben pasar todas):

```
flutter test
```

Una sola prueba, por ejemplo la del tema visual:

```
flutter test test/features/tema_visual_test.dart
```

Formato automático del código:

```
dart format lib test tool
```

## 1.5 Íconos y pantalla de carga

Las imágenes están en `assets/icon` (logo y letras) y `assets/images` (fondos). Después de cambiar `logo.png` o `letras.png`, regenera el ícono de la app y la pantalla de carga del sistema:

```
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
dart run flutter_native_splash:create --path=flutter_native_splash.yaml
```

Nombres exactos que usa la app:

| Archivo | Uso |
|---|---|
| `assets/icon/logo.png` | Ícono, pantalla de carga, Configuración y pantalla PRO |
| `assets/icon/letras.png` | Nombre "Cuadra" en Inicio, Caja, Préstamos, Personal y pantalla de carga |
| `assets/images/fondo_oscuro.jpg` | Fondo de todo el sistema en modo oscuro |
| `assets/images/fondo_claro.jpg` | Fondo de todo el sistema en modo claro |
| `assets/images/fondo_pro.jpg` | Fondo exclusivo de la pantalla Cuadra PRO |

Si una imagen falta, la app muestra un color liso y no se rompe.

## 1.6 Preparar la publicación (script incluido)

El archivo `tool/preparar_release.dart` automatiza los cambios para publicar. Cada archivo que modifica guarda antes una copia `.bak`, y es seguro repetirlo.

Crear la llave de firma (una sola vez) y configurar la firma de Android:

```
dart run tool/preparar_release.dart --crear-llave --firma
```

Elegir el identificador único de la app (no se puede cambiar después de publicar):

```
dart run tool/preparar_release.dart --application-id=ec.tunombre.cuadra
```

Poner el ID de aplicación de AdMob y el correo de contacto:

```
dart run tool/preparar_release.dart --admob-app-id=ca-app-pub-XXXX~YYYY
dart run tool/preparar_release.dart --correo=tu@correo.com
```

Importante: guarda una copia de `android/upload-keystore.jks` y `android/key.properties` fuera de tu computador. Sin ellos no podrás actualizar la app.

## 1.7 Anuncios (AdMob)

Mientras desarrollas se usan los IDs de prueba oficiales de Google, que nunca generan riesgo de bloqueo. Para publicar, copia `ids_admob.example.json` como `ids_admob.json`, escribe tus IDs reales y compila con ese archivo (no lo subas a GitHub):

```
copy ids_admob.example.json ids_admob.json
```

Contenido del archivo:

```
{
  "ADMOB_BANNER_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/1111111111",
  "ADMOB_INTERSTITIAL_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/2222222222",
  "ADMOB_REWARDED_ID": "ca-app-pub-XXXXXXXXXXXXXXXX/3333333333"
}
```

## 1.8 Compilar para Play Store

Paquete firmado para subir a Play Console:

```
flutter build appbundle --release --dart-define-from-file=ids_admob.json
```

El resultado queda en `build/app/outputs/bundle/release/app-release.aab`.

APK para instalar directamente en un celular de prueba:

```
flutter build apk --release --dart-define-from-file=ids_admob.json
```

Limpiar compilaciones viejas si algo se comporta raro:

```
flutter clean
flutter pub get
```

## 1.9 Compras dentro de la app (suscripción PRO)

1. En Play Console crea la suscripción con el ID `cuadra_pro_mensual` y un plan base mensual de 2.50 USD.
2. Agrega tu correo como cuenta de pruebas de licencia para comprar sin que te cobren.
3. Sube una versión a la pista de pruebas internas e instálala desde Play Store: las compras no funcionan con un APK instalado a mano.
4. En modo de desarrollo (`flutter run`), si Google Play aún no conoce el producto, el botón "Suscribirme" activa PRO de forma simulada para que puedas probar la app. En una app publicada eso nunca ocurre.

Las guías paso a paso están en la carpeta `docs`: `publicar_en_play_store.md`, `ficha_play_store.md` y `politica_privacidad.md`. La versión web de la política de privacidad está en `docs/privacidad_web`.

## 1.10 Sugerencia para guardar el trabajo con Git

```
git status
git add .
git commit -m "Descripción corta del cambio"
git push
```

## 1.11 Manual de uso de la app

### Primera vez
1. Abre Cuadra. Verás la pantalla de carga con el logo y el nombre.
2. En la bienvenida escribe el **nombre de tu negocio** y toca **Comenzar** (puedes elegir "Omitir por ahora").
3. Llegas a **Inicio**.

### Inicio (gratis)
- Arriba ves el nombre de tu negocio y la fecha de hoy.
- La tarjeta azul muestra el **dinero en caja**.
- Debajo: **Ventas de hoy**, **Gastos de hoy** y la **Ganancia estimada** (ventas menos gastos).
- En **Últimos movimientos** ves los 5 más recientes; "Ver todos" abre la Caja.

### Caja (gratis)
1. Toca **+ Ingreso** o **− Gasto**.
2. Escribe el monto, elige la categoría y, si quieres, un concepto. Toca **Guardar**.
3. Usa los filtros **Todos / Ingresos / Gastos** para ver el historial.
4. Para borrar un movimiento manual, **mantenlo presionado** y confirma. El saldo se recalcula solo. Los movimientos que nacen de préstamos o pagos a empleados se borran desde su propia pantalla.
5. Abajo siempre ves el **Saldo actual**.

### Préstamos (PRO)
1. Toca **Nuevo préstamo**. Elige o escribe a la persona, el monto, la fecha del préstamo y, si quieres, la fecha de pago, una nota y el teléfono.
2. Decide si el dinero **sale de la caja** (si sí, se crea un gasto automático).
3. En la lista verás colores: **verde** pagado, **morado** pago parcial, **rojo** con deuda.
4. Entra a un préstamo para ver lo prestado, lo pagado y lo pendiente, y toca **Registrar pago** para anotar cada abono. Con "Pagar todo" liquidas el saldo.
5. **Recordar por WhatsApp** abre WhatsApp con el mensaje ya escrito; tú decides si lo envías.
6. El **calendario** muestra los cobros por día. Con los **avisos de cobro** activados recibes una notificación el día anterior y el día del vencimiento a las 9:00.
7. En el botón de ajustes de la lista puedes cambiar si los préstamos nuevos salen de la caja por defecto y fijar un **límite máximo pendiente de cobro**.
8. Desde el menú de tres puntos del préstamo puedes eliminarlo (se revierten sus movimientos).

### Personal / Empleados (PRO)
1. Toca **Nuevo empleado**, escribe el nombre, elige cómo le pagas (hora, día, semana, quincena o mes) y la tarifa.
2. Entra al empleado y toca **Registrar pago**: indica cuántas horas o días trabajó, y opcionalmente una bonificación, una deducción y una nota.
3. Cada pago crea automáticamente un gasto en la caja y queda en el historial. Puedes borrarlo y el gasto se borra también.

### Configuración
- **Mi negocio:** cambia el nombre.
- **Apariencia:** Sistema, Claro u Oscuro.
- **Notificaciones:** activa o desactiva los avisos de cobro.
- **Cuadra PRO:** ver la suscripción o restaurar compras.
- **Categorías:** crea, renombra o elimina categorías de ingresos y gastos (las predeterminadas no se tocan).
- **Exportar reporte:** elige el período (Hoy, Esta semana, Este mes, Mes pasado o fechas a elección), qué incluir (caja, préstamos, pagos de empleados) y genera un PDF para compartir o guardar. Gratis: se ve un video corto. PRO: sin anuncios.
- **Mis reportes (PRO):** lista de todos los PDF generados para abrirlos, compartirlos o guardarlos otra vez.
- **Copia de seguridad (PRO):** guarda todos tus datos en un archivo `.cuadra` y restáuralo en otro celular.
- **Borrar todos mis datos:** elimina todo lo guardado y vuelve a pedir el nombre del negocio.
- **Ayuda:** compartir la app, calificarla y leer la política de privacidad.

### Recomendaciones
- Haz una copia de seguridad antes de cambiar de celular o desinstalar la app: al desinstalar, los datos se borran porque viven solo en el teléfono.
- Registra los movimientos al momento para que el saldo coincida con tu caja real.

---

# 2. Todo lo que tiene el sistema

Esta sección describe, solo con palabras, absolutamente todo lo que incluye Cuadra.

## 2.1 Visión general

Cuadra es una aplicación móvil Android de gestión para pequeños negocios. Funciona completamente sin internet, guarda los datos solo en el teléfono del usuario, no pide registro ni correo y no depende de ningún servidor. El dinero se maneja en dólares estadounidenses y se guarda internamente en centavos enteros para evitar errores de redondeo.

## 2.2 Modelo de negocio

- **Versión gratuita:** incluye Inicio y Caja, categorías, exportación de reportes en PDF viendo un video corto, modo claro y oscuro, y muestra anuncios.
- **Cuadra PRO:** suscripción mensual de 2.50 dólares que desbloquea Préstamos, Personal, Mis reportes, Copia de seguridad, exportación sin anuncios y elimina toda la publicidad.
- Las funciones PRO aparecen en la barra de navegación con un candadito amarillo para el usuario gratuito. Al tocarlas se muestra una pantalla de presentación con lo que incluyen y el botón para suscribirse.

## 2.3 Pantallas y funciones

### Pantalla de carga
Muestra el logo de Cuadra y debajo sus letras sobre un fondo azul marino, con una barra de progreso. Abre la base de datos, espera un tiempo mínimo para que se vea y decide si lleva a la bienvenida o al inicio. Si algo falla, muestra un mensaje de error y un botón para reintentar. Existe además una pantalla de arranque nativa del sistema con el logo y las letras.

### Bienvenida
Aparece solo la primera vez, o después de borrar todos los datos. Pide el nombre del negocio y permite continuar de inmediato u omitir el paso.

### Inicio
Saluda con el nombre del negocio, muestra la fecha del día y las letras de Cuadra. Presenta una tarjeta principal con el dinero total en caja, tarjetas de ventas del día y gastos del día, una tarjeta de ganancia estimada (ventas menos gastos) y la lista de los últimos cinco movimientos con acceso a la Caja completa. Muestra un anuncio de banner a los usuarios gratuitos.

### Caja
Registra ingresos y gastos con monto, categoría, concepto opcional y fecha automática. Tiene filtros por tipo, un historial ordenado de lo más reciente a lo más antiguo, eliminación de movimientos manuales con una pulsación larga y confirmación, y una barra con el saldo actual siempre visible. Los movimientos creados automáticamente por préstamos o pagos a empleados están protegidos y se eliminan desde su origen. Incluye un anuncio intersticial que aparece con frecuencia limitada, nunca más de uno cada cinco minutos.

### Préstamos (PRO)
- Registro de préstamos con persona, monto, fecha, fecha de pago opcional, nota y teléfono. Si la persona ya existe se reutiliza; si es nueva se avisa.
- Decisión por préstamo de si el dinero sale de la caja, con un valor por defecto configurable. Esa decisión queda fija aunque después cambie el ajuste.
- Límite opcional de dinero pendiente de cobro: al crear un préstamo que lo superaría, la app muestra una advertencia y pide confirmación.
- Lista con tarjetas de color por estado: verde cuando está pagado, morado cuando hay pago parcial y rojo cuando hay deuda; resúmenes de lo que falta por cobrar y de cuántos están vencidos; filtros Todos, Con deuda y Pagados; barra de progreso por préstamo y texto que indica cuándo vence.
- Detalle del préstamo con persona, teléfono, monto prestado, pagado y pendiente, fechas, si salió de la caja, historial de movimientos, registro de pagos parciales o totales con nota, y eliminación que revierte los movimientos de la caja.
- Recordatorio por WhatsApp con el mensaje ya redactado; la app no envía nada por sí sola.
- Calendario mensual de cobros, con los pagos esperados marcados por día.
- Avisos de cobro: notificaciones locales el día anterior y el día del vencimiento, a las nueve de la mañana, solo para préstamos con fecha y saldo pendiente. Se pueden activar o desactivar en Configuración y se reprograman solos cuando algo cambia.

### Personal / Empleados (PRO)
- Alta de empleados con nombre y forma de pago: por hora, por día, por semana, por quincena o por mes, con su tarifa.
- Resumen del total pagado en el mes y número de empleados.
- Lista de empleados con inicial, tarifa, último pago y lo pagado en el mes.
- Detalle de cada empleado con tarifa, total del mes, total histórico y fecha del último pago.
- Registro de pagos con unidades trabajadas (admite decimales), bonificación, deducción y nota. Se guarda la tarifa aplicada en ese momento como respaldo histórico.
- Cada pago genera automáticamente un gasto en la caja, y al borrar el pago se borra también el gasto.
- Edición del empleado y opción de quitarlo desde el menú de tres puntos.

### Reportes en PDF
- Períodos disponibles: hoy, esta semana, este mes, mes pasado y rango de fechas elegido a mano.
- Contenido elegible: movimientos de caja, préstamos y pagos de empleados, con totales de ingresos, gastos y balance.
- Opciones al terminar: compartir el archivo con cualquier aplicación o descargarlo en el teléfono para conservarlo.
- Usuarios gratuitos ven un video corto antes de exportar; PRO exporta sin anuncios.
- **Mis reportes (PRO):** historial de todos los PDF generados, para volver a abrirlos, compartirlos, guardarlos en otra carpeta o eliminarlos.

### Copia de seguridad (PRO)
Exporta todos los datos a un único archivo con extensión propia de Cuadra que el usuario puede guardar donde quiera. Permite restaurar desde ese archivo, validando que sea auténtico y de una versión compatible, y reemplaza los datos actuales de forma segura. Es la forma de pasar la información a otro celular.

### Configuración
- Logo de Cuadra y nombre editable del negocio; moneda (dólar).
- Apariencia: seguir al sistema, claro u oscuro.
- Interruptor de avisos de cobro.
- Acceso a Cuadra PRO y, según el estado, aviso de que ya está activa.
- Administración de categorías de ingresos y de gastos.
- Exportar reporte, Mis reportes y Copia de seguridad.
- Borrar todos los datos, con confirmación, que deja la app como recién instalada.
- Compartir la app, calificarla en Play Store, política de privacidad dentro de la app y versión instalada.

### Categorías
Vienen categorías predeterminadas de ingresos (Venta, Servicio, Pago recibido, Otros ingresos) y de gastos (entre ellas Compra de mercadería, Servicios y Otros gastos). El usuario puede crear las suyas, renombrarlas y eliminarlas. Las predeterminadas no se pueden renombrar ni borrar porque el sistema las usa. Si se elimina una categoría propia, sus movimientos pasan a la categoría "Otros" correspondiente, sin perder registros.

### Pantalla Cuadra PRO
Pantalla oscura con imagen de fondo propia, el logo con una pequeña estrella, la lista de beneficios, el precio real tomado de Google Play, el botón de suscripción, un botón para restaurar compras y mensajes claros de estado. Si el usuario ya es PRO, el botón lo indica.

## 2.4 Diseño visual

- Tema claro y oscuro con una paleta azul marino coherente, tarjetas con borde fino, diálogos y hojas inferiores del mismo tono, campos de texto con borde que se resalta al enfocar, selectores y chips con estado claro, botones con esquinas redondeadas y mensajes flotantes.
- Fondo de imagen distinto para modo oscuro y modo claro en toda la aplicación, con un velo suave que garantiza la lectura del texto, y fondo propio solo para la pantalla PRO.
- Logo como ícono de la aplicación, en la pantalla de carga, en Configuración y en la pantalla PRO; las letras de Cuadra en los encabezados de Inicio, Caja, Préstamos y Personal.
- Colores con significado: verde para ingresos y pagos, rojo para gastos y deudas, amarillo para PRO, azul como color principal.
- Diseño adaptable: barra de navegación inferior en celular y riel lateral en tablet, con el contenido centrado y con ancho máximo.
- Las hojas de captura respetan el teclado y la barra del sistema para que ningún botón quede tapado.

## 2.5 Datos y almacenamiento

- Base de datos local SQLite administrada con Drift, con tablas de negocio, categorías, movimientos de caja, personas, préstamos, abonos de préstamos, empleados y pagos de empleados.
- Los montos se guardan en centavos enteros; el pagado y el pendiente de un préstamo siempre se calculan a partir de sus abonos.
- Las fechas se guardan en hora universal y se muestran en la hora local.
- Las preferencias (tema, avisos, ajustes de préstamos, estado PRO, bienvenida) se guardan aparte en las preferencias del teléfono.
- Restricciones en la base de datos que impiden montos inválidos, y relaciones que mantienen la coherencia entre préstamos, pagos y movimientos de caja.

## 2.6 Privacidad y seguridad

- Sin cuentas, sin servidores propios y sin envío de datos del negocio a ningún sitio. Nadie, ni el autor, puede ver las ventas, gastos, préstamos o empleados del usuario.
- Política de privacidad escrita, visible dentro de la app y publicable como página web gratuita.
- Los teléfonos se usan únicamente para abrir WhatsApp en el teléfono del usuario.
- Las únicas conexiones externas son las de Google Play (compras) y las de los anuncios de la versión gratuita.
- La llave de firma y los IDs reales de anuncios se mantienen fuera del repositorio.

## 2.7 Anuncios y monetización

- Banner discreto en Inicio y Caja para usuarios gratuitos.
- Anuncio intersticial al guardar movimientos, limitado a uno cada cinco minutos como máximo.
- Video recompensado antes de exportar un PDF, con un tiempo de espera de seguridad para no bloquear al usuario si el anuncio no carga.
- Los anuncios desaparecen por completo con PRO.
- Facturación real con Google Play: compra de la suscripción mensual, restauración de compras, verificación del estado y precio mostrado desde la tienda.

## 2.8 Notificaciones

Notificaciones locales de cobro programadas en el teléfono, con permiso pedido de forma amable al activar los avisos. No requieren internet ni servidor.

## 2.9 Calidad y pruebas

- Análisis estático sin errores.
- Pruebas automáticas que cubren el cálculo de avisos, los períodos de reportes, la generación de datos y PDF, el limitador de frecuencia de anuncios, el estado PRO y su bloqueo, el tema, el calendario de préstamos, los ajustes de préstamos, el enlace de WhatsApp, la copia y restauración de datos, la zona horaria, la bienvenida y el dibujo de fondo y tema visual.

## 2.10 Material para publicar

Incluye guía paso a paso de publicación en Play Store, textos listos para la ficha de la tienda, respuestas sugeridas para los cuestionarios, política de privacidad en texto y en página web, ícono de 512 píxeles, imagen destacada de 1024 por 500 y un script que prepara la firma, el identificador de la app, el ID de anuncios y el correo de contacto.

## 2.11 Estructura del proyecto (descrita)

- **Núcleo:** tema, colores, rutas de navegación, utilidades de dinero, fechas y pantalla, y componentes visuales compartidos como el fondo, el logo y las letras.
- **Datos:** definición de tablas, consultas por tema (caja, categorías, personas, préstamos, empleados, panel de inicio, respaldo) y proveedores de estado.
- **Funciones:** una carpeta por tema — anuncios, ajustes, alertas, caja, inicio, presentación inicial, personal, préstamos, suscripción PRO y reportes.
- **Pruebas, documentación, imágenes de la tienda y herramientas** en carpetas separadas.

## 2.12 Tecnologías

Flutter y Dart con Material 3; Riverpod para el estado; go_router para la navegación; Drift sobre SQLite para los datos; SharedPreferences para preferencias; google_mobile_ads para anuncios; in_app_purchase para la suscripción; flutter_local_notifications para avisos; url_launcher para WhatsApp y Play Store; pdf para los reportes; share_plus y file_picker para compartir y guardar archivos; flutter_launcher_icons y flutter_native_splash para el ícono y la pantalla de arranque.

## 2.13 Pendiente solo por cuentas externas

Crear la cuenta de Play Console, registrar la aplicación y la suscripción, crear la cuenta de AdMob y sus IDs reales, alojar la política de privacidad en una URL pública, tomar las capturas de pantalla y probar la compra en la pista de pruebas internas.
