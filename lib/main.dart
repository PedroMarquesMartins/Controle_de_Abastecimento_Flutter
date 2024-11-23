import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'daoFirestore.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DaoFirestore.inicializa();
  runApp(const Login());
}