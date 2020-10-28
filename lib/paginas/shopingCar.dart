import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:ccoapp/paginas/cambiarDomicilio.dart';
import 'package:ccoapp/paginas/finalizarCompra.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class ShopingCarView extends StatefulWidget {
  @override
  _ShopingCarViewState createState() => _ShopingCarViewState();
}

class _ShopingCarViewState extends State<ShopingCarView> {
  double totalpedido = 0;
  SharedPreferences preferencias;  
  Domicilio dom;  

  Future<void> getTotalCart() async {
    totalpedido = 0;
    List<ProductoCarritoCompra> carrito = await getPreComprasUser();
    for (var item in carrito) {
      totalpedido = totalpedido + item.total;
      setState(() {});
    }
      setState(() {});
    
  }

  @override
  void initState() {
    super.initState();
    getTotalCart();
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: FutureBuilder(
            future: getPreComprasUser(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              if (!snap.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColoresApp.secundario),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      flex: 80,
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: ListView.builder(
                            itemCount: snap.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BuilItemShopingCart(
                                  snap.data[index], preferencias, getTotalCart);
                            }),
                      ),
                    ),
                    Expanded(
                        flex: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: GestureDetector(
                                      child: FutureBuilder(
                                          future: getTextCp(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snap) {
                                            if (!snap.hasData) {
                                              return Text("Sin datos");
                                            } else {
                                              return snap.data;
                                            }
                                          }),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CambiarDomicilioView()))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {});
                                          }
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(
                                      r"$ " + "${oCcy.format(totalpedido)}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),

                              dom != null && totalpedido > 0 ? 
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                height: 30,
                                child: FlatButton(
                                  onPressed: () {                                    
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FinalizarCompraView(totalpedido: totalpedido,domicilio: dom,)));
                                  },
                                  child: Text(
                                    "Continuar compra",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: ColoresApp.primario,
                                ),
                              ):Text("")
                            ],
                          ),
                        )),
                  ],
                );
              }
            }),
      ),
    );
  }

  Future<List<ProductoCarritoCompra>> getPreComprasUser() async {
    List<ProductoCarritoCompra> carrito = [];
    preferencias = await SharedPreferences.getInstance();
    String token = preferencias.getString("token") ?? "";
    final response = await http.get(InternetString.shopingCart, headers: {
      HttpHeaders.authorizationHeader: 'Token $token',
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseJson) {
        ProductoCarritoCompra itemCart = ProductoCarritoCompra.fromJson(item);
        carrito.add(itemCart);        
      }
    }
    return carrito;
  }


  Future<Widget> getTextCp() async {  
  
  SharedPreferences preferencias = await SharedPreferences.getInstance();
  String token = preferencias.getString("token") ?? "";
  final response = await http.get(InternetString.domiciliosUserActivo, headers: {
    HttpHeaders.authorizationHeader: 'Token $token',
  });

  if (response.statusCode == 200) {    
    var responseJson = json.decode(utf8.decode(response.bodyBytes));         
    for (var item in responseJson) {      
     dom = Domicilio.fromJson(item);   
     
    }           
  }
  
  return Text(
    dom == null ? "Seleccione lugar de envio": "Enviar a C.P: ${dom.domcodigop}" ,
    style: TextStyle(color: Colors.blue),
    textAlign: TextAlign.right,
  );
}


}

class BuilItemShopingCart extends StatelessWidget {
  final ProductoCarritoCompra itemCarrito;
  final SharedPreferences preferencias;
  final VoidCallback getTotalCart;
  BuilItemShopingCart(this.itemCarrito, this.preferencias, this.getTotalCart);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: ClipRect(
                child: Image.network(
                  itemCarrito.urlImagen,
                  height: 50,
                  width: 40,
                  fit: BoxFit.fill,
                ),
              ),
              title: Text("${itemCarrito.descripcion}"),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${itemCarrito.cantidad}"),
                  Text(
                    r"$ " + "${oCcy.format(itemCarrito.precio)}",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showMyDialog(context, this.itemCarrito,
                          this.preferencias, this.getTotalCart);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(
    BuildContext context,
    ProductoCarritoCompra itemcompra,
    SharedPreferences preferencias,
    VoidCallback getTotalCart) async {
  Widget cancelButton = FlatButton(
    child: Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continuar"),
    onPressed: () async {
      String token = preferencias.getString("token");
      final response = await http.delete(
          InternetString.deleteShopCartItem + "${itemcompra.id}/",
          headers: {
            HttpHeaders.authorizationHeader: 'Token $token',
          });

      Navigator.of(context).pop();

      getTotalCart();
    },
  );

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Eliminar producto"),
        content: Text('Esta seguro de eliminar "${itemcompra.descripcion}?"'),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
    },
  );
}


