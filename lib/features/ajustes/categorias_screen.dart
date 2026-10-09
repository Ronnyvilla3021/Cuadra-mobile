import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/database/categorias_queries.dart';
import '../../data/database/enums.dart';
import '../../data/providers.dart';
import '../caja/caja_providers.dart';

/// Administrar las categorías de ingresos y gastos.
/// Las predeterminadas se pueden usar pero no cambiar ni borrar.
class CategoriasScreen extends ConsumerStatefulWidget {
  const CategoriasScreen({super.key});

  @override
  ConsumerState<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends ConsumerState<CategoriasScreen> {
  TipoMovimiento _tipo = TipoMovimiento.gasto;

  Future<String?> _pedirNombre({String inicial = '', required String titulo}) {
    return showDialog<String>(
      context: context,
      builder: (_) => _NombreCategoriaDialog(titulo: titulo, inicial: inicial),
    );
  }

  Future<void> _ejecutar(Future<void> Function() accion) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await accion();
    } on StateError catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el cambio.')),
      );
    }
  }

  Future<void> _nueva() async {
    final nombre = await _pedirNombre(titulo: 'Nueva categoría');
    if (nombre == null) return;
    await _ejecutar(
      () => ref.read(appDatabaseProvider).crearCategoria(nombre, _tipo),
    );
  }

  Future<void> _renombrar(Categoria c) async {
    final nombre = await _pedirNombre(titulo: 'Cambiar nombre', inicial: c.nombre);
    if (nombre == null || nombre == c.nombre) return;
    await _ejecutar(
      () => ref.read(appDatabaseProvider).renombrarCategoria(c.id, nombre),
    );
  }

  Future<void> _eliminar(Categoria c) async {
    final db = ref.read(appDatabaseProvider);
    final cuantos = await db.contarMovimientosDeCategoria(c.id);
    if (!mounted) return;
    final destino = c.tipo == TipoMovimiento.ingreso ? 'Otros ingresos' : 'Otros gastos';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar "${c.nombre}"'),
        content: Text(
          cuantos == 0
              ? 'Esta categoría no tiene movimientos.'
              : 'Sus $cuantos movimientos pasarán a "$destino".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _ejecutar(() => db.eliminarCategoria(c.id));
  }

  @override
  Widget build(BuildContext context) {
    final todas = ref.watch(categoriasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nueva,
        icon: const Icon(Icons.add),
        label: const Text('Nueva categoría'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<TipoMovimiento>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: TipoMovimiento.gasto,
                  icon: Icon(Icons.arrow_upward),
                  label: Text('Gastos'),
                ),
                ButtonSegment(
                  value: TipoMovimiento.ingreso,
                  icon: Icon(Icons.arrow_downward),
                  label: Text('Ingresos'),
                ),
              ],
              selected: {_tipo},
              onSelectionChanged: (s) => setState(() => _tipo = s.first),
            ),
          ),
          Expanded(
            child: todas.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (lista) {
                final visibles = lista.where((c) => c.tipo == _tipo).toList();
                return ListView(
                  padding: const EdgeInsets.only(bottom: 96),
                  children: [
                    for (final c in visibles)
                      ListTile(
                        leading: Icon(
                          c.esPredeterminada ? Icons.label : Icons.label_outline,
                        ),
                        title: Text(c.nombre),
                        subtitle: c.esPredeterminada ? const Text('Predeterminada') : null,
                        trailing: c.esPredeterminada
                            ? null
                            : PopupMenuButton<String>(
                                onSelected: (v) =>
                                    v == 'renombrar' ? _renombrar(c) : _eliminar(c),
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'renombrar',
                                    child: Text('Cambiar nombre'),
                                  ),
                                  PopupMenuItem(
                                    value: 'eliminar',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NombreCategoriaDialog extends StatefulWidget {
  const _NombreCategoriaDialog({required this.titulo, required this.inicial});

  final String titulo;
  final String inicial;

  @override
  State<_NombreCategoriaDialog> createState() => _NombreCategoriaDialogState();
}

class _NombreCategoriaDialogState extends State<_NombreCategoriaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ctrl = TextEditingController(text: widget.inicial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_ctrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _ctrl,
          autofocus: true,
          maxLength: 40,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Nombre', counterText: ''),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) ? 'Escribe un nombre' : null,
          onFieldSubmitted: (_) => _guardar(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
