import 'package:flutter/material.dart';
import 'CadastroVeiculos.dart';
import 'ListagemState.dart';

class Principal extends StatefulWidget {
  final String userEmail;

  const Principal({super.key, required this.userEmail});

  @override
  _PrincipalState createState() => _PrincipalState();
}
class _PrincipalState extends State<Principal> {
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
              decoration: BoxDecoration(color: Colors.black),
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
              leading: const Icon(Icons.add),
              title: const Text('Adicionar Veículo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastroVeiculo(emailUsuario: widget.userEmail),
                  ),
                ).then((_) => setState(() {}));
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
              child: ListagemState(emailUsuario: widget.userEmail),
            ),
          ],
        ),
      ),
    );
  }
}
