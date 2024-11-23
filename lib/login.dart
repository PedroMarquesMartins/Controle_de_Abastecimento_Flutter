import 'package:flutter/material.dart';
import 'package:p2_projeto/telaInicio.dart';


import 'autenticacaoFirebase.dart';

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
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
        SnackBar(content: Text("Erro ao enviar email de recuperação: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrar'),
            ),
            ElevatedButton(
              onPressed: _recuperarSenha,
              child: const Text('Esqueceu a senha?'),
              style: ElevatedButton.styleFrom(
              ),
            ),
          ],
        ),
      ),
    );
  }
}