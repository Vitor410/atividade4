import 'package:flutter/material.dart';
import 'dart:io';
import '../models/collection_model.dart';
import '../models/collection_item_model.dart';
import 'collection_item_form_screen.dart';

class CollectionDetailScreen extends StatefulWidget {
  final Collection collection;
  final List<CollectionItem> items;
  final Function(CollectionItem) onAddItem;

  const CollectionDetailScreen({
    Key? key,
    required this.collection,
    required this.items,
    required this.onAddItem,
  }) : super(key: key);

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  late List<CollectionItem> _items = List.from(widget.items); // Inicialização direta

  void _editItem(int idx) async {
    final item = _items[idx];
    final editedItem = await Navigator.push<CollectionItem>(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionItemFormScreen(
          collectionId: widget.collection.id ?? 0,
          isHQ: widget.collection.tipoItem.toLowerCase() == 'hq',
          // Passe os dados do item para edição
          key: ValueKey(item.id ?? idx),
        ),
        settings: RouteSettings(
          arguments: item,
        ),
      ),
    );
    if (editedItem != null) {
      setState(() {
        _items[idx] = editedItem;
      });
    }
  }

  void _deleteItem(int idx) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir item'),
        content: Text('Tem certeza que deseja excluir este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _items.removeAt(idx);
              });
              Navigator.pop(context);
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tipo = widget.collection.tipoItem;
    return Scaffold(
      appBar: AppBar(title: Text(widget.collection.nome)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(widget.collection.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Text(widget.collection.descricao),
                trailing: Chip(
                  label: Text(tipo),
                  backgroundColor: Colors.deepPurple[50],
                  labelStyle: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Itens da coleção (${tipo}):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? Center(child: Text('Nenhum item cadastrado nesta coleção.'))
                  : ListView.separated(
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10),
                      itemBuilder: (context, idx) {
                        final item = _items[idx];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.fotoPath != null && item.fotoPath!.isNotEmpty)
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: item.fotoPath!.startsWith('http')
                                          ? Image.network(
                                              item.fotoPath!,
                                              width: 260,
                                              height: 260,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                                            )
                                          : Image.file(
                                              File(item.fotoPath!),
                                              width: 260,
                                              height: 260,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100),
                                            ),
                                    ),
                                  ),
                                if (item.fotoPath == null || item.fotoPath!.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Nenhuma imagem cadastrada para este item.',
                                      style: TextStyle(fontSize: 12, color: Colors.redAccent),
                                    ),
                                  ),
                                SizedBox(height: 10),
                                Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                if (item.descricao.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                                    child: Text(
                                      "Descrição: ${item.descricao}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                if (item.detalhesEspecificos.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      "Detalhes: ${item.detalhesEspecificos}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                if (item.categoria.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      "Categoria: ${item.categoria}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                Text(
                                  "Data de aquisição: ${item.dataAquisicao.toLocal().toString().split(' ')[0]}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Valor: R\$ ${item.valor.toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.condicao, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.amber),
                                          tooltip: 'Editar',
                                          onPressed: () => _editItem(idx),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          tooltip: 'Excluir',
                                          onPressed: () => _deleteItem(idx),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push<CollectionItem>(
            context,
            MaterialPageRoute(
              builder: (_) => CollectionItemFormScreen(
                collectionId: widget.collection.id ?? 0,
                isHQ: widget.collection.tipoItem.toLowerCase() == 'hq',
              ),
            ),
          );
          if (newItem != null) {
            setState(() {
              _items.add(newItem);
            });
            widget.onAddItem(newItem);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Adicionar novo item',
      ),
    );
  }
}
