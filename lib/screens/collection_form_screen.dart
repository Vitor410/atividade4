import 'package:flutter/material.dart';
import '../models/collection_model.dart';

class CollectionFormScreen extends StatefulWidget {
  final Function(Collection) onSave;
  const CollectionFormScreen({Key? key, required this.onSave}) : super(key: key);

  @override
  State<CollectionFormScreen> createState() => _CollectionFormScreenState();
}

class _CollectionFormScreenState extends State<CollectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String nomeColecao = '';
  String descricaoColecao = '';
  String tipoItem = 'HQ'; // Valor padrão

  final List<String> tipos = ['HQ', 'Selos', 'Moedas'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final collection = ModalRoute.of(context)?.settings.arguments as Collection?;
    if (collection != null) {
      nomeColecao = collection.nome;
      descricaoColecao = collection.descricao;
      tipoItem = collection.tipoItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Coleção')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Dados da Coleção",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: nomeColecao,
                decoration: InputDecoration(labelText: 'Nome da coleção'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                onSaved: (v) => nomeColecao = v!,
              ),
              TextFormField(
                initialValue: descricaoColecao,
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (v) => descricaoColecao = v ?? '',
              ),
              DropdownButtonFormField<String>(
                value: tipoItem,
                decoration: InputDecoration(labelText: 'Tipo de item'),
                items: tipos
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tipoItem = value!;
                  });
                },
                onSaved: (value) => tipoItem = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final collection = Collection(
                      nome: nomeColecao,
                      descricao: descricaoColecao,
                      tipoItem: tipoItem,
                    );
                    widget.onSave(collection);
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
