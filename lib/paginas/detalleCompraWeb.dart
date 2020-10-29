import 'dart:ui';

import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class DetalleCompraWebView extends StatelessWidget {
  final List<ProductoCarritoCompra> itemsCarr;
  final double totalPedido;
  DetalleCompraWebView({this.itemsCarr, this.totalPedido});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              flex: 80,
              child: Container(
                color: Colors.grey.withOpacity(0.3),
                child: ListView.builder(
                    itemCount: itemsCarr.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BuilItemShopingCart(
                        itemCarrito: itemsCarr[index],
                      );
                    }),
              )),
          Expanded(
              flex: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'KG',
                          color: ColoresApp.primario,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text(
                      "${oCcy.format(totalPedido)}",
                      style: TextStyle(
                          fontSize: 29,
                          fontFamily: 'KG',
                          color: ColoresApp.defecto),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class BuilItemShopingCart extends StatelessWidget {
  final ProductoCarritoCompra itemCarrito;
  BuilItemShopingCart({this.itemCarrito});
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
              title: Text(
                "${itemCarrito.descripcion}",
                style: TextStyle(fontFamily: 'KG'),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${itemCarrito.cantidad}",
                      style: TextStyle(fontFamily: 'KG')),
                  Text(
                    r"$ " + "${oCcy.format(itemCarrito.precio)}",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'KG',
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}
