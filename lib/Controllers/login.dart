import 'package:flutter/material.dart';
import 'package:p2_projeto/Controllers/telaInicio.dart';

import '../Model/Firebase/autenticacaoFirebase.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AutenticacaoFirebase auth = AutenticacaoFirebase();

  @override
  void initState() {
    super.initState();
    _validaLogin();
  }

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    String message = await auth.signInWithEmailPassword(email, password);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    _validaLogin();
  }

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    String message = await auth.registerWithEmailPassword(email, password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    _validaLogin();
  }

  void _validaLogin() async {
    if (await auth.isUserLoggedIn()) {
      final user = await auth.getCurrentUser();
      final email = user?.email ?? "Usuário não cadastrado";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(userEmail: email),
        ),
      );
    }
  }

  void _recuperarSenha() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insira seu email para recuperar a senha.")),
      );
      return;
    }

    try {
      await auth.enviarEmailRecuperacaoSenha(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email de recuperação enviado para $email.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text("Erro ao enviar email de recuperação: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              const Text(
                'Bem-vindo!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Faça login para continuar', style: TextStyle(fontSize: 16, color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              TextField(controller: _emailController, decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _login, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), //??????????? wtf
                ),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _register, style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _recuperarSenha,
                child: const Text('Esqueceu a senha?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}