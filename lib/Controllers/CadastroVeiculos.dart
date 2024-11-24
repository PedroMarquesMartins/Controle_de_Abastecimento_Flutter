import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroVeiculo extends StatefulWidget {
  final String emailUsuario;
  const CadastroVeiculo({super.key, required this.emailUsuario});
  @override
  _CadastroVeiculoState createState() => _CadastroVeiculoState();
}

class _CadastroVeiculoState extends State<CadastroVeiculo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    _nomeController.dispose();
    _modeloController.dispose();
    _anoController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrarVeiculo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true); //Isso aqui ta estranho kk
    try {
      final veiculo = {
        'nome': _nomeController.text.trim(),
        'modelo': _modeloController.text.trim(),
        'ano': _anoController.text.trim(),
        'placa': _placaController.text.trim().toUpperCase(),
        'emailUsuario': widget.emailUsuario,
      };
      await FirebaseFirestore.instance.collection('veiculos').add(veiculo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastrado com sucesso.'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar veículo: $e'),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastrar Veículo',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Veículo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modeloController,
                decoration:
                    const InputDecoration(labelText: 'Modelo do Veículo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o modelo do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(labelText: 'Ano do Veículo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o ano do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _placaController,
                decoration:
                    const InputDecoration(labelText: 'Placa do Veículo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a placa do veículo';
                  } else if (!RegExp(r'^[A-Z]{3}[0-9]{4}$').hasMatch(value)) {
                    return 'A placa deve seguir o exemplo: AAA9999';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _cadastrarVeiculo,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        child: Text(
                          'Cadastrar Veículo',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
