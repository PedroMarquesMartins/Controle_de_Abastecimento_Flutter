import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import '../Model/Firebase/daoFirestore.dart';
import '../Model/Firebase/firebase_options.dart';
import '../Controllers/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DaoFirestore.inicializa();
  runApp(const Login());
}