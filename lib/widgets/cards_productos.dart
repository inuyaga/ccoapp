import 'dart:convert';
import 'dart:io';

import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:ccoapp/paginas/detalle_producto.dart';
import 'package:ccoapp/widgets/shop_car_icon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class CardGridWidget extends StatelessWidget {
  final VoidCallback updateNotificacion;
  final String filtroProductos;
  final String searchtype;
  CardGridWidget(
      {this.filtroProductos, this.searchtype, this.updateNotificacion});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProductos(this.filtroProductos, this.searchtype),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColoresApp.secundario),
              ),
            );
          } else {
            return GridView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: snap.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext contex, int index) =>
                    builCardrProducto(
                        context, index, snap.data[index], updateNotificacion));
          }
        });
  }

  Widget builCardrProducto(context, int index, ProductoObject producto,
      VoidCallback updateNotificacion) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetalleProductoView(
                      producto: producto,
                      updateNotificacion: updateNotificacion,
                    )));
      },
      child: SizedBox(
        height: double.infinity,
        child: Card(
          semanticContainer: true,
          margin: EdgeInsets.all(2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Hero(
                    tag: "${producto.productocodigo}",
                    child: Image.network(
                      producto.productoimagen,
                      width: 90,
                      height: 90,
                    )),
                Text(
                  "${producto.productonombre}",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  "${producto.productomarca}",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  "${producto.productolinea}",
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  producto.productoprecio == 0
                      ? r"$" + "Registrarse"
                      : r"$" + oCcy.format(producto.productoprecio),
                  style: TextStyle(fontSize: 10, color: ColoresApp.primario),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<ProductoObject>> getProductos(
      String filtroproduct, String busquedatipeada) async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    String token = preferencias.getString("token") ?? "";
    String busqueda = "";
    if (filtroproduct == null) {
      busqueda = InternetString.productosItems;
    } else {
      busqueda = InternetString.productosItemsFilter + "$filtroproduct/";
    }
    if (busquedatipeada != null) {
      busqueda =
          InternetString.productosItemsFilter + "?search=$busquedatipeada";
    }
    var response;
    if (token == "") {
      response = await http.get(busqueda);
    } else {
      response = await http.get(busqueda, headers: {
        HttpHeaders.authorizationHeader: 'Token $token',
      });
    }

    List<ProductoObject> productos = [];
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseJson) {
        ProductoObject producto = ProductoObject(
          item['producto_codigo'],
          item['producto_nombre'],
          item['producto_descripcion'],
          item['producto_imagen'],
          item['producto_marca'],
          item['producto_precio'] == null
              ? 0
              : double.parse(item['producto_precio']),
          item['prducto_codigo_barras'],
          item['prducto_unidad'],
          item['prducto_existencia'],
          item['producto_linea']['l_nombre'],
          item['producto_linea']['l_subcat']['sc_nombre'],
          item['producto_linea']['l_subcat']['sc_area']['area_nombre'],
        );
        productos.add(producto);
      }
    }
    return productos;
  }
}
