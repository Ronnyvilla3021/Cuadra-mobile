# Guía para publicar Cuadra en Play Store

Hazlo en este orden. Lo que dice **(una sola vez)** no se repite en cada versión.

## 1. Define el nombre único de la app (una sola vez, ANTES de subir)

El `applicationId` no se puede cambiar después de publicar.

1. Abre `android/app/build.gradle.kts` (o `build.gradle` si tu proyecto usa Groovy).
2. Cambia solo `applicationId` por algo tuyo, por ejemplo `ec.ronny.cuadra`. No toques `namespace`.
3. Pon el mismo valor en `lib/core/app_info.dart` (`kIdPaquete`).
4. Cambia también `kCorreoContacto` en ese archivo y en `docs/politica_privacidad.md`.

## 2. Crea tu llave de firma (una sola vez)

Guárdala en un lugar seguro y haz una copia fuera de tu PC. Si la pierdes no podrás actualizar la app.

En Git Bash, desde la carpeta del proyecto:

```
"/c/Program Files/Android/Android Studio/jbr/bin/keytool" -genkey -v -keystore android/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Te pide una contraseña y tus datos. Anota la contraseña.

Crea `android/key.properties` con:

```
storePassword=TU_CONTRASEÑA
keyPassword=TU_CONTRASEÑA
keyAlias=upload
storeFile=../upload-keystore.jks
```

Añade estas dos líneas a `.gitignore` para no subir tus claves a GitHub:

```
android/key.properties
android/*.jks
```

## 3. Conecta la firma al build

Cuando llegues aquí, mándame tu `android/app/build.gradle.kts` y te devuelvo el archivo completo ya con la firma puesta. No lo edites a mano: es fácil romperlo.

## 4. Anuncios reales (AdMob)

1. Crea tu cuenta en admob.google.com y registra la app.
2. Crea 3 bloques de anuncios: Banner, Intersticial y Recompensado.
3. Mándame el **ID de la app** (`ca-app-pub-XXXX~YYYY`) para ponerlo en `AndroidManifest.xml`.
4. Los IDs de los 3 bloques se pasan al compilar (paso 5).

Nunca hagas clic en tus propios anuncios reales: te pueden bloquear la cuenta. Usa los IDs de prueba mientras desarrollas.

## 5. Genera el archivo para subir

```
flutter build appbundle --release --dart-define=ADMOB_BANNER_ID=ca-app-pub-XXXX/AAAA --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-XXXX/BBBB --dart-define=ADMOB_REWARDED_ID=ca-app-pub-XXXX/CCCC
```

El resultado queda en `build/app/outputs/bundle/release/app-release.aab`.

## 6. Política de privacidad en internet (gratis)

Play Store pide una URL pública.

1. Crea un repositorio público en GitHub, por ejemplo `cuadra-privacidad`.
2. Sube `docs/politica_privacidad.md` como `index.md`.
3. En Settings > Pages activa la publicación desde la rama `main`.
4. Tu URL será `https://TU_USUARIO.github.io/cuadra-privacidad/`.

## 7. Play Console

1. Crea la cuenta de desarrollador (pago único de 25 USD).
2. Crea la app: nombre "Cuadra", idioma español, app gratuita.
3. **Ficha de la tienda:**
   - Descripción corta y larga.
   - Ícono 512x512 (`assets/icon/icon.png` reducido).
   - Imagen destacada 1024x500.
   - Mínimo 2 capturas de pantalla del celular. Para tablet, capturas de 7" y 10".
4. **Política de privacidad:** pega la URL del paso 6.
5. **Anuncios:** responde "Sí, contiene anuncios".
6. **Seguridad de los datos**, respuestas sugeridas:
   - Tú no recopilas datos en servidores.
   - Declara el "ID de publicidad / otros ID del dispositivo" que usa AdMob, con finalidad de publicidad.
   - Los datos del negocio quedan solo en el dispositivo.
7. **Clasificación de contenido:** cuestionario, sin contenido sensible.
8. **Público objetivo:** mayores de 13 años o adultos (no es una app infantil).
9. **Prueba cerrada:** las cuentas personales nuevas suelen tener que probar con un grupo de testers durante unas 2 semanas antes de pasar a producción. Revisa el requisito exacto en tu Play Console.
10. Sube el `.aab` primero a Pruebas internas y luego avanza a producción.

## 8. Cobro de PRO

Se hace después de tener la app creada en Play Console, porque ahí se crea el producto de suscripción (por ejemplo `cuadra_pro_mensual`, 2.50 USD/mes). Ese será el siguiente paso de código.

## Lista final antes de enviar

- [ ] `applicationId` propio y `kIdPaquete` igual.
- [ ] Correo de contacto real en la política.
- [ ] Llave de firma guardada y con copia.
- [ ] IDs reales de AdMob puestos al compilar.
- [ ] Botones de debug fuera: ya están ocultos en release (`kDebugMode`).
- [ ] Probado en tu celular y en una tablet o emulador de tablet.
