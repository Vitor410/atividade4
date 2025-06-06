import 'package:flutter/material.dart';
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
              child: widget.items.isEmpty
                  ? Center(child: Text('Nenhum item cadastrado nesta coleção.'))
                  : ListView.separated(
                      itemCount: widget.items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10),
                      itemBuilder: (context, idx) {
                        final item = widget.items[idx];
                        return Card(
                          child: ListTile(
                            leading: item.fotoPath != null && item.fotoPath!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.fotoPath!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                                    ),
                                  )
                                : Icon(Icons.collections_bookmark, size: 36, color: Colors.deepPurple),
                            title: Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.descricao.isNotEmpty)
                                  Text("Descrição: ${item.descricao}"),
                                if (item.detalhesEspecificos.isNotEmpty)
                                  Text("Detalhes: ${item.detalhesEspecificos}"),
                                if (item.categoria.isNotEmpty)
                                  Text("Categoria: ${item.categoria}"),
                                Text("Data de aquisição: ${item.dataAquisicao.toLocal().toString().split(' ')[0]}"),
                                Text("Valor: R\$ ${item.valor.toStringAsFixed(2)}"),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.condicao, style: TextStyle(fontWeight: FontWeight.bold)),
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
            widget.onAddItem(newItem);
            setState(() {});
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Adicionar novo item',
      ),
    );
  }
}
