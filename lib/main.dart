import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/model/history.dart';
import 'package:chatting_app/model/product.dart';
import 'package:chatting_app/provider/firebase_auth_provider.dart';
import 'package:chatting_app/provider/firebase_firestore_provider.dart';
import 'package:chatting_app/provider/shared_preference_provider.dart';
import 'package:chatting_app/screens/add_product_screen.dart';
import 'package:chatting_app/screens/detail_history_screen.dart';
import 'package:chatting_app/screens/detail_product_screen.dart';
import 'package:chatting_app/screens/home_screen.dart';
import 'package:chatting_app/screens/login_screen.dart';
import 'package:chatting_app/screens/register_screen.dart';
import 'package:chatting_app/services/firebase_auth_service.dart';
import 'package:chatting_app/services/firebase_firestore_service.dart';
import 'package:chatting_app/services/shared_preferences_service.dart';
import 'package:chatting_app/static/screen_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (context) => SharedPreferencesService(pref),
      ),
      ChangeNotifierProvider(
        create: (context) => SharedPreferenceProvider(
          context.read<SharedPreferencesService>(),
        ),
      ),
      Provider(
        create: (context) => FirebaseAuthService(
          firebaseAuth,
        ),
      ),
      Provider(
        create: (context) => FirebaseFirestoreService(
          firebaseFirestore,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => FirebaseAuthProvider(
          context.read<FirebaseAuthService>(),
        ),
      ),
      ChangeNotifierProvider<FirebaseFirestoreProvider>(
        create: (context) =>
            FirebaseFirestoreProvider(context.read<FirebaseFirestoreService>()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting App',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: ScreenRoute.login.name,
      routes: {
        ScreenRoute.login.name: (context) => const LoginScreen(),
        ScreenRoute.register.name: (context) => const RegisterScreen(),
        ScreenRoute.home.name: (context) => const HomeScreen(),
        ScreenRoute.addProduct.name: (context) => const AddProductScreen(),
        ScreenRoute.detailProduct.name: (context) => DetailProductScreen(
            product: ModalRoute.of(context)?.settings.arguments as Product),
        ScreenRoute.detailTransaction.name: (context) => DetailHistoryScreen(
            history: ModalRoute.of(context)?.settings.arguments as History)
      },
    );
  }
}
