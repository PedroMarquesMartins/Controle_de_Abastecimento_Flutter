import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Perfil extends StatefulWidget {
  final String emailUsuario;
  const Perfil({Key? key, required this.emailUsuario}) : super(key: key);
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late TextEditingController _nomeController;
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: FirebaseAuth.instance.currentUser?.displayName);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _atualizarPerfil() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(_nomeController.text);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar perfil.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'E-mail:${FirebaseAuth.instance.currentUser?.email ?? 'Não disponível'}', //Incoerencia???
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              validator: (value) => value == null || value.isEmpty ? 'Informe seu nome' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _atualizarPerfil,
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
