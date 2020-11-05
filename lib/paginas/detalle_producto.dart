import 'dart:io';
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final oCcy = new NumberFormat("#,##0.00", "en_US");

class DetalleProductoView extends StatefulWidget {
  final ProductoObject producto;
  final VoidCallback updateNotificacion;
  DetalleProductoView({@required this.producto, this.updateNotificacion});
  @override
  _DetalleProductoViewState createState() => _DetalleProductoViewState();
}

class _DetalleProductoViewState extends State<DetalleProductoView> {
  int conteo = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: ColoresApp.primario,
        // ),
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(color: ColoresApp.primario),
        ),
        Positioned(
            left: 0,
            top: 20,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            )),
        Positioned(
          left: 20,
          top: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Area'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Text(
                "${this.widget.producto.area}".toUpperCase(),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Subcategoria'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Text(
                '${this.widget.producto.subcategoria}'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Linea'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Text(
                '${this.widget.producto.productolinea}'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                      height: 10,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: [
                          Positioned(
                              top: -220,
                              right: 20,
                              child: SizedBox(
                                child: Hero(
                                    tag:
                                        "${this.widget.producto.productocodigo}",
                                    child: Image.network(
                                      this.widget.producto.productoimagen,
                                      height: 250,
                                      width: 200,
                                    )),
                              )),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 80,
                          child: Text(
                            "${this.widget.producto.productonombre}",
                            style: TextStyle(
                                color: ColoresApp.primario,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        Expanded(
                          flex: 20,
                          child: ClipPath(
                            clipper: Formaclip(),
                            child: Container(
                              width: 70,
                              height: 70,
                              child: Center(
                                child: Text(
                                  r"$" +
                                      oCcy.format(
                                          this.widget.producto.productoprecio),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              color: ColoresApp.primario,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Text("${this.widget.producto.productodescripcion}"),

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontStyle: FontStyle.italic),
                            children: [
                          TextSpan(
                              text:
                                  "${this.widget.producto.productodescripcion}")
                        ])),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 0, right: 0),
              height: MediaQuery.of(context).size.height * 0.64,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
            )),
        Positioned(
            bottom: 60,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 20,
                    ),
                    onPressed: () {
                      switch (conteo) {
                        case 1:
                          break;
                        default:
                          setState(() {
                            conteo--;
                          });
                      }
                    }),
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  child: Center(
                      child: Text(
                    "$conteo",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ),
                IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        conteo++;
                      });
                    }),
              ],
            )),
        Positioned(
            bottom: 15,
            child: SizedBox(
              width: 200,
              child: FlatButton(
                  shape: StadiumBorder(),
                  color: Colors.amber,
                  onPressed: this.widget.producto.productoprecio == 0
                      ? null
                      : () async {
                          SharedPreferences preferencias =
                              await SharedPreferences.getInstance();

                          String token = preferencias.getString("token") ?? "";
                          var response = await http
                              .post(InternetString.addCarShop, headers: {
                            HttpHeaders.authorizationHeader: 'Token $token',
                          }, body: {
                            'dcw_producto_id':
                                this.widget.producto.productocodigo,
                            'dcw_cantidad': "$conteo",
                          });

                          if (response.statusCode == 201) {
                            this.widget.updateNotificacion();
                            Navigator.of(context).pop(true);
                          }
                        },
                  child: Text("Añadir")),
            ))
      ],
    ));
  }
}

class Formaclip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(
        size.width, size.height * 0.01, size.width, size.height);
    path.quadraticBezierTo(
        size.width * 0.50, size.height * 0.80, 0, size.height);
    path.quadraticBezierTo(
        size.width * -0.00, size.height * -0.05, size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
