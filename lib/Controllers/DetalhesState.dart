import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetalhesState extends StatefulWidget {
  final String placa;

  const DetalhesState({super.key, required this.placa});

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<DetalhesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _obterDetalhesVeiculo() async {
    final query = await _firestore
        .collection('veiculos')
        .where('placa', isEqualTo: widget.placa)
        .get();
    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  Future<void> _novoAbastecimento() async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController litrosController = TextEditingController();
    final TextEditingController quilometragemController = TextEditingController();
    final TextEditingController dataController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Abastecimento'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: litrosController,
                  decoration: const InputDecoration(labelText: 'Litros'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quantidade de litros';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: quilometragemController,
                  decoration: const InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a quilometragem atual';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dataController,
                  decoration: const InputDecoration(labelText: 'Data'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a data';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _firestore
                      .collection('veiculos')
                      .doc(widget.placa)
                      .collection('abastecimentos')
                      .add({
                    'litros': double.parse(litrosController.text),
                    'quilometragem': int.parse(quilometragemController.text),
                    'data': dataController.text,
                    'placa': widget.placa,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Stream<QuerySnapshot> _obterAbastecimentos() {
    return _firestore
        .collection('veiculos')
        .doc(widget.placa)
        .collection('abastecimentos')
        .orderBy('quilometragem')
        .snapshots();
  }


  double _calcularMediaConsumo(List<DocumentSnapshot> abastecimentos) {
    double totalConsumo = 0;
    int lastQuilometragem = 0;
    double lastLitros = 0;

    for (var abastecimento in abastecimentos) {
      final data = abastecimento.data() as Map<String, dynamic>;
      final quilometragem = data['quilometragem'] as int;
      final litros = data['litros'] as double;

      if (lastQuilometragem != 0 && lastLitros != 0 && quilometragem > lastQuilometragem) {
        totalConsumo += (quilometragem - lastQuilometragem) / lastLitros;
      }

      lastQuilometragem = quilometragem;
      lastLitros = litros;
    }

    return abastecimentos.length > 1 ? totalConsumo / (abastecimentos.length - 1) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Veículo'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _obterDetalhesVeiculo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Veículo não encontrado.'));
          }
          final veiculo = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nome: ${veiculo['nome'] ?? 'Desconhecido'}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text('Modelo: ${veiculo['modelo'] ?? 'Desconhecido'}'),
                const SizedBox(height: 8),
                Text('Ano: ${veiculo['ano'] ?? 'Desconhecido'}'),
                const SizedBox(height: 8),
                Text('Placa: ${veiculo['placa'] ?? 'Desconhecida'}'),
                const SizedBox(height: 8),
                Text('Email do Dono: ${veiculo['emailUsuario'] ?? 'Desconhecido'}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _novoAbastecimento,
                  child: const Text('Novo Abastecimento'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Histórico de Abastecimentos:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _obterAbastecimentos(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('Nenhum abastecimento.'));
                      }
                      final abastecimentos = snapshot.data!.docs;
                      final mediaConsumo = _calcularMediaConsumo(abastecimentos);

                      return Column(
                        children: [
                          Text(
                            'Média de Consumo: ${mediaConsumo.toStringAsFixed(2)} km/l',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: abastecimentos.length,
                              itemBuilder: (context, index) {
                                final abastecimento =
                                abastecimentos[index].data() as Map<String, dynamic>;
                                return ListTile(
                                  title: Text('Data: ${abastecimento['data']}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Placa: ${abastecimento['placa']}'),
                                      Text('Litros: ${abastecimento['litros'].toStringAsFixed(2)}'),
                                      Text('Quilometragem: ${abastecimento['quilometragem']}'),
                                    ],
                                  ),
                                );
                              },
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
        },
      ),
    );
  }
}