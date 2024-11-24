import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListagemState extends StatefulWidget {
  final String emailUsuario;

  const ListagemState({super.key, required this.emailUsuario});

  @override
  _ListagemState createState() => _ListagemState();
}

class _ListagemState extends State<ListagemState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _obterVeiculos() {
    return _firestore
        .collection('veiculos')
        .where('emailUsuario', isEqualTo: widget.emailUsuario)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seus Veículos Salvos:'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _obterVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado.'));
          }

          final veiculos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final veiculo = veiculos[index].data() as Map<String, dynamic>;
              final docId = veiculos[index].id;

              return ListTile(
                title: Text(veiculo['nome']??'Sem Nome'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Modelo: ${veiculo['modelo']?? 'Desconhecido'}'),
                    Text('Ano:${veiculo['ano'] ??'Desconhecido'}'),
                    Text('Placa:${veiculo['placa'] ??'Desconhecida'}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditarState(
                    //       veiculoId: docId,
                    //       veiculoData: veiculo,
                    //     ),
                    //   ),
                    // ).then((_) => setState(() {}));
                  },
                  child: const Text('Editar'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
