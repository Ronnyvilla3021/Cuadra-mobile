// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NegociosTable extends Negocios with TableInfo<$NegociosTable, Negocio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NegociosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoNegocioMeta = const VerificationMeta(
    'tipoNegocio',
  );
  @override
  late final GeneratedColumn<String> tipoNegocio = GeneratedColumn<String>(
    'tipo_negocio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  @override
  late final GeneratedColumn<String> moneda = GeneratedColumn<String>(
    'moneda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _saldoInicialCentavosMeta =
      const VerificationMeta('saldoInicialCentavos');
  @override
  late final GeneratedColumn<int> saldoInicialCentavos = GeneratedColumn<int>(
    'saldo_inicial_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    tipoNegocio,
    moneda,
    saldoInicialCentavos,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'negocios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Negocio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('tipo_negocio')) {
      context.handle(
        _tipoNegocioMeta,
        tipoNegocio.isAcceptableOrUnknown(
          data['tipo_negocio']!,
          _tipoNegocioMeta,
        ),
      );
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
      );
    }
    if (data.containsKey('saldo_inicial_centavos')) {
      context.handle(
        _saldoInicialCentavosMeta,
        saldoInicialCentavos.isAcceptableOrUnknown(
          data['saldo_inicial_centavos']!,
          _saldoInicialCentavosMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Negocio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Negocio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipoNegocio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_negocio'],
      ),
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      saldoInicialCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_inicial_centavos'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $NegociosTable createAlias(String alias) {
    return $NegociosTable(attachedDatabase, alias);
  }
}

class Negocio extends DataClass implements Insertable<Negocio> {
  final int id;
  final String nombre;
  final String? tipoNegocio;
  final String moneda;
  final int saldoInicialCentavos;
  final DateTime creadoEn;
  const Negocio({
    required this.id,
    required this.nombre,
    this.tipoNegocio,
    required this.moneda,
    required this.saldoInicialCentavos,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || tipoNegocio != null) {
      map['tipo_negocio'] = Variable<String>(tipoNegocio);
    }
    map['moneda'] = Variable<String>(moneda);
    map['saldo_inicial_centavos'] = Variable<int>(saldoInicialCentavos);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  NegociosCompanion toCompanion(bool nullToAbsent) {
    return NegociosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipoNegocio: tipoNegocio == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoNegocio),
      moneda: Value(moneda),
      saldoInicialCentavos: Value(saldoInicialCentavos),
      creadoEn: Value(creadoEn),
    );
  }

  factory Negocio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Negocio(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipoNegocio: serializer.fromJson<String?>(json['tipoNegocio']),
      moneda: serializer.fromJson<String>(json['moneda']),
      saldoInicialCentavos: serializer.fromJson<int>(
        json['saldoInicialCentavos'],
      ),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipoNegocio': serializer.toJson<String?>(tipoNegocio),
      'moneda': serializer.toJson<String>(moneda),
      'saldoInicialCentavos': serializer.toJson<int>(saldoInicialCentavos),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Negocio copyWith({
    int? id,
    String? nombre,
    Value<String?> tipoNegocio = const Value.absent(),
    String? moneda,
    int? saldoInicialCentavos,
    DateTime? creadoEn,
  }) => Negocio(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipoNegocio: tipoNegocio.present ? tipoNegocio.value : this.tipoNegocio,
    moneda: moneda ?? this.moneda,
    saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Negocio copyWithCompanion(NegociosCompanion data) {
    return Negocio(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipoNegocio: data.tipoNegocio.present
          ? data.tipoNegocio.value
          : this.tipoNegocio,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      saldoInicialCentavos: data.saldoInicialCentavos.present
          ? data.saldoInicialCentavos.value
          : this.saldoInicialCentavos,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Negocio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipoNegocio: $tipoNegocio, ')
          ..write('moneda: $moneda, ')
          ..write('saldoInicialCentavos: $saldoInicialCentavos, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    tipoNegocio,
    moneda,
    saldoInicialCentavos,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Negocio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipoNegocio == this.tipoNegocio &&
          other.moneda == this.moneda &&
          other.saldoInicialCentavos == this.saldoInicialCentavos &&
          other.creadoEn == this.creadoEn);
}

class NegociosCompanion extends UpdateCompanion<Negocio> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> tipoNegocio;
  final Value<String> moneda;
  final Value<int> saldoInicialCentavos;
  final Value<DateTime> creadoEn;
  const NegociosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipoNegocio = const Value.absent(),
    this.moneda = const Value.absent(),
    this.saldoInicialCentavos = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  NegociosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.tipoNegocio = const Value.absent(),
    this.moneda = const Value.absent(),
    this.saldoInicialCentavos = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Negocio> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? tipoNegocio,
    Expression<String>? moneda,
    Expression<int>? saldoInicialCentavos,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipoNegocio != null) 'tipo_negocio': tipoNegocio,
      if (moneda != null) 'moneda': moneda,
      if (saldoInicialCentavos != null)
        'saldo_inicial_centavos': saldoInicialCentavos,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  NegociosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? tipoNegocio,
    Value<String>? moneda,
    Value<int>? saldoInicialCentavos,
    Value<DateTime>? creadoEn,
  }) {
    return NegociosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipoNegocio: tipoNegocio ?? this.tipoNegocio,
      moneda: moneda ?? this.moneda,
      saldoInicialCentavos: saldoInicialCentavos ?? this.saldoInicialCentavos,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipoNegocio.present) {
      map['tipo_negocio'] = Variable<String>(tipoNegocio.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (saldoInicialCentavos.present) {
      map['saldo_inicial_centavos'] = Variable<int>(saldoInicialCentavos.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NegociosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipoNegocio: $tipoNegocio, ')
          ..write('moneda: $moneda, ')
          ..write('saldoInicialCentavos: $saldoInicialCentavos, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMovimiento, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoMovimiento>($CategoriasTable.$convertertipo);
  static const VerificationMeta _esPredeterminadaMeta = const VerificationMeta(
    'esPredeterminada',
  );
  @override
  late final GeneratedColumn<bool> esPredeterminada = GeneratedColumn<bool>(
    'es_predeterminada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_predeterminada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, tipo, esPredeterminada];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('es_predeterminada')) {
      context.handle(
        _esPredeterminadaMeta,
        esPredeterminada.isAcceptableOrUnknown(
          data['es_predeterminada']!,
          _esPredeterminadaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {nombre, tipo},
  ];
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipo: $CategoriasTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      esPredeterminada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_predeterminada'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMovimiento, String, String> $convertertipo =
      const EnumNameConverter<TipoMovimiento>(TipoMovimiento.values);
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final TipoMovimiento tipo;
  final bool esPredeterminada;
  const Categoria({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.esPredeterminada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    {
      map['tipo'] = Variable<String>(
        $CategoriasTable.$convertertipo.toSql(tipo),
      );
    }
    map['es_predeterminada'] = Variable<bool>(esPredeterminada);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipo: Value(tipo),
      esPredeterminada: Value(esPredeterminada),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipo: $CategoriasTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      esPredeterminada: serializer.fromJson<bool>(json['esPredeterminada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipo': serializer.toJson<String>(
        $CategoriasTable.$convertertipo.toJson(tipo),
      ),
      'esPredeterminada': serializer.toJson<bool>(esPredeterminada),
    };
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    TipoMovimiento? tipo,
    bool? esPredeterminada,
  }) => Categoria(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipo: tipo ?? this.tipo,
    esPredeterminada: esPredeterminada ?? this.esPredeterminada,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      esPredeterminada: data.esPredeterminada.present
          ? data.esPredeterminada.value
          : this.esPredeterminada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('esPredeterminada: $esPredeterminada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, tipo, esPredeterminada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipo == this.tipo &&
          other.esPredeterminada == this.esPredeterminada);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<TipoMovimiento> tipo;
  final Value<bool> esPredeterminada;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipo = const Value.absent(),
    this.esPredeterminada = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required TipoMovimiento tipo,
    this.esPredeterminada = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? tipo,
    Expression<bool>? esPredeterminada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipo != null) 'tipo': tipo,
      if (esPredeterminada != null) 'es_predeterminada': esPredeterminada,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<TipoMovimiento>? tipo,
    Value<bool>? esPredeterminada,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      esPredeterminada: esPredeterminada ?? this.esPredeterminada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $CategoriasTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (esPredeterminada.present) {
      map['es_predeterminada'] = Variable<bool>(esPredeterminada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipo: $tipo, ')
          ..write('esPredeterminada: $esPredeterminada')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, Movimiento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMovimiento, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoMovimiento>($MovimientosTable.$convertertipo);
  static const VerificationMeta _conceptoMeta = const VerificationMeta(
    'concepto',
  );
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
    'concepto',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(montoCentavos).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrigenMovimiento, String> origen =
      GeneratedColumn<String>(
        'origen',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('manual'),
      ).withConverter<OrigenMovimiento>($MovimientosTable.$converterorigen);
  static const VerificationMeta _origenIdMeta = const VerificationMeta(
    'origenId',
  );
  @override
  late final GeneratedColumn<int> origenId = GeneratedColumn<int>(
    'origen_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    concepto,
    categoriaId,
    montoCentavos,
    fecha,
    origen,
    origenId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Movimiento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concepto')) {
      context.handle(
        _conceptoMeta,
        concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptoMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('origen_id')) {
      context.handle(
        _origenIdMeta,
        origenId.isAcceptableOrUnknown(data['origen_id']!, _origenIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movimiento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movimiento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: $MovimientosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      concepto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concepto'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      origen: $MovimientosTable.$converterorigen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origen'],
        )!,
      ),
      origenId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}origen_id'],
      ),
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMovimiento, String, String> $convertertipo =
      const EnumNameConverter<TipoMovimiento>(TipoMovimiento.values);
  static JsonTypeConverter2<OrigenMovimiento, String, String> $converterorigen =
      const EnumNameConverter<OrigenMovimiento>(OrigenMovimiento.values);
}

class Movimiento extends DataClass implements Insertable<Movimiento> {
  final int id;
  final TipoMovimiento tipo;
  final String concepto;
  final int? categoriaId;
  final int montoCentavos;
  final DateTime fecha;
  final OrigenMovimiento origen;

  /// id del registro que originó este movimiento (pago de fiado, etc.).
  final int? origenId;
  const Movimiento({
    required this.id,
    required this.tipo,
    required this.concepto,
    this.categoriaId,
    required this.montoCentavos,
    required this.fecha,
    required this.origen,
    this.origenId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tipo'] = Variable<String>(
        $MovimientosTable.$convertertipo.toSql(tipo),
      );
    }
    map['concepto'] = Variable<String>(concepto);
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['monto_centavos'] = Variable<int>(montoCentavos);
    map['fecha'] = Variable<DateTime>(fecha);
    {
      map['origen'] = Variable<String>(
        $MovimientosTable.$converterorigen.toSql(origen),
      );
    }
    if (!nullToAbsent || origenId != null) {
      map['origen_id'] = Variable<int>(origenId);
    }
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      tipo: Value(tipo),
      concepto: Value(concepto),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      montoCentavos: Value(montoCentavos),
      fecha: Value(fecha),
      origen: Value(origen),
      origenId: origenId == null && nullToAbsent
          ? const Value.absent()
          : Value(origenId),
    );
  }

  factory Movimiento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movimiento(
      id: serializer.fromJson<int>(json['id']),
      tipo: $MovimientosTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      concepto: serializer.fromJson<String>(json['concepto']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      origen: $MovimientosTable.$converterorigen.fromJson(
        serializer.fromJson<String>(json['origen']),
      ),
      origenId: serializer.fromJson<int?>(json['origenId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(
        $MovimientosTable.$convertertipo.toJson(tipo),
      ),
      'concepto': serializer.toJson<String>(concepto),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
      'fecha': serializer.toJson<DateTime>(fecha),
      'origen': serializer.toJson<String>(
        $MovimientosTable.$converterorigen.toJson(origen),
      ),
      'origenId': serializer.toJson<int?>(origenId),
    };
  }

  Movimiento copyWith({
    int? id,
    TipoMovimiento? tipo,
    String? concepto,
    Value<int?> categoriaId = const Value.absent(),
    int? montoCentavos,
    DateTime? fecha,
    OrigenMovimiento? origen,
    Value<int?> origenId = const Value.absent(),
  }) => Movimiento(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    concepto: concepto ?? this.concepto,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    fecha: fecha ?? this.fecha,
    origen: origen ?? this.origen,
    origenId: origenId.present ? origenId.value : this.origenId,
  );
  Movimiento copyWithCompanion(MovimientosCompanion data) {
    return Movimiento(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      origen: data.origen.present ? data.origen.value : this.origen,
      origenId: data.origenId.present ? data.origenId.value : this.origenId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movimiento(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('concepto: $concepto, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('fecha: $fecha, ')
          ..write('origen: $origen, ')
          ..write('origenId: $origenId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    concepto,
    categoriaId,
    montoCentavos,
    fecha,
    origen,
    origenId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movimiento &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.concepto == this.concepto &&
          other.categoriaId == this.categoriaId &&
          other.montoCentavos == this.montoCentavos &&
          other.fecha == this.fecha &&
          other.origen == this.origen &&
          other.origenId == this.origenId);
}

class MovimientosCompanion extends UpdateCompanion<Movimiento> {
  final Value<int> id;
  final Value<TipoMovimiento> tipo;
  final Value<String> concepto;
  final Value<int?> categoriaId;
  final Value<int> montoCentavos;
  final Value<DateTime> fecha;
  final Value<OrigenMovimiento> origen;
  final Value<int?> origenId;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.concepto = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.fecha = const Value.absent(),
    this.origen = const Value.absent(),
    this.origenId = const Value.absent(),
  });
  MovimientosCompanion.insert({
    this.id = const Value.absent(),
    required TipoMovimiento tipo,
    required String concepto,
    this.categoriaId = const Value.absent(),
    required int montoCentavos,
    required DateTime fecha,
    this.origen = const Value.absent(),
    this.origenId = const Value.absent(),
  }) : tipo = Value(tipo),
       concepto = Value(concepto),
       montoCentavos = Value(montoCentavos),
       fecha = Value(fecha);
  static Insertable<Movimiento> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<String>? concepto,
    Expression<int>? categoriaId,
    Expression<int>? montoCentavos,
    Expression<DateTime>? fecha,
    Expression<String>? origen,
    Expression<int>? origenId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (concepto != null) 'concepto': concepto,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (fecha != null) 'fecha': fecha,
      if (origen != null) 'origen': origen,
      if (origenId != null) 'origen_id': origenId,
    });
  }

  MovimientosCompanion copyWith({
    Value<int>? id,
    Value<TipoMovimiento>? tipo,
    Value<String>? concepto,
    Value<int?>? categoriaId,
    Value<int>? montoCentavos,
    Value<DateTime>? fecha,
    Value<OrigenMovimiento>? origen,
    Value<int?>? origenId,
  }) {
    return MovimientosCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      concepto: concepto ?? this.concepto,
      categoriaId: categoriaId ?? this.categoriaId,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      fecha: fecha ?? this.fecha,
      origen: origen ?? this.origen,
      origenId: origenId ?? this.origenId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $MovimientosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (origen.present) {
      map['origen'] = Variable<String>(
        $MovimientosTable.$converterorigen.toSql(origen.value),
      );
    }
    if (origenId.present) {
      map['origen_id'] = Variable<int>(origenId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('concepto: $concepto, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('fecha: $fecha, ')
          ..write('origen: $origen, ')
          ..write('origenId: $origenId')
          ..write(')'))
        .toString();
  }
}

class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    activo,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nombre;
  final String? telefono;
  final bool activo;
  final DateTime creadoEn;
  const Cliente({
    required this.id,
    required this.nombre,
    this.telefono,
    required this.activo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String?>(telefono),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Cliente copyWith({
    int? id,
    String? nombre,
    Value<String?> telefono = const Value.absent(),
    bool? activo,
    DateTime? creadoEn,
  }) => Cliente(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono.present ? telefono.value : this.telefono,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, telefono, activo, creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> telefono;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.telefono = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? telefono,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $MovimientosFiadoTable extends MovimientosFiado
    with TableInfo<$MovimientosFiadoTable, MovimientoFiado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosFiadoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoFiado, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoFiado>($MovimientosFiadoTable.$convertertipo);
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  @override
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(montoCentavos).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    tipo,
    montoCentavos,
    nota,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos_fiado';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoFiado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoFiado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoFiado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      tipo: $MovimientosFiadoTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  $MovimientosFiadoTable createAlias(String alias) {
    return $MovimientosFiadoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoFiado, String, String> $convertertipo =
      const EnumNameConverter<TipoFiado>(TipoFiado.values);
}

class MovimientoFiado extends DataClass implements Insertable<MovimientoFiado> {
  final int id;
  final int clienteId;
  final TipoFiado tipo;
  final int montoCentavos;
  final String? nota;
  final DateTime fecha;
  const MovimientoFiado({
    required this.id,
    required this.clienteId,
    required this.tipo,
    required this.montoCentavos,
    this.nota,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    {
      map['tipo'] = Variable<String>(
        $MovimientosFiadoTable.$convertertipo.toSql(tipo),
      );
    }
    map['monto_centavos'] = Variable<int>(montoCentavos);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  MovimientosFiadoCompanion toCompanion(bool nullToAbsent) {
    return MovimientosFiadoCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      tipo: Value(tipo),
      montoCentavos: Value(montoCentavos),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      fecha: Value(fecha),
    );
  }

  factory MovimientoFiado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoFiado(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      tipo: $MovimientosFiadoTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      montoCentavos: serializer.fromJson<int>(json['montoCentavos']),
      nota: serializer.fromJson<String?>(json['nota']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'tipo': serializer.toJson<String>(
        $MovimientosFiadoTable.$convertertipo.toJson(tipo),
      ),
      'montoCentavos': serializer.toJson<int>(montoCentavos),
      'nota': serializer.toJson<String?>(nota),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  MovimientoFiado copyWith({
    int? id,
    int? clienteId,
    TipoFiado? tipo,
    int? montoCentavos,
    Value<String?> nota = const Value.absent(),
    DateTime? fecha,
  }) => MovimientoFiado(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    tipo: tipo ?? this.tipo,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    nota: nota.present ? nota.value : this.nota,
    fecha: fecha ?? this.fecha,
  );
  MovimientoFiado copyWithCompanion(MovimientosFiadoCompanion data) {
    return MovimientoFiado(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      nota: data.nota.present ? data.nota.value : this.nota,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoFiado(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('nota: $nota, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clienteId, tipo, montoCentavos, nota, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoFiado &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.tipo == this.tipo &&
          other.montoCentavos == this.montoCentavos &&
          other.nota == this.nota &&
          other.fecha == this.fecha);
}

class MovimientosFiadoCompanion extends UpdateCompanion<MovimientoFiado> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<TipoFiado> tipo;
  final Value<int> montoCentavos;
  final Value<String?> nota;
  final Value<DateTime> fecha;
  const MovimientosFiadoCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.nota = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  MovimientosFiadoCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required TipoFiado tipo,
    required int montoCentavos,
    this.nota = const Value.absent(),
    required DateTime fecha,
  }) : clienteId = Value(clienteId),
       tipo = Value(tipo),
       montoCentavos = Value(montoCentavos),
       fecha = Value(fecha);
  static Insertable<MovimientoFiado> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? tipo,
    Expression<int>? montoCentavos,
    Expression<String>? nota,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (tipo != null) 'tipo': tipo,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (nota != null) 'nota': nota,
      if (fecha != null) 'fecha': fecha,
    });
  }

  MovimientosFiadoCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<TipoFiado>? tipo,
    Value<int>? montoCentavos,
    Value<String?>? nota,
    Value<DateTime>? fecha,
  }) {
    return MovimientosFiadoCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      tipo: tipo ?? this.tipo,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      nota: nota ?? this.nota,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $MovimientosFiadoTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosFiadoCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('nota: $nota, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $EmpleadosTable extends Empleados
    with TableInfo<$EmpleadosTable, Empleado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmpleadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoPago, String> tipoPago =
      GeneratedColumn<String>(
        'tipo_pago',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoPago>($EmpleadosTable.$convertertipoPago);
  static const VerificationMeta _tarifaCentavosMeta = const VerificationMeta(
    'tarifaCentavos',
  );
  @override
  late final GeneratedColumn<int> tarifaCentavos = GeneratedColumn<int>(
    'tarifa_centavos',
    aliasedName,
    false,
    check: () => ComparableExpr(tarifaCentavos).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    tipoPago,
    tarifaCentavos,
    activo,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'empleados';
  @override
  VerificationContext validateIntegrity(
    Insertable<Empleado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('tarifa_centavos')) {
      context.handle(
        _tarifaCentavosMeta,
        tarifaCentavos.isAcceptableOrUnknown(
          data['tarifa_centavos']!,
          _tarifaCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaCentavosMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Empleado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Empleado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      tipoPago: $EmpleadosTable.$convertertipoPago.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo_pago'],
        )!,
      ),
      tarifaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_centavos'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $EmpleadosTable createAlias(String alias) {
    return $EmpleadosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoPago, String, String> $convertertipoPago =
      const EnumNameConverter<TipoPago>(TipoPago.values);
}

class Empleado extends DataClass implements Insertable<Empleado> {
  final int id;
  final String nombre;
  final TipoPago tipoPago;
  final int tarifaCentavos;
  final bool activo;
  final DateTime creadoEn;
  const Empleado({
    required this.id,
    required this.nombre,
    required this.tipoPago,
    required this.tarifaCentavos,
    required this.activo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    {
      map['tipo_pago'] = Variable<String>(
        $EmpleadosTable.$convertertipoPago.toSql(tipoPago),
      );
    }
    map['tarifa_centavos'] = Variable<int>(tarifaCentavos);
    map['activo'] = Variable<bool>(activo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  EmpleadosCompanion toCompanion(bool nullToAbsent) {
    return EmpleadosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      tipoPago: Value(tipoPago),
      tarifaCentavos: Value(tarifaCentavos),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
    );
  }

  factory Empleado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Empleado(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      tipoPago: $EmpleadosTable.$convertertipoPago.fromJson(
        serializer.fromJson<String>(json['tipoPago']),
      ),
      tarifaCentavos: serializer.fromJson<int>(json['tarifaCentavos']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'tipoPago': serializer.toJson<String>(
        $EmpleadosTable.$convertertipoPago.toJson(tipoPago),
      ),
      'tarifaCentavos': serializer.toJson<int>(tarifaCentavos),
      'activo': serializer.toJson<bool>(activo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Empleado copyWith({
    int? id,
    String? nombre,
    TipoPago? tipoPago,
    int? tarifaCentavos,
    bool? activo,
    DateTime? creadoEn,
  }) => Empleado(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    tipoPago: tipoPago ?? this.tipoPago,
    tarifaCentavos: tarifaCentavos ?? this.tarifaCentavos,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Empleado copyWithCompanion(EmpleadosCompanion data) {
    return Empleado(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      tipoPago: data.tipoPago.present ? data.tipoPago.value : this.tipoPago,
      tarifaCentavos: data.tarifaCentavos.present
          ? data.tarifaCentavos.value
          : this.tarifaCentavos,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Empleado(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipoPago: $tipoPago, ')
          ..write('tarifaCentavos: $tarifaCentavos, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, tipoPago, tarifaCentavos, activo, creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Empleado &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.tipoPago == this.tipoPago &&
          other.tarifaCentavos == this.tarifaCentavos &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn);
}

class EmpleadosCompanion extends UpdateCompanion<Empleado> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<TipoPago> tipoPago;
  final Value<int> tarifaCentavos;
  final Value<bool> activo;
  final Value<DateTime> creadoEn;
  const EmpleadosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.tipoPago = const Value.absent(),
    this.tarifaCentavos = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  EmpleadosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required TipoPago tipoPago,
    required int tarifaCentavos,
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       tipoPago = Value(tipoPago),
       tarifaCentavos = Value(tarifaCentavos);
  static Insertable<Empleado> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? tipoPago,
    Expression<int>? tarifaCentavos,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (tipoPago != null) 'tipo_pago': tipoPago,
      if (tarifaCentavos != null) 'tarifa_centavos': tarifaCentavos,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  EmpleadosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<TipoPago>? tipoPago,
    Value<int>? tarifaCentavos,
    Value<bool>? activo,
    Value<DateTime>? creadoEn,
  }) {
    return EmpleadosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipoPago: tipoPago ?? this.tipoPago,
      tarifaCentavos: tarifaCentavos ?? this.tarifaCentavos,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (tipoPago.present) {
      map['tipo_pago'] = Variable<String>(
        $EmpleadosTable.$convertertipoPago.toSql(tipoPago.value),
      );
    }
    if (tarifaCentavos.present) {
      map['tarifa_centavos'] = Variable<int>(tarifaCentavos.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmpleadosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('tipoPago: $tipoPago, ')
          ..write('tarifaCentavos: $tarifaCentavos, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $PagosEmpleadoTable extends PagosEmpleado
    with TableInfo<$PagosEmpleadoTable, PagoEmpleado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagosEmpleadoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _empleadoIdMeta = const VerificationMeta(
    'empleadoId',
  );
  @override
  late final GeneratedColumn<int> empleadoId = GeneratedColumn<int>(
    'empleado_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES empleados (id)',
    ),
  );
  static const VerificationMeta _unidadesTrabajadasMeta =
      const VerificationMeta('unidadesTrabajadas');
  @override
  late final GeneratedColumn<double> unidadesTrabajadas =
      GeneratedColumn<double>(
        'unidades_trabajadas',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tarifaAplicadaCentavosMeta =
      const VerificationMeta('tarifaAplicadaCentavos');
  @override
  late final GeneratedColumn<int> tarifaAplicadaCentavos = GeneratedColumn<int>(
    'tarifa_aplicada_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonificacionCentavosMeta =
      const VerificationMeta('bonificacionCentavos');
  @override
  late final GeneratedColumn<int> bonificacionCentavos = GeneratedColumn<int>(
    'bonificacion_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deduccionCentavosMeta = const VerificationMeta(
    'deduccionCentavos',
  );
  @override
  late final GeneratedColumn<int> deduccionCentavos = GeneratedColumn<int>(
    'deduccion_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPagadoCentavosMeta =
      const VerificationMeta('totalPagadoCentavos');
  @override
  late final GeneratedColumn<int> totalPagadoCentavos = GeneratedColumn<int>(
    'total_pagado_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _movimientoIdMeta = const VerificationMeta(
    'movimientoId',
  );
  @override
  late final GeneratedColumn<int> movimientoId = GeneratedColumn<int>(
    'movimiento_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES movimientos (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    empleadoId,
    unidadesTrabajadas,
    tarifaAplicadaCentavos,
    bonificacionCentavos,
    deduccionCentavos,
    totalPagadoCentavos,
    fecha,
    nota,
    movimientoId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pagos_empleado';
  @override
  VerificationContext validateIntegrity(
    Insertable<PagoEmpleado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('empleado_id')) {
      context.handle(
        _empleadoIdMeta,
        empleadoId.isAcceptableOrUnknown(data['empleado_id']!, _empleadoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_empleadoIdMeta);
    }
    if (data.containsKey('unidades_trabajadas')) {
      context.handle(
        _unidadesTrabajadasMeta,
        unidadesTrabajadas.isAcceptableOrUnknown(
          data['unidades_trabajadas']!,
          _unidadesTrabajadasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unidadesTrabajadasMeta);
    }
    if (data.containsKey('tarifa_aplicada_centavos')) {
      context.handle(
        _tarifaAplicadaCentavosMeta,
        tarifaAplicadaCentavos.isAcceptableOrUnknown(
          data['tarifa_aplicada_centavos']!,
          _tarifaAplicadaCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tarifaAplicadaCentavosMeta);
    }
    if (data.containsKey('bonificacion_centavos')) {
      context.handle(
        _bonificacionCentavosMeta,
        bonificacionCentavos.isAcceptableOrUnknown(
          data['bonificacion_centavos']!,
          _bonificacionCentavosMeta,
        ),
      );
    }
    if (data.containsKey('deduccion_centavos')) {
      context.handle(
        _deduccionCentavosMeta,
        deduccionCentavos.isAcceptableOrUnknown(
          data['deduccion_centavos']!,
          _deduccionCentavosMeta,
        ),
      );
    }
    if (data.containsKey('total_pagado_centavos')) {
      context.handle(
        _totalPagadoCentavosMeta,
        totalPagadoCentavos.isAcceptableOrUnknown(
          data['total_pagado_centavos']!,
          _totalPagadoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPagadoCentavosMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('movimiento_id')) {
      context.handle(
        _movimientoIdMeta,
        movimientoId.isAcceptableOrUnknown(
          data['movimiento_id']!,
          _movimientoIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PagoEmpleado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PagoEmpleado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      empleadoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}empleado_id'],
      )!,
      unidadesTrabajadas: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unidades_trabajadas'],
      )!,
      tarifaAplicadaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tarifa_aplicada_centavos'],
      )!,
      bonificacionCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bonificacion_centavos'],
      )!,
      deduccionCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deduccion_centavos'],
      )!,
      totalPagadoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pagado_centavos'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      movimientoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movimiento_id'],
      ),
    );
  }

  @override
  $PagosEmpleadoTable createAlias(String alias) {
    return $PagosEmpleadoTable(attachedDatabase, alias);
  }
}

class PagoEmpleado extends DataClass implements Insertable<PagoEmpleado> {
  final int id;
  final int empleadoId;

  /// Horas o días trabajados (según el tipo de pago). Admite decimales.
  final double unidadesTrabajadas;

  /// Tarifa vigente al momento del pago (queda como respaldo histórico).
  final int tarifaAplicadaCentavos;
  final int bonificacionCentavos;
  final int deduccionCentavos;

  /// Monto final pagado = tarifa x unidades + bonificación - deducciones.
  final int totalPagadoCentavos;
  final DateTime fecha;
  final String? nota;

  /// Gasto generado en la caja por este pago.
  final int? movimientoId;
  const PagoEmpleado({
    required this.id,
    required this.empleadoId,
    required this.unidadesTrabajadas,
    required this.tarifaAplicadaCentavos,
    required this.bonificacionCentavos,
    required this.deduccionCentavos,
    required this.totalPagadoCentavos,
    required this.fecha,
    this.nota,
    this.movimientoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['empleado_id'] = Variable<int>(empleadoId);
    map['unidades_trabajadas'] = Variable<double>(unidadesTrabajadas);
    map['tarifa_aplicada_centavos'] = Variable<int>(tarifaAplicadaCentavos);
    map['bonificacion_centavos'] = Variable<int>(bonificacionCentavos);
    map['deduccion_centavos'] = Variable<int>(deduccionCentavos);
    map['total_pagado_centavos'] = Variable<int>(totalPagadoCentavos);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || movimientoId != null) {
      map['movimiento_id'] = Variable<int>(movimientoId);
    }
    return map;
  }

  PagosEmpleadoCompanion toCompanion(bool nullToAbsent) {
    return PagosEmpleadoCompanion(
      id: Value(id),
      empleadoId: Value(empleadoId),
      unidadesTrabajadas: Value(unidadesTrabajadas),
      tarifaAplicadaCentavos: Value(tarifaAplicadaCentavos),
      bonificacionCentavos: Value(bonificacionCentavos),
      deduccionCentavos: Value(deduccionCentavos),
      totalPagadoCentavos: Value(totalPagadoCentavos),
      fecha: Value(fecha),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      movimientoId: movimientoId == null && nullToAbsent
          ? const Value.absent()
          : Value(movimientoId),
    );
  }

  factory PagoEmpleado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PagoEmpleado(
      id: serializer.fromJson<int>(json['id']),
      empleadoId: serializer.fromJson<int>(json['empleadoId']),
      unidadesTrabajadas: serializer.fromJson<double>(
        json['unidadesTrabajadas'],
      ),
      tarifaAplicadaCentavos: serializer.fromJson<int>(
        json['tarifaAplicadaCentavos'],
      ),
      bonificacionCentavos: serializer.fromJson<int>(
        json['bonificacionCentavos'],
      ),
      deduccionCentavos: serializer.fromJson<int>(json['deduccionCentavos']),
      totalPagadoCentavos: serializer.fromJson<int>(
        json['totalPagadoCentavos'],
      ),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      nota: serializer.fromJson<String?>(json['nota']),
      movimientoId: serializer.fromJson<int?>(json['movimientoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'empleadoId': serializer.toJson<int>(empleadoId),
      'unidadesTrabajadas': serializer.toJson<double>(unidadesTrabajadas),
      'tarifaAplicadaCentavos': serializer.toJson<int>(tarifaAplicadaCentavos),
      'bonificacionCentavos': serializer.toJson<int>(bonificacionCentavos),
      'deduccionCentavos': serializer.toJson<int>(deduccionCentavos),
      'totalPagadoCentavos': serializer.toJson<int>(totalPagadoCentavos),
      'fecha': serializer.toJson<DateTime>(fecha),
      'nota': serializer.toJson<String?>(nota),
      'movimientoId': serializer.toJson<int?>(movimientoId),
    };
  }

  PagoEmpleado copyWith({
    int? id,
    int? empleadoId,
    double? unidadesTrabajadas,
    int? tarifaAplicadaCentavos,
    int? bonificacionCentavos,
    int? deduccionCentavos,
    int? totalPagadoCentavos,
    DateTime? fecha,
    Value<String?> nota = const Value.absent(),
    Value<int?> movimientoId = const Value.absent(),
  }) => PagoEmpleado(
    id: id ?? this.id,
    empleadoId: empleadoId ?? this.empleadoId,
    unidadesTrabajadas: unidadesTrabajadas ?? this.unidadesTrabajadas,
    tarifaAplicadaCentavos:
        tarifaAplicadaCentavos ?? this.tarifaAplicadaCentavos,
    bonificacionCentavos: bonificacionCentavos ?? this.bonificacionCentavos,
    deduccionCentavos: deduccionCentavos ?? this.deduccionCentavos,
    totalPagadoCentavos: totalPagadoCentavos ?? this.totalPagadoCentavos,
    fecha: fecha ?? this.fecha,
    nota: nota.present ? nota.value : this.nota,
    movimientoId: movimientoId.present ? movimientoId.value : this.movimientoId,
  );
  PagoEmpleado copyWithCompanion(PagosEmpleadoCompanion data) {
    return PagoEmpleado(
      id: data.id.present ? data.id.value : this.id,
      empleadoId: data.empleadoId.present
          ? data.empleadoId.value
          : this.empleadoId,
      unidadesTrabajadas: data.unidadesTrabajadas.present
          ? data.unidadesTrabajadas.value
          : this.unidadesTrabajadas,
      tarifaAplicadaCentavos: data.tarifaAplicadaCentavos.present
          ? data.tarifaAplicadaCentavos.value
          : this.tarifaAplicadaCentavos,
      bonificacionCentavos: data.bonificacionCentavos.present
          ? data.bonificacionCentavos.value
          : this.bonificacionCentavos,
      deduccionCentavos: data.deduccionCentavos.present
          ? data.deduccionCentavos.value
          : this.deduccionCentavos,
      totalPagadoCentavos: data.totalPagadoCentavos.present
          ? data.totalPagadoCentavos.value
          : this.totalPagadoCentavos,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      nota: data.nota.present ? data.nota.value : this.nota,
      movimientoId: data.movimientoId.present
          ? data.movimientoId.value
          : this.movimientoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PagoEmpleado(')
          ..write('id: $id, ')
          ..write('empleadoId: $empleadoId, ')
          ..write('unidadesTrabajadas: $unidadesTrabajadas, ')
          ..write('tarifaAplicadaCentavos: $tarifaAplicadaCentavos, ')
          ..write('bonificacionCentavos: $bonificacionCentavos, ')
          ..write('deduccionCentavos: $deduccionCentavos, ')
          ..write('totalPagadoCentavos: $totalPagadoCentavos, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('movimientoId: $movimientoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    empleadoId,
    unidadesTrabajadas,
    tarifaAplicadaCentavos,
    bonificacionCentavos,
    deduccionCentavos,
    totalPagadoCentavos,
    fecha,
    nota,
    movimientoId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PagoEmpleado &&
          other.id == this.id &&
          other.empleadoId == this.empleadoId &&
          other.unidadesTrabajadas == this.unidadesTrabajadas &&
          other.tarifaAplicadaCentavos == this.tarifaAplicadaCentavos &&
          other.bonificacionCentavos == this.bonificacionCentavos &&
          other.deduccionCentavos == this.deduccionCentavos &&
          other.totalPagadoCentavos == this.totalPagadoCentavos &&
          other.fecha == this.fecha &&
          other.nota == this.nota &&
          other.movimientoId == this.movimientoId);
}

class PagosEmpleadoCompanion extends UpdateCompanion<PagoEmpleado> {
  final Value<int> id;
  final Value<int> empleadoId;
  final Value<double> unidadesTrabajadas;
  final Value<int> tarifaAplicadaCentavos;
  final Value<int> bonificacionCentavos;
  final Value<int> deduccionCentavos;
  final Value<int> totalPagadoCentavos;
  final Value<DateTime> fecha;
  final Value<String?> nota;
  final Value<int?> movimientoId;
  const PagosEmpleadoCompanion({
    this.id = const Value.absent(),
    this.empleadoId = const Value.absent(),
    this.unidadesTrabajadas = const Value.absent(),
    this.tarifaAplicadaCentavos = const Value.absent(),
    this.bonificacionCentavos = const Value.absent(),
    this.deduccionCentavos = const Value.absent(),
    this.totalPagadoCentavos = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.movimientoId = const Value.absent(),
  });
  PagosEmpleadoCompanion.insert({
    this.id = const Value.absent(),
    required int empleadoId,
    required double unidadesTrabajadas,
    required int tarifaAplicadaCentavos,
    this.bonificacionCentavos = const Value.absent(),
    this.deduccionCentavos = const Value.absent(),
    required int totalPagadoCentavos,
    required DateTime fecha,
    this.nota = const Value.absent(),
    this.movimientoId = const Value.absent(),
  }) : empleadoId = Value(empleadoId),
       unidadesTrabajadas = Value(unidadesTrabajadas),
       tarifaAplicadaCentavos = Value(tarifaAplicadaCentavos),
       totalPagadoCentavos = Value(totalPagadoCentavos),
       fecha = Value(fecha);
  static Insertable<PagoEmpleado> custom({
    Expression<int>? id,
    Expression<int>? empleadoId,
    Expression<double>? unidadesTrabajadas,
    Expression<int>? tarifaAplicadaCentavos,
    Expression<int>? bonificacionCentavos,
    Expression<int>? deduccionCentavos,
    Expression<int>? totalPagadoCentavos,
    Expression<DateTime>? fecha,
    Expression<String>? nota,
    Expression<int>? movimientoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (empleadoId != null) 'empleado_id': empleadoId,
      if (unidadesTrabajadas != null) 'unidades_trabajadas': unidadesTrabajadas,
      if (tarifaAplicadaCentavos != null)
        'tarifa_aplicada_centavos': tarifaAplicadaCentavos,
      if (bonificacionCentavos != null)
        'bonificacion_centavos': bonificacionCentavos,
      if (deduccionCentavos != null) 'deduccion_centavos': deduccionCentavos,
      if (totalPagadoCentavos != null)
        'total_pagado_centavos': totalPagadoCentavos,
      if (fecha != null) 'fecha': fecha,
      if (nota != null) 'nota': nota,
      if (movimientoId != null) 'movimiento_id': movimientoId,
    });
  }

  PagosEmpleadoCompanion copyWith({
    Value<int>? id,
    Value<int>? empleadoId,
    Value<double>? unidadesTrabajadas,
    Value<int>? tarifaAplicadaCentavos,
    Value<int>? bonificacionCentavos,
    Value<int>? deduccionCentavos,
    Value<int>? totalPagadoCentavos,
    Value<DateTime>? fecha,
    Value<String?>? nota,
    Value<int?>? movimientoId,
  }) {
    return PagosEmpleadoCompanion(
      id: id ?? this.id,
      empleadoId: empleadoId ?? this.empleadoId,
      unidadesTrabajadas: unidadesTrabajadas ?? this.unidadesTrabajadas,
      tarifaAplicadaCentavos:
          tarifaAplicadaCentavos ?? this.tarifaAplicadaCentavos,
      bonificacionCentavos: bonificacionCentavos ?? this.bonificacionCentavos,
      deduccionCentavos: deduccionCentavos ?? this.deduccionCentavos,
      totalPagadoCentavos: totalPagadoCentavos ?? this.totalPagadoCentavos,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
      movimientoId: movimientoId ?? this.movimientoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (empleadoId.present) {
      map['empleado_id'] = Variable<int>(empleadoId.value);
    }
    if (unidadesTrabajadas.present) {
      map['unidades_trabajadas'] = Variable<double>(unidadesTrabajadas.value);
    }
    if (tarifaAplicadaCentavos.present) {
      map['tarifa_aplicada_centavos'] = Variable<int>(
        tarifaAplicadaCentavos.value,
      );
    }
    if (bonificacionCentavos.present) {
      map['bonificacion_centavos'] = Variable<int>(bonificacionCentavos.value);
    }
    if (deduccionCentavos.present) {
      map['deduccion_centavos'] = Variable<int>(deduccionCentavos.value);
    }
    if (totalPagadoCentavos.present) {
      map['total_pagado_centavos'] = Variable<int>(totalPagadoCentavos.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (movimientoId.present) {
      map['movimiento_id'] = Variable<int>(movimientoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagosEmpleadoCompanion(')
          ..write('id: $id, ')
          ..write('empleadoId: $empleadoId, ')
          ..write('unidadesTrabajadas: $unidadesTrabajadas, ')
          ..write('tarifaAplicadaCentavos: $tarifaAplicadaCentavos, ')
          ..write('bonificacionCentavos: $bonificacionCentavos, ')
          ..write('deduccionCentavos: $deduccionCentavos, ')
          ..write('totalPagadoCentavos: $totalPagadoCentavos, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('movimientoId: $movimientoId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NegociosTable negocios = $NegociosTable(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $MovimientosFiadoTable movimientosFiado = $MovimientosFiadoTable(
    this,
  );
  late final $EmpleadosTable empleados = $EmpleadosTable(this);
  late final $PagosEmpleadoTable pagosEmpleado = $PagosEmpleadoTable(this);
  late final Index idxMovimientosFecha = Index(
    'idx_movimientos_fecha',
    'CREATE INDEX idx_movimientos_fecha ON movimientos (fecha)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    negocios,
    categorias,
    movimientos,
    clientes,
    movimientosFiado,
    empleados,
    pagosEmpleado,
    idxMovimientosFecha,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimientos', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimientos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pagos_empleado', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$NegociosTableCreateCompanionBuilder = NegociosCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> tipoNegocio,
  Value<String> moneda,
  Value<int> saldoInicialCentavos,
  Value<DateTime> creadoEn,
});
typedef $$NegociosTableUpdateCompanionBuilder = NegociosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> tipoNegocio,
  Value<String> moneda,
  Value<int> saldoInicialCentavos,
  Value<DateTime> creadoEn,
});

class $$NegociosTableFilterComposer
    extends Composer<_$AppDatabase, $NegociosTable> {
  $$NegociosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoNegocio => $composableBuilder(
    column: $table.tipoNegocio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoInicialCentavos => $composableBuilder(
    column: $table.saldoInicialCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NegociosTableOrderingComposer
    extends Composer<_$AppDatabase, $NegociosTable> {
  $$NegociosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoNegocio => $composableBuilder(
    column: $table.tipoNegocio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoInicialCentavos => $composableBuilder(
    column: $table.saldoInicialCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NegociosTableAnnotationComposer
    extends Composer<_$AppDatabase, $NegociosTable> {
  $$NegociosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get tipoNegocio => $composableBuilder(
    column: $table.tipoNegocio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<int> get saldoInicialCentavos => $composableBuilder(
    column: $table.saldoInicialCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$NegociosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NegociosTable,
          Negocio,
          $$NegociosTableFilterComposer,
          $$NegociosTableOrderingComposer,
          $$NegociosTableAnnotationComposer,
          $$NegociosTableCreateCompanionBuilder,
          $$NegociosTableUpdateCompanionBuilder,
          (Negocio, BaseReferences<_$AppDatabase, $NegociosTable, Negocio>),
          Negocio,
          PrefetchHooks Function()
        > {
  $$NegociosTableTableManager(_$AppDatabase db, $NegociosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NegociosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NegociosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NegociosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> tipoNegocio = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<int> saldoInicialCentavos = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => NegociosCompanion(
                id: id,
                nombre: nombre,
                tipoNegocio: tipoNegocio,
                moneda: moneda,
                saldoInicialCentavos: saldoInicialCentavos,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> tipoNegocio = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<int> saldoInicialCentavos = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => NegociosCompanion.insert(
                id: id,
                nombre: nombre,
                tipoNegocio: tipoNegocio,
                moneda: moneda,
                saldoInicialCentavos: saldoInicialCentavos,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NegociosTable, Negocio>(table),
                  BaseReferences<_$AppDatabase, $NegociosTable, Negocio>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NegociosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NegociosTable,
      Negocio,
      $$NegociosTableFilterComposer,
      $$NegociosTableOrderingComposer,
      $$NegociosTableAnnotationComposer,
      $$NegociosTableCreateCompanionBuilder,
      $$NegociosTableUpdateCompanionBuilder,
      (Negocio, BaseReferences<_$AppDatabase, $NegociosTable, Negocio>),
      Negocio,
      PrefetchHooks Function()
    >;
typedef $$CategoriasTableCreateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  required String nombre,
  required TipoMovimiento tipo,
  Value<bool> esPredeterminada,
});
typedef $$CategoriasTableUpdateCompanionBuilder = CategoriasCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<TipoMovimiento> tipo,
  Value<bool> esPredeterminada,
});

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovimientosTable, List<Movimiento>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: 'categorias__id__movimientos__categoria_id',
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMovimiento, TipoMovimiento, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get esPredeterminada => $composableBuilder(
    column: $table.esPredeterminada,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esPredeterminada => $composableBuilder(
    column: $table.esPredeterminada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMovimiento, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<bool> get esPredeterminada => $composableBuilder(
    column: $table.esPredeterminada,
    builder: (column) => column,
  );

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({bool movimientosRefs})
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<TipoMovimiento> tipo = const Value.absent(),
                Value<bool> esPredeterminada = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                tipo: tipo,
                esPredeterminada: esPredeterminada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required TipoMovimiento tipo,
                Value<bool> esPredeterminada = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                tipo: tipo,
                esPredeterminada: esPredeterminada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriasTable, Categoria>(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({movimientosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (movimientosRefs) db.movimientos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movimientosRefs)
                    await $_getPrefetchedData<
                      Categoria,
                      $CategoriasTable,
                      Movimiento
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriasTableReferences
                          ._movimientosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriasTableReferences(
                            db,
                            table,
                            p0,
                          ).movimientosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.categoriaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({bool movimientosRefs})
    >;
typedef $$MovimientosTableCreateCompanionBuilder =
    MovimientosCompanion Function({
      Value<int> id,
      required TipoMovimiento tipo,
      required String concepto,
      Value<int?> categoriaId,
      required int montoCentavos,
      required DateTime fecha,
      Value<OrigenMovimiento> origen,
      Value<int?> origenId,
    });
typedef $$MovimientosTableUpdateCompanionBuilder =
    MovimientosCompanion Function({
      Value<int> id,
      Value<TipoMovimiento> tipo,
      Value<String> concepto,
      Value<int?> categoriaId,
      Value<int> montoCentavos,
      Value<DateTime> fecha,
      Value<OrigenMovimiento> origen,
      Value<int?> origenId,
    });

final class $$MovimientosTableReferences
    extends BaseReferences<_$AppDatabase, $MovimientosTable, Movimiento> {
  $$MovimientosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('movimientos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PagosEmpleadoTable, List<PagoEmpleado>>
  _pagosEmpleadoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pagosEmpleado,
    aliasName: 'movimientos__id__pagos_empleado__movimiento_id',
  );

  $$PagosEmpleadoTableProcessedTableManager get pagosEmpleadoRefs {
    final manager = $$PagosEmpleadoTableTableManager(
      $_db,
      $_db.pagosEmpleado,
    ).filter((f) => f.movimientoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosEmpleadoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MovimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMovimiento, TipoMovimiento, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrigenMovimiento, OrigenMovimiento, String>
  get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get origenId => $composableBuilder(
    column: $table.origenId,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pagosEmpleadoRefs(
    Expression<bool> Function($$PagosEmpleadoTableFilterComposer f) f,
  ) {
    final $$PagosEmpleadoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagosEmpleado,
      getReferencedColumn: (t) => t.movimientoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosEmpleadoTableFilterComposer(
            $db: $db,
            $table: $db.pagosEmpleado,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concepto => $composableBuilder(
    column: $table.concepto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origen => $composableBuilder(
    column: $table.origen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get origenId => $composableBuilder(
    column: $table.origenId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMovimiento, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrigenMovimiento, String> get origen =>
      $composableBuilder(column: $table.origen, builder: (column) => column);

  GeneratedColumn<int> get origenId =>
      $composableBuilder(column: $table.origenId, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pagosEmpleadoRefs<T extends Object>(
    Expression<T> Function($$PagosEmpleadoTableAnnotationComposer a) f,
  ) {
    final $$PagosEmpleadoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagosEmpleado,
      getReferencedColumn: (t) => t.movimientoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosEmpleadoTableAnnotationComposer(
            $db: $db,
            $table: $db.pagosEmpleado,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MovimientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosTable,
          Movimiento,
          $$MovimientosTableFilterComposer,
          $$MovimientosTableOrderingComposer,
          $$MovimientosTableAnnotationComposer,
          $$MovimientosTableCreateCompanionBuilder,
          $$MovimientosTableUpdateCompanionBuilder,
          (Movimiento, $$MovimientosTableReferences),
          Movimiento,
          PrefetchHooks Function({bool categoriaId, bool pagosEmpleadoRefs})
        > {
  $$MovimientosTableTableManager(_$AppDatabase db, $MovimientosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TipoMovimiento> tipo = const Value.absent(),
                Value<String> concepto = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<OrigenMovimiento> origen = const Value.absent(),
                Value<int?> origenId = const Value.absent(),
              }) => MovimientosCompanion(
                id: id,
                tipo: tipo,
                concepto: concepto,
                categoriaId: categoriaId,
                montoCentavos: montoCentavos,
                fecha: fecha,
                origen: origen,
                origenId: origenId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TipoMovimiento tipo,
                required String concepto,
                Value<int?> categoriaId = const Value.absent(),
                required int montoCentavos,
                required DateTime fecha,
                Value<OrigenMovimiento> origen = const Value.absent(),
                Value<int?> origenId = const Value.absent(),
              }) => MovimientosCompanion.insert(
                id: id,
                tipo: tipo,
                concepto: concepto,
                categoriaId: categoriaId,
                montoCentavos: montoCentavos,
                fecha: fecha,
                origen: origen,
                origenId: origenId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MovimientosTable, Movimiento>(table),
                  $$MovimientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoriaId = false, pagosEmpleadoRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pagosEmpleadoRefs) db.pagosEmpleado,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoriaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoriaId,
                            referencedTable: $$MovimientosTableReferences
                                ._categoriaIdTable(db),
                            referencedColumn: $$MovimientosTableReferences
                                ._categoriaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pagosEmpleadoRefs)
                        await $_getPrefetchedData<
                          Movimiento,
                          $MovimientosTable,
                          PagoEmpleado
                        >(
                          currentTable: table,
                          referencedTable: $$MovimientosTableReferences
                              ._pagosEmpleadoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MovimientosTableReferences(
                                db,
                                table,
                                p0,
                              ).pagosEmpleadoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.movimientoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MovimientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosTable,
      Movimiento,
      $$MovimientosTableFilterComposer,
      $$MovimientosTableOrderingComposer,
      $$MovimientosTableAnnotationComposer,
      $$MovimientosTableCreateCompanionBuilder,
      $$MovimientosTableUpdateCompanionBuilder,
      (Movimiento, $$MovimientosTableReferences),
      Movimiento,
      PrefetchHooks Function({bool categoriaId, bool pagosEmpleadoRefs})
    >;
typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> telefono,
  Value<bool> activo,
  Value<DateTime> creadoEn,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> telefono,
  Value<bool> activo,
  Value<DateTime> creadoEn,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MovimientosFiadoTable, List<MovimientoFiado>>
  _movimientosFiadoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientosFiado,
    aliasName: 'clientes__id__movimientos_fiado__cliente_id',
  );

  $$MovimientosFiadoTableProcessedTableManager get movimientosFiadoRefs {
    final manager = $$MovimientosFiadoTableTableManager(
      $_db,
      $_db.movimientosFiado,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientosFiadoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movimientosFiadoRefs(
    Expression<bool> Function($$MovimientosFiadoTableFilterComposer f) f,
  ) {
    final $$MovimientosFiadoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosFiado,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosFiadoTableFilterComposer(
            $db: $db,
            $table: $db.movimientosFiado,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> movimientosFiadoRefs<T extends Object>(
    Expression<T> Function($$MovimientosFiadoTableAnnotationComposer a) f,
  ) {
    final $$MovimientosFiadoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientosFiado,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosFiadoTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientosFiado,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({bool movimientosFiadoRefs})
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                activo: activo,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> telefono = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                activo: activo,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientesTable, Cliente>(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({movimientosFiadoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (movimientosFiadoRefs) db.movimientosFiado,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (movimientosFiadoRefs)
                    await $_getPrefetchedData<
                      Cliente,
                      $ClientesTable,
                      MovimientoFiado
                    >(
                      currentTable: table,
                      referencedTable: $$ClientesTableReferences
                          ._movimientosFiadoRefsTable(db),
                      managerFromTypedResult: (p0) => $$ClientesTableReferences(
                        db,
                        table,
                        p0,
                      ).movimientosFiadoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.clienteId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({bool movimientosFiadoRefs})
    >;
typedef $$MovimientosFiadoTableCreateCompanionBuilder =
    MovimientosFiadoCompanion Function({
      Value<int> id,
      required int clienteId,
      required TipoFiado tipo,
      required int montoCentavos,
      Value<String?> nota,
      required DateTime fecha,
    });
typedef $$MovimientosFiadoTableUpdateCompanionBuilder =
    MovimientosFiadoCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<TipoFiado> tipo,
      Value<int> montoCentavos,
      Value<String?> nota,
      Value<DateTime> fecha,
    });

final class $$MovimientosFiadoTableReferences
    extends
        BaseReferences<_$AppDatabase, $MovimientosFiadoTable, MovimientoFiado> {
  $$MovimientosFiadoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('movimientos_fiado__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosFiadoTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosFiadoTable> {
  $$MovimientosFiadoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoFiado, TipoFiado, String> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosFiadoTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosFiadoTable> {
  $$MovimientosFiadoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosFiadoTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosFiadoTable> {
  $$MovimientosFiadoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoFiado, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosFiadoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosFiadoTable,
          MovimientoFiado,
          $$MovimientosFiadoTableFilterComposer,
          $$MovimientosFiadoTableOrderingComposer,
          $$MovimientosFiadoTableAnnotationComposer,
          $$MovimientosFiadoTableCreateCompanionBuilder,
          $$MovimientosFiadoTableUpdateCompanionBuilder,
          (MovimientoFiado, $$MovimientosFiadoTableReferences),
          MovimientoFiado,
          PrefetchHooks Function({bool clienteId})
        > {
  $$MovimientosFiadoTableTableManager(
    _$AppDatabase db,
    $MovimientosFiadoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosFiadoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosFiadoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosFiadoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<TipoFiado> tipo = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
              }) => MovimientosFiadoCompanion(
                id: id,
                clienteId: clienteId,
                tipo: tipo,
                montoCentavos: montoCentavos,
                nota: nota,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                required TipoFiado tipo,
                required int montoCentavos,
                Value<String?> nota = const Value.absent(),
                required DateTime fecha,
              }) => MovimientosFiadoCompanion.insert(
                id: id,
                clienteId: clienteId,
                tipo: tipo,
                montoCentavos: montoCentavos,
                nota: nota,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MovimientosFiadoTable, MovimientoFiado>(table),
                  $$MovimientosFiadoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.clienteId,
                        referencedTable: $$MovimientosFiadoTableReferences
                            ._clienteIdTable(db),
                        referencedColumn: $$MovimientosFiadoTableReferences
                            ._clienteIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovimientosFiadoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosFiadoTable,
      MovimientoFiado,
      $$MovimientosFiadoTableFilterComposer,
      $$MovimientosFiadoTableOrderingComposer,
      $$MovimientosFiadoTableAnnotationComposer,
      $$MovimientosFiadoTableCreateCompanionBuilder,
      $$MovimientosFiadoTableUpdateCompanionBuilder,
      (MovimientoFiado, $$MovimientosFiadoTableReferences),
      MovimientoFiado,
      PrefetchHooks Function({bool clienteId})
    >;
typedef $$EmpleadosTableCreateCompanionBuilder = EmpleadosCompanion Function({
  Value<int> id,
  required String nombre,
  required TipoPago tipoPago,
  required int tarifaCentavos,
  Value<bool> activo,
  Value<DateTime> creadoEn,
});
typedef $$EmpleadosTableUpdateCompanionBuilder = EmpleadosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<TipoPago> tipoPago,
  Value<int> tarifaCentavos,
  Value<bool> activo,
  Value<DateTime> creadoEn,
});

final class $$EmpleadosTableReferences
    extends BaseReferences<_$AppDatabase, $EmpleadosTable, Empleado> {
  $$EmpleadosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PagosEmpleadoTable, List<PagoEmpleado>>
  _pagosEmpleadoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pagosEmpleado,
    aliasName: 'empleados__id__pagos_empleado__empleado_id',
  );

  $$PagosEmpleadoTableProcessedTableManager get pagosEmpleadoRefs {
    final manager = $$PagosEmpleadoTableTableManager(
      $_db,
      $_db.pagosEmpleado,
    ).filter((f) => f.empleadoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosEmpleadoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmpleadosTableFilterComposer
    extends Composer<_$AppDatabase, $EmpleadosTable> {
  $$EmpleadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoPago, TipoPago, String> get tipoPago =>
      $composableBuilder(
        column: $table.tipoPago,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get tarifaCentavos => $composableBuilder(
    column: $table.tarifaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pagosEmpleadoRefs(
    Expression<bool> Function($$PagosEmpleadoTableFilterComposer f) f,
  ) {
    final $$PagosEmpleadoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagosEmpleado,
      getReferencedColumn: (t) => t.empleadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosEmpleadoTableFilterComposer(
            $db: $db,
            $table: $db.pagosEmpleado,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmpleadosTableOrderingComposer
    extends Composer<_$AppDatabase, $EmpleadosTable> {
  $$EmpleadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoPago => $composableBuilder(
    column: $table.tipoPago,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaCentavos => $composableBuilder(
    column: $table.tarifaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmpleadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmpleadosTable> {
  $$EmpleadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoPago, String> get tipoPago =>
      $composableBuilder(column: $table.tipoPago, builder: (column) => column);

  GeneratedColumn<int> get tarifaCentavos => $composableBuilder(
    column: $table.tarifaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> pagosEmpleadoRefs<T extends Object>(
    Expression<T> Function($$PagosEmpleadoTableAnnotationComposer a) f,
  ) {
    final $$PagosEmpleadoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pagosEmpleado,
      getReferencedColumn: (t) => t.empleadoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PagosEmpleadoTableAnnotationComposer(
            $db: $db,
            $table: $db.pagosEmpleado,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmpleadosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmpleadosTable,
          Empleado,
          $$EmpleadosTableFilterComposer,
          $$EmpleadosTableOrderingComposer,
          $$EmpleadosTableAnnotationComposer,
          $$EmpleadosTableCreateCompanionBuilder,
          $$EmpleadosTableUpdateCompanionBuilder,
          (Empleado, $$EmpleadosTableReferences),
          Empleado,
          PrefetchHooks Function({bool pagosEmpleadoRefs})
        > {
  $$EmpleadosTableTableManager(_$AppDatabase db, $EmpleadosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmpleadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmpleadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmpleadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<TipoPago> tipoPago = const Value.absent(),
                Value<int> tarifaCentavos = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => EmpleadosCompanion(
                id: id,
                nombre: nombre,
                tipoPago: tipoPago,
                tarifaCentavos: tarifaCentavos,
                activo: activo,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required TipoPago tipoPago,
                required int tarifaCentavos,
                Value<bool> activo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => EmpleadosCompanion.insert(
                id: id,
                nombre: nombre,
                tipoPago: tipoPago,
                tarifaCentavos: tarifaCentavos,
                activo: activo,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmpleadosTable, Empleado>(table),
                  $$EmpleadosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pagosEmpleadoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (pagosEmpleadoRefs) db.pagosEmpleado,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pagosEmpleadoRefs)
                    await $_getPrefetchedData<
                      Empleado,
                      $EmpleadosTable,
                      PagoEmpleado
                    >(
                      currentTable: table,
                      referencedTable: $$EmpleadosTableReferences
                          ._pagosEmpleadoRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmpleadosTableReferences(
                            db,
                            table,
                            p0,
                          ).pagosEmpleadoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.empleadoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmpleadosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmpleadosTable,
      Empleado,
      $$EmpleadosTableFilterComposer,
      $$EmpleadosTableOrderingComposer,
      $$EmpleadosTableAnnotationComposer,
      $$EmpleadosTableCreateCompanionBuilder,
      $$EmpleadosTableUpdateCompanionBuilder,
      (Empleado, $$EmpleadosTableReferences),
      Empleado,
      PrefetchHooks Function({bool pagosEmpleadoRefs})
    >;
typedef $$PagosEmpleadoTableCreateCompanionBuilder =
    PagosEmpleadoCompanion Function({
      Value<int> id,
      required int empleadoId,
      required double unidadesTrabajadas,
      required int tarifaAplicadaCentavos,
      Value<int> bonificacionCentavos,
      Value<int> deduccionCentavos,
      required int totalPagadoCentavos,
      required DateTime fecha,
      Value<String?> nota,
      Value<int?> movimientoId,
    });
typedef $$PagosEmpleadoTableUpdateCompanionBuilder =
    PagosEmpleadoCompanion Function({
      Value<int> id,
      Value<int> empleadoId,
      Value<double> unidadesTrabajadas,
      Value<int> tarifaAplicadaCentavos,
      Value<int> bonificacionCentavos,
      Value<int> deduccionCentavos,
      Value<int> totalPagadoCentavos,
      Value<DateTime> fecha,
      Value<String?> nota,
      Value<int?> movimientoId,
    });

final class $$PagosEmpleadoTableReferences
    extends BaseReferences<_$AppDatabase, $PagosEmpleadoTable, PagoEmpleado> {
  $$PagosEmpleadoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmpleadosTable _empleadoIdTable(_$AppDatabase db) =>
      db.empleados.createAlias('pagos_empleado__empleado_id__empleados__id');

  $$EmpleadosTableProcessedTableManager get empleadoId {
    final $_column = $_itemColumn<int>('empleado_id')!;

    final manager = $$EmpleadosTableTableManager(
      $_db,
      $_db.empleados,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_empleadoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MovimientosTable _movimientoIdTable(_$AppDatabase db) => db
      .movimientos
      .createAlias('pagos_empleado__movimiento_id__movimientos__id');

  $$MovimientosTableProcessedTableManager? get movimientoId {
    final $_column = $_itemColumn<int>('movimiento_id');
    if ($_column == null) return null;
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movimientoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PagosEmpleadoTableFilterComposer
    extends Composer<_$AppDatabase, $PagosEmpleadoTable> {
  $$PagosEmpleadoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unidadesTrabajadas => $composableBuilder(
    column: $table.unidadesTrabajadas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tarifaAplicadaCentavos => $composableBuilder(
    column: $table.tarifaAplicadaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bonificacionCentavos => $composableBuilder(
    column: $table.bonificacionCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deduccionCentavos => $composableBuilder(
    column: $table.deduccionCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPagadoCentavos => $composableBuilder(
    column: $table.totalPagadoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  $$EmpleadosTableFilterComposer get empleadoId {
    final $$EmpleadosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.empleadoId,
      referencedTable: $db.empleados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmpleadosTableFilterComposer(
            $db: $db,
            $table: $db.empleados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableFilterComposer get movimientoId {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosEmpleadoTableOrderingComposer
    extends Composer<_$AppDatabase, $PagosEmpleadoTable> {
  $$PagosEmpleadoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unidadesTrabajadas => $composableBuilder(
    column: $table.unidadesTrabajadas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tarifaAplicadaCentavos => $composableBuilder(
    column: $table.tarifaAplicadaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bonificacionCentavos => $composableBuilder(
    column: $table.bonificacionCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deduccionCentavos => $composableBuilder(
    column: $table.deduccionCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPagadoCentavos => $composableBuilder(
    column: $table.totalPagadoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmpleadosTableOrderingComposer get empleadoId {
    final $$EmpleadosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.empleadoId,
      referencedTable: $db.empleados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmpleadosTableOrderingComposer(
            $db: $db,
            $table: $db.empleados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableOrderingComposer get movimientoId {
    final $$MovimientosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableOrderingComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosEmpleadoTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagosEmpleadoTable> {
  $$PagosEmpleadoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get unidadesTrabajadas => $composableBuilder(
    column: $table.unidadesTrabajadas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tarifaAplicadaCentavos => $composableBuilder(
    column: $table.tarifaAplicadaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bonificacionCentavos => $composableBuilder(
    column: $table.bonificacionCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deduccionCentavos => $composableBuilder(
    column: $table.deduccionCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPagadoCentavos => $composableBuilder(
    column: $table.totalPagadoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  $$EmpleadosTableAnnotationComposer get empleadoId {
    final $$EmpleadosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.empleadoId,
      referencedTable: $db.empleados,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmpleadosTableAnnotationComposer(
            $db: $db,
            $table: $db.empleados,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MovimientosTableAnnotationComposer get movimientoId {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movimientoId,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PagosEmpleadoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PagosEmpleadoTable,
          PagoEmpleado,
          $$PagosEmpleadoTableFilterComposer,
          $$PagosEmpleadoTableOrderingComposer,
          $$PagosEmpleadoTableAnnotationComposer,
          $$PagosEmpleadoTableCreateCompanionBuilder,
          $$PagosEmpleadoTableUpdateCompanionBuilder,
          (PagoEmpleado, $$PagosEmpleadoTableReferences),
          PagoEmpleado,
          PrefetchHooks Function({bool empleadoId, bool movimientoId})
        > {
  $$PagosEmpleadoTableTableManager(_$AppDatabase db, $PagosEmpleadoTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagosEmpleadoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagosEmpleadoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagosEmpleadoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> empleadoId = const Value.absent(),
                Value<double> unidadesTrabajadas = const Value.absent(),
                Value<int> tarifaAplicadaCentavos = const Value.absent(),
                Value<int> bonificacionCentavos = const Value.absent(),
                Value<int> deduccionCentavos = const Value.absent(),
                Value<int> totalPagadoCentavos = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<int?> movimientoId = const Value.absent(),
              }) => PagosEmpleadoCompanion(
                id: id,
                empleadoId: empleadoId,
                unidadesTrabajadas: unidadesTrabajadas,
                tarifaAplicadaCentavos: tarifaAplicadaCentavos,
                bonificacionCentavos: bonificacionCentavos,
                deduccionCentavos: deduccionCentavos,
                totalPagadoCentavos: totalPagadoCentavos,
                fecha: fecha,
                nota: nota,
                movimientoId: movimientoId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int empleadoId,
                required double unidadesTrabajadas,
                required int tarifaAplicadaCentavos,
                Value<int> bonificacionCentavos = const Value.absent(),
                Value<int> deduccionCentavos = const Value.absent(),
                required int totalPagadoCentavos,
                required DateTime fecha,
                Value<String?> nota = const Value.absent(),
                Value<int?> movimientoId = const Value.absent(),
              }) => PagosEmpleadoCompanion.insert(
                id: id,
                empleadoId: empleadoId,
                unidadesTrabajadas: unidadesTrabajadas,
                tarifaAplicadaCentavos: tarifaAplicadaCentavos,
                bonificacionCentavos: bonificacionCentavos,
                deduccionCentavos: deduccionCentavos,
                totalPagadoCentavos: totalPagadoCentavos,
                fecha: fecha,
                nota: nota,
                movimientoId: movimientoId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PagosEmpleadoTable, PagoEmpleado>(table),
                  $$PagosEmpleadoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({empleadoId = false, movimientoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (empleadoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.empleadoId,
                        referencedTable: $$PagosEmpleadoTableReferences
                            ._empleadoIdTable(db),
                        referencedColumn: $$PagosEmpleadoTableReferences
                            ._empleadoIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (movimientoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.movimientoId,
                        referencedTable: $$PagosEmpleadoTableReferences
                            ._movimientoIdTable(db),
                        referencedColumn: $$PagosEmpleadoTableReferences
                            ._movimientoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PagosEmpleadoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PagosEmpleadoTable,
      PagoEmpleado,
      $$PagosEmpleadoTableFilterComposer,
      $$PagosEmpleadoTableOrderingComposer,
      $$PagosEmpleadoTableAnnotationComposer,
      $$PagosEmpleadoTableCreateCompanionBuilder,
      $$PagosEmpleadoTableUpdateCompanionBuilder,
      (PagoEmpleado, $$PagosEmpleadoTableReferences),
      PagoEmpleado,
      PrefetchHooks Function({bool empleadoId, bool movimientoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NegociosTableTableManager get negocios =>
      $$NegociosTableTableManager(_db, _db.negocios);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$MovimientosFiadoTableTableManager get movimientosFiado =>
      $$MovimientosFiadoTableTableManager(_db, _db.movimientosFiado);
  $$EmpleadosTableTableManager get empleados =>
      $$EmpleadosTableTableManager(_db, _db.empleados);
  $$PagosEmpleadoTableTableManager get pagosEmpleado =>
      $$PagosEmpleadoTableTableManager(_db, _db.pagosEmpleado);
}
