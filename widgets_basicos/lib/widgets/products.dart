import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widgets_basicos/baseDeDatos/producto_dao.dart';
import 'package:widgets_basicos/models/Favoritos.dart';
import 'package:widgets_basicos/models/productsModel.dart';
import 'package:widgets_basicos/screens/productScreen.dart';
import '../view_models/modelo_usuario.dart';

class ProductWidget extends StatefulWidget {
  final Product producto;

  ProductWidget({
    super.key,
    required this.producto,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final dao = ProductoDao();

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeloUsuario>(
      builder: (context, modeloUsuario, child) {
        final bool esAdmin = modeloUsuario.esAdmin;
        final bool esFavorito =
            modeloUsuario.existFavorite(widget.producto.name) != -1;

        return Center(
          child: Container(
            color: const Color(0xFFF1F1F1),
            child: Stack(
              children: [
                Positioned(
                  top: 1,
                  right: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6, right: 9),
                    child: InkWell(
                      onTap: () async {
                        int indexFav =
                            modeloUsuario.existFavorite(widget.producto.name);

                        if (indexFav != -1) {
                          modeloUsuario.deleteFavorite(indexFav);
                        } else {
                          modeloUsuario.addFavorite(
                            Favorito(
                              id: 0, // Autoincremental en la BD
                              imagen: widget.producto.image,
                              nombre: widget.producto.name,
                              precio: widget.producto.price,
                            ),
                          );
                        }
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 20,
                        color: esFavorito ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 25,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                widget.producto.image,
                                widget.producto.name,
                                widget.producto.price,
                                widget.producto.desc,
                              ),
                            ),
                          );
                        },
                        child: Image.asset(
                          widget.producto.image,
                          fit: BoxFit.contain,
                          width: 111,
                          height: 111,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.producto.name,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.producto.price.toStringAsFixed(2)} €",
                        style: GoogleFonts.playfairDisplay(fontSize: 16),
                      ),
                      Visibility(
                        visible: esAdmin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Icon(Icons.border_color_outlined),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await dao.deleteProduct(widget.producto.id);
                                modeloUsuario.actualizarGrid();
                              },
                              child: Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
