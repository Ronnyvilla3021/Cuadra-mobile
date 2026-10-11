# Guía para publicar Cuadra en Play Store

La mayor parte ya está hecha en el proyecto. Aquí solo quedan los pasos que dependen de tus cuentas.
Hazlos en este orden.

## A. Antes de tener la cuenta de Play (puedes hacerlo hoy)

1. **Crea tu llave de firma** (una sola vez):
   ```
   dart run tool/preparar_release.dart --crear-llave --firma
   ```
   Te pide tu nombre y una contraseña. Luego haz **una copia de `android/upload-keystore.jks` y `android/key.properties`
   fuera de tu PC** (USB o Drive privado). Si las pierdes no podrás actualizar la app.

2. **Elige el nombre único de tu app** (no se puede cambiar después de publicar), por ejemplo `ec.tunombre.cuadra`:
   ```
   dart run tool/preparar_release.dart --application-id=ec.tunombre.cuadra
   ```

3. **Pon tu correo de contacto** (sale en la política de privacidad):
   ```
   dart run tool/preparar_release.dart --correo=tu@correo.com
   ```

4. **Sube la política de privacidad a internet** (gratis):
   - Crea un repositorio público en GitHub, por ejemplo `cuadra-privacidad`.
   - Sube el archivo `docs/privacidad_web/index.html` a la raíz del repositorio.
   - En Settings > Pages elige "Deploy from a branch", rama `main`, carpeta `/ (root)`.
   - Tu URL será `https://TU_USUARIO.github.io/cuadra-privacidad/`. Guárdala.

5. Toma capturas de pantalla y revisa `docs/ficha_play_store.md` (textos listos para pegar).

## B. Con la cuenta de Play Console (25 USD, pago único)

1. Crea la app: nombre "Cuadra", español, gratuita.
2. Ficha de la tienda: pega los textos de `docs/ficha_play_store.md` y sube las imágenes de la carpeta `store/`.
3. Política de privacidad: pega la URL del paso A4.
4. Completa los cuestionarios con las respuestas sugeridas en `docs/ficha_play_store.md`.
5. **Crea la suscripción**: Monetizar > Productos > Suscripciones > ID `cuadra_pro_mensual`, plan base mensual de 2.50 USD.
6. Crea tus **cuentas de prueba** (Configuración > Pruebas de licencia) con tu correo, para probar el pago sin cobrarte.

## C. Con la cuenta de AdMob

1. Registra la app en admob.google.com y crea 3 bloques: Banner, Intersticial y Recompensado.
2. Pon el ID de la aplicación (`ca-app-pub-XXXX~YYYY`):
   ```
   dart run tool/preparar_release.dart --admob-app-id=ca-app-pub-XXXX~YYYY
   ```
3. Copia `ids_admob.example.json` como `ids_admob.json` y pega los 3 IDs de los bloques (este archivo no se sube a GitHub).

## D. Generar la versión para subir

```
flutter build appbundle --release --dart-define-from-file=ids_admob.json
```

El archivo queda en `build/app/outputs/bundle/release/app-release.aab`. Súbelo a Pruebas internas en Play Console,
instálala desde ahí en tu celular y prueba la suscripción con tu cuenta de prueba. Si todo funciona, pásala a Producción.

Nota: las cuentas personales nuevas suelen necesitar una prueba cerrada con un grupo de testers durante unas 2 semanas antes de
poder publicar en producción. Revisa el requisito exacto en tu Play Console.

## Lista final

- [ ] Llave de firma creada y con copia fuera de tu PC.
- [ ] `applicationId` propio.
- [ ] Correo real en la política y política publicada.
- [ ] IDs reales de AdMob en `ids_admob.json`.
- [ ] Suscripción `cuadra_pro_mensual` creada y probada con cuenta de prueba.
- [ ] Probada en tu celular y en una tablet.
