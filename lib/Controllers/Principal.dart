import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CadastroVeiculos.dart';

class Principal extends StatefulWidget {
  final String userEmail;

  const Principal({super.key, required this.userEmail});

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _obterVeiculos() {
    return _firestore
        .collection('veiculos')
        .where('emailUsuario', isEqualTo: widget.userEmail)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    print('Usuário logado: ${widget.userEmail}');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bem-Vindo!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Meus Veículos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Adicionar Veículo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastroVeiculo(emailUsuario: widget.userEmail),
                  ),
                ).then((_) => setState(() {})); // Atualiza a tela após cadastro
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Abastecimentos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastroVeiculo(emailUsuario: widget.userEmail),
                  ),
                ).then((_) => setState(() {}));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text(
                  "Cadastrar Novo Veículo",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _obterVeiculos(),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Nenhum veículo cadastrado.'));
                  }

                  final veiculos = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: veiculos.length,
                    itemBuilder: (context, index) {
                      final veiculo=
                      veiculos[index].data()as Map<String,dynamic>;

                      return ListTile(
                        title: Text(veiculo['nome'] ?? 'Sem Nome'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Modelo: ${veiculo['modelo']??'Desconhecido'}'),
                            Text('Ano:${veiculo['ano'] ??'Desconhecido'}'),
                            Text('Placa:${veiculo['placa']?? 'Desconhecida'}'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
