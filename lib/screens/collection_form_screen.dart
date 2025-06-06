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
  String nome = '';
  String descricao = '';
  String tipoItem = 'HQ'; // Valor padrão

  final List<String> tipos = ['HQ', 'Selos', 'Moedas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nova Coleção')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome da coleção'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                onSaved: (v) => nome = v!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (v) => descricao = v ?? '',
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
                    widget.onSave(Collection(
                      nome: nome,
                      descricao: descricao,
                      tipoItem: tipoItem,
                    ));
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
