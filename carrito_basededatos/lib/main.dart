import 'package:carrito_basededatos/bbdd/producto_model.dart';
import 'package:flutter/material.dart';

import 'bbdd/database_helper.dart';
import 'bbdd/producto_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final controller = TextEditingController();
  List<ProductoModel> productos = [];
  final dao = ProductoDao();
  @override
  void initState() {
    super.initState();
    dao.readAll().then((value) {
      setState(() {
        productos = value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'CARRITO DE PRODUCTOS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 153, 152, 150),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final name = controller.text;
                      ProductoModel producto = ProductoModel(name: name);
                      final id = await dao.Insert(producto);
                      producto = producto.copyWith(id: id);
                      controller.clear();
                      setState(() {
                        productos.add(producto);
                      });
                    },
                    child: const Text('Crear Producto'),
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics:
                  NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento del ListView
              primary: false,
              shrinkWrap: true,
              itemCount: productos.length,
              itemBuilder: ((context, index) {
                final producto = productos[index];
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 153, 152, 150),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(15),
                    margin:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        Text('${producto.id}'), // id de los productos
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            producto.name, //nombre de los productos
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                          child: IconButton(
                            onPressed: () async {
                              if (producto.cantidad > 1) {
                                producto.cantidad--;
                                await dao.update(producto);
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.remove),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            iconSize: 18,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          '${producto.cantidad}', //cantidad de productos
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(width: 5.0),
                        SizedBox(
                          width: 25,
                          child: IconButton(
                            onPressed: () async {
                              if (producto.cantidad < 99) {
                                producto.cantidad++;
                                await dao.update(producto);
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.add),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            iconSize: 18,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        IconButton(
                          onPressed: () async {
                            await dao.delete(producto);
                            setState(() {
                              productos.removeWhere(
                                  (element) => element.id == producto.id);
                            });
                          },
                          icon: Icon(Icons.delete),
                          color: Color.fromARGB(255, 248, 70, 70),
                          iconSize: 22,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
