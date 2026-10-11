// Prepara el proyecto para publicar. Se ejecuta desde la raíz del proyecto:
//
//   dart run tool/preparar_release.dart --crear-llave
//   dart run tool/preparar_release.dart --firma
//   dart run tool/preparar_release.dart --application-id=ec.tunombre.cuadra
//   dart run tool/preparar_release.dart --admob-app-id=ca-app-pub-XXXX~YYYY
//   dart run tool/preparar_release.dart --correo=tu@correo.com
//
// Se pueden combinar. Cada archivo que cambia guarda antes una copia .bak.
// Es seguro repetirlo: si algo ya está puesto, lo deja igual.
import 'dart:io';

void main(List<String> args) async {
  final opciones = <String, String>{};
  for (final a in args) {
    if (!a.startsWith('--')) continue;
    final i = a.indexOf('=');
    if (i == -1) {
      opciones[a.substring(2)] = '';
    } else {
      opciones[a.substring(2, i)] = a.substring(i + 1);
    }
  }
  if (opciones.isEmpty) {
    stdout.writeln('Opciones: --crear-llave  --firma  --application-id=...  '
        '--admob-app-id=...  --correo=...');
    return;
  }

  if (opciones.containsKey('crear-llave')) await _crearLlave();
  if (opciones.containsKey('firma')) _configurarFirma();
  if (opciones.containsKey('application-id')) {
    _cambiarApplicationId(opciones['application-id']!);
  }
  if (opciones.containsKey('admob-app-id')) {
    _cambiarAdmob(opciones['admob-app-id']!);
  }
  if (opciones.containsKey('correo')) _cambiarCorreo(opciones['correo']!);
  _ignorarSecretos();
}

// ------------------------------------------------------------------ utilidades

File _archivo(String ruta) => File(ruta.replaceAll('/', Platform.pathSeparator));

String? _leer(String ruta) {
  final f = _archivo(ruta);
  return f.existsSync() ? f.readAsStringSync() : null;
}

void _guardar(String ruta, String antes, String despues) {
  if (antes == despues) {
    stdout.writeln('  = $ruta (ya estaba así)');
    return;
  }
  final f = _archivo(ruta);
  _archivo('$ruta.bak').writeAsStringSync(antes);
  f.writeAsStringSync(despues);
  stdout.writeln('  * $ruta actualizado (copia en $ruta.bak)');
}

String _buscarKeytool() {
  final exe = Platform.isWindows ? 'keytool.exe' : 'keytool';
  final javaHome = Platform.environment['JAVA_HOME'];
  final candidatos = <String>[
    if (javaHome != null) '$javaHome${Platform.pathSeparator}bin${Platform.pathSeparator}$exe',
    r'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe',
    '/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool',
  ];
  for (final c in candidatos) {
    if (File(c).existsSync()) return c;
  }
  return exe; // que lo encuentre en el PATH
}

String _preguntar(String texto) {
  stdout.write('$texto ');
  return (stdin.readLineSync() ?? '').trim();
}

// ------------------------------------------------------------------- llave

