import 'package:flutter/material.dart';
import '../models/collection_model.dart';
import '../models/collection_item_model.dart';
import 'collection_form_screen.dart';
import 'collection_detail_screen.dart';

class CollectionsHomeScreen extends StatefulWidget {
  @override
  State<CollectionsHomeScreen> createState() => _CollectionsHomeScreenState();
}

class _CollectionsHomeScreenState extends State<CollectionsHomeScreen> {
  final List<Collection> collections = [];
  final Map<int, List<CollectionItem>> itemsByCollection = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Coleções')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: collections.isEmpty
            ? Center(
                child: Text(
                  'Nenhuma coleção cadastrada.\nClique em "Nova Coleção" para começar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
            : ListView.separated(
                itemCount: collections.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final collection = collections[idx];
                  final items = itemsByCollection[collection.id ?? idx] ?? [];
                  return Card(
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      title: Text(
                        collection.nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        collection.descricao,
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: Chip(
                        label: Text(collection.tipoItem),
                        backgroundColor: Colors.deepPurple[50],
                        labelStyle: TextStyle(color: Colors.deepPurple),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CollectionDetailScreen(
                              collection: collection,
                              items: items,
                              onAddItem: (item) {
                                setState(() {
                                  itemsByCollection[collection.id ?? idx] =
                                      [...items, item];
                                });
                              },
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_hq',
        icon: Icon(Icons.add),
        label: Text('Nova Coleção'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CollectionFormScreen(
                onSave: (collection) {
                  setState(() {
                    collections.add(collection);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
