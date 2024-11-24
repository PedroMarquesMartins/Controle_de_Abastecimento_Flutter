import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarState extends StatefulWidget {
  final String emailUsuario;
  final String nome;
  final String placa;
  final String modelo;
  final String ano;

  const EditarState({
    super.key,
    required this.emailUsuario,
    required this.nome,
    required this.placa,
    required this.modelo,
    required this.ano,
  });

  @override
  _EditarState createState() => _EditarState();
}

class _EditarState extends State<EditarState> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _placaController;
  late TextEditingController _modeloController;
  late TextEditingController _anoController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nome);
    _placaController = TextEditingController(text: widget.placa);
    _modeloController = TextEditingController(text: widget.modelo);
    _anoController = TextEditingController(text: widget.ano);
  }

  Future<void> _editarVeiculo() async {
    if (_formKey.currentState!.validate()) {
      var query = FirebaseFirestore.instance
          .collection('veiculos')
          .where('emailUsuario', isEqualTo: widget.emailUsuario)
          .where('nome', isEqualTo: widget.nome)
          .where('placa', isEqualTo: widget.placa);

      var snapshot = await query.get();
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'nome': _nomeController.text,
          'placa': _placaController.text,
          'modelo': _modeloController.text,
          'ano': _anoController.text,
        });
      }

      Navigator.pop(context, true);
    }
  }

  Future<void> _excluirVeiculo() async {
    bool? confirmarExclusao = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este veículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmarExclusao == true) {
      var query = FirebaseFirestore.instance
          .collection('veiculos')
          .where('emailUsuario', isEqualTo: widget.emailUsuario)
          .where('nome', isEqualTo: widget.nome)
          .where('placa', isEqualTo: widget.placa);
      var snapshot = await query.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Veículo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a placa' : null,
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o modelo' : null,
              ),
              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o ano' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _editarVeiculo,
                    child: const Text("Salvar"),
                  ),
                  ElevatedButton(
                    onPressed: _excluirVeiculo,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Excluir"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}