Future<void> _crearLlave() async {
  stdout.writeln('\nCreando la llave de firma...');
  final jks = _archivo('android/upload-keystore.jks');
  final props = _archivo('android/key.properties');
  if (jks.existsSync()) {
    stdout.writeln('  Ya existe android/upload-keystore.jks. No se toca '
        '(si la reemplazas, no podrás actualizar la app).');
    return;
  }
  final nombre = _preguntar('Tu nombre o el de tu negocio:');
  final clave = _preguntar('Contraseña para la llave (mínimo 6 caracteres, anótala):');
  if (nombre.isEmpty || clave.length < 6) {
    stdout.writeln('  Falta el nombre o la contraseña es muy corta. Cancelado.');
    return;
  }
  final r = await Process.run(_buscarKeytool(), [
    '-genkeypair',
    '-v',
    '-keystore',
    jks.path,
    '-storetype',
    'JKS',
    '-keyalg',
    'RSA',
    '-keysize',
    '2048',
    '-validity',
    '10000',
    '-alias',
    'upload',
    '-storepass',
    clave,
    '-keypass',
    clave,
    '-dname',
    'CN=$nombre, C=EC',
  ]);
  if (r.exitCode != 0) {
    stdout.writeln('  keytool falló:\n${r.stdout}\n${r.stderr}');
    return;
  }
  props.writeAsStringSync('storePassword=$clave\n'
      'keyPassword=$clave\n'
      'keyAlias=upload\n'
      'storeFile=../upload-keystore.jks\n');
  stdout.writeln('  Listo. Se crearon android/upload-keystore.jks y '
      'android/key.properties.');
  stdout.writeln('  IMPORTANTE: haz una copia de esos dos archivos fuera de tu PC '
      '(USB o Drive privado). Si los pierdes no podrás actualizar la app.');
}

// ------------------------------------------------------------------- firma

void _configurarFirma() {
  stdout.writeln('\nConfigurando la firma en Gradle...');
  const ruta = 'android/app/build.gradle.kts';
  final original = _leer(ruta);
  if (original == null) {
    stdout.writeln('  No encuentro $ruta. Si tu proyecto usa build.gradle '
        '(Groovy), mándame ese archivo y lo adapto.');
    return;
  }
  if (original.contains('keystoreProperties')) {
    stdout.writeln('  = $ruta (la firma ya estaba configurada)');
    return;
  }
  var texto = original;

  // 1) imports al inicio
  const imports = 'import java.io.FileInputStream\nimport java.util.Properties\n\n';
  texto = '$imports$texto';

  // 2) leer key.properties justo antes de "android {"
  const cargar = 'val keystoreProperties = Properties()\n'
      'val keystorePropertiesFile = rootProject.file("key.properties")\n'
      'if (keystorePropertiesFile.exists()) {\n'
      '    keystoreProperties.load(FileInputStream(keystorePropertiesFile))\n'
      '}\n\n';
  final android = RegExp(r'^android\s*\{', multiLine: true);
  if (!android.hasMatch(texto)) {
    stdout.writeln('  No encontré el bloque "android {". No se cambió nada.');
    return;
  }
  texto = texto.replaceFirstMapped(android, (m) => '$cargar${m[0]}');

  // 3) signingConfigs antes de buildTypes
  const firmas = '    signingConfigs {\n'
      '        create("release") {\n'
      '            if (keystorePropertiesFile.exists()) {\n'
      '                keyAlias = keystoreProperties["keyAlias"] as String\n'
      '                keyPassword = keystoreProperties["keyPassword"] as String\n'
      '                storeFile = file(keystoreProperties["storeFile"] as String)\n'
      '                storePassword = keystoreProperties["storePassword"] as String\n'
      '            }\n'
      '        }\n'
      '    }\n\n';
  final tipos = RegExp(r'^\s*buildTypes\s*\{', multiLine: true);
  if (!tipos.hasMatch(texto)) {
    stdout.writeln('  No encontré "buildTypes {". No se cambió nada.');
    return;
  }
  texto = texto.replaceFirstMapped(tipos, (m) => '$firmas${m[0]}');

  // 4) que "release" use la llave (y debug si aún no hay llave)
  final debug = RegExp(r'signingConfig\s*=\s*signingConfigs\.getByName\("debug"\)');
  if (!debug.hasMatch(texto)) {
    stdout.writeln('  No encontré la línea signingConfig del release. '
        'No se cambió nada.');
    return;
  }
  texto = texto.replaceFirst(
    debug,
    'signingConfig = if (keystorePropertiesFile.exists()) '
    'signingConfigs.getByName("release") else signingConfigs.getByName("debug")',
  );
  _guardar(ruta, original, texto);
}

