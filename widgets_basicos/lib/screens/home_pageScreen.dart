import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/screens/adminScreen.dart';
import 'package:widgets_basicos/screens/carritoScreen.dart';
import 'package:widgets_basicos/screens/favoritesScreen.dart';
import 'package:widgets_basicos/screens/homeScreenGrid.dart';
import 'package:widgets_basicos/screens/temporal_loginScreen.dart';
import '../view_models/modelo_usuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String saludo = "Bienvenido ";

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        final esAdmin = modeloUsuario.esAdmin;
        final sesionInciada = modeloUsuario.incioSesion;

        return esAdmin
            ? const AdminScaffold()
            : Scaffold(
                appBar: AppBar(
                  toolbarHeight: 70,
                  elevation: 0,
                  actions: [
                    sesionInciada
                        ? ElevatedButton(
                            onPressed: () {
                              modeloUsuario.cerrarSesion();
                            },
                            child: const Icon(Icons.exit_to_app))
                        : Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: Builder(
                              builder: (context) => InkWell(
                                child: const Icon(Icons.person),
                                onTap: () => _showLoginForm(context),
                              ),
                            ),
                          )
                  ],
                  backgroundColor: Colors.black,
                  title: Text(
                    saludo + (modeloUsuario.usuarioActual?.username ?? ''),
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  foregroundColor: Colors.white,
                ),
                body: [
                  const HomeScreenGrid(),
                  const ListadoFavoritos(),
                  const CarritoPage(),
                ][currentIndex],
                bottomNavigationBar: NavigationBar(
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.home), label: "Inicio"),
                    NavigationDestination(
                      icon: Icon(Icons.favorite),
                      label: "Favoritos",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.shopping_cart),
                      label: "Carrito",
                    ),
                  ],
                  selectedIndex: currentIndex,
                  indicatorColor: Colors.grey[400],
                  onDestinationSelected: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                ),
                endDrawer: const Drawer(
                  child: LoginPage(),
                ),
              );
      },
    );
  }

  void _showLoginForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const LoginPage();
      },
      isScrollControlled: true,
    );
  }
}
