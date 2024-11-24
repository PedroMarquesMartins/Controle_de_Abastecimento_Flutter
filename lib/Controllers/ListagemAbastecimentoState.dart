import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaAbastecimentosState extends StatelessWidget{
  const ListaAbastecimentosState({super.key});
  Stream<QuerySnapshot> _obterTodosAbastecimentos(){
    final FirebaseFirestore _firestore= FirebaseFirestore.instance;
    return _firestore
        .collectionGroup('abastecimentos')
        .snapshots();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text('Todos os Abastecimentos'),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream:_obterTodosAbastecimentos(),
        builder: (context,snapshot) {
          if (snapshot.connectionState== ConnectionState.waiting) {
            return const Center(child:CircularProgressIndicator());
          }
          if (!snapshot.hasData||snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nenhum abastecimento registrado.'),
            );
          }
          final abastecimentos=snapshot.data!.docs;
          return ListView.builder(
            itemCount:abastecimentos.length,
            itemBuilder:(context, index) {
              final abastecimento=abastecimentos[index].data() as Map<String, dynamic>;
              return ListTile(


                title:Text('Data: ${abastecimento['data']}'),
                subtitle:Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
                  Text('Placa: ${abastecimento['placa']}'),
                  Text('Litros: ${abastecimento['litros'].toStringAsFixed(2)}'),
                  Text('Quilometragem: ${abastecimento['quilometragem']}'),
                ],
                ),
              );
            },
          );

        },
      ),
    );
  }
}