// ---------------------------------------------------------- application id

void _cambiarApplicationId(String id) {
  stdout.writeln('\nCambiando el applicationId a $id ...');
  if (!RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$').hasMatch(id)) {
    stdout.writeln('  ID no válido. Usa minúsculas y puntos, por ejemplo ec.tunombre.cuadra');
    return;
  }
  const ruta = 'android/app/build.gradle.kts';
  final g = _leer(ruta);
  if (g == null) {
    stdout.writeln('  No encuentro $ruta.');
  } else {
    final re = RegExp(r'applicationId\s*=\s*"[^"]*"');
    if (!re.hasMatch(g)) {
      stdout.writeln('  No encontré applicationId en $ruta.');
    } else {
      _guardar(ruta, g, g.replaceFirst(re, 'applicationId = "$id"'));
    }
  }
  const info = 'lib/core/app_info.dart';
  final a = _leer(info);
  if (a != null) {
    _guardar(
      info,
      a,
      a.replaceFirst(RegExp(r"const kIdPaquete = '[^']*';"), "const kIdPaquete = '$id';"),
    );
  }
}

// ------------------------------------------------------------------ admob

void _cambiarAdmob(String idApp) {
  stdout.writeln('\nPoniendo el ID de aplicación de AdMob...');
  if (!RegExp(r'^ca-app-pub-\d+~\d+$').hasMatch(idApp)) {
    stdout.writeln('  ID no válido. Debe verse así: ca-app-pub-1234567890123456~1234567890');
    return;
  }
  const ruta = 'android/app/src/main/AndroidManifest.xml';
  final m = _leer(ruta);
  if (m == null) {
    stdout.writeln('  No encuentro $ruta.');
    return;
  }
  final etiqueta = RegExp(
    r'<meta-data[^>]*com\.google\.android\.gms\.ads\.APPLICATION_ID[^>]*/>',
    dotAll: true,
  );
  final hallada = etiqueta.firstMatch(m);
  if (hallada == null) {
    stdout.writeln('  No encontré la etiqueta de AdMob en el manifest.');
    return;
  }
  final nueva = hallada[0]!.replaceFirst(
    RegExp(r'android:value="[^"]*"'),
    'android:value="$idApp"',
  );
  _guardar(ruta, m, m.replaceFirst(hallada[0]!, nueva));
}

// ------------------------------------------------------------------ correo

void _cambiarCorreo(String correo) {
  stdout.writeln('\nPoniendo el correo de contacto...');
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(correo)) {
    stdout.writeln('  Correo no válido.');
    return;
  }
  for (final ruta in [
    'lib/core/app_info.dart',
    'docs/politica_privacidad.md',
    'docs/privacidad_web/index.html',
  ]) {
    final t = _leer(ruta);
    if (t == null) continue;
    var nuevo = t.replaceAll('tu-correo@ejemplo.com', correo);
    if (ruta.endsWith('app_info.dart')) {
      nuevo = nuevo.replaceFirst(
        RegExp(r"const kCorreoContacto = '[^']*';"),
        "const kCorreoContacto = '$correo';",
      );
    }
    _guardar(ruta, t, nuevo);
  }
}

// --------------------------------------------------------------- .gitignore

void _ignorarSecretos() {
  final f = _archivo('.gitignore');
  if (!f.existsSync()) return;
  final t = f.readAsStringSync();
  final faltan = [
    'android/key.properties',
    'android/*.jks',
    'ids_admob.json',
    '*.bak',
  ].where((l) => !t.split('\n').map((x) => x.trim()).contains(l)).toList();
  if (faltan.isEmpty) return;
  f.writeAsStringSync('${t.endsWith('\n') ? t : '$t\n'}\n# Claves y archivos privados\n${faltan.join('\n')}\n');
  stdout.writeln('\n.gitignore: se añadieron ${faltan.join(', ')} para no subir tus claves a GitHub.');
}
