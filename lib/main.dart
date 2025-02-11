import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'components/products/create_product_page.dart';
import 'components/complementaries/login_page.dart';
import 'components/complementaries/welcome_page.dart';
import 'components/products/products_page.dart';
import 'components/sellers/sellers_page.dart';
import 'components/sales/sales_page.dart';
import 'components/complementaries/profile_page.dart';
import 'providers/products_provider.dart';
import 'providers/sellers_provider.dart';

void main() async {
  // Aseguramos la inicialización completa antes de usar SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // Accedemos a las preferencias compartidas para verificar si el usuario está logueado
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Corremos la aplicación pasándole el estado de inicio de sesión
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(), // Proveemos el ProductsProvider
      child: ChangeNotifierProvider(
        create: (context) => SellersProvider(), // Agregamos el SellersProvider
        child: MaterialApp(
          title: 'SalesRegistrator',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          // Usamos la propiedad home para manejar la navegación de la primera página.
          home: isLoggedIn ? const WelcomePage() : const LoginPage(),
          // Aquí no definimos la ruta "/" ya que la estamos manejando con "home".
          routes: {
            '/welcome': (context) => const WelcomePage(),
            '/products': (context) => const ProductsPage(),
            '/createProduct': (context) => const CreateProductPage(),
            '/sellers': (context) => const SellersPage(),
            '/sales': (context) => const SalesPage(),
            '/profile': (context) => const ProfilePage(),
          },
        ),
      ),
    );
  }
}