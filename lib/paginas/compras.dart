import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:http/http.dart' as http;
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/objetos.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'detalleCompraWeb.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class ComprasView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getMisCompras(),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColoresApp.secundario),
                ),
              );
            } else {
              return builItemCompra(snap.data);
            }
          }),
    );
  }

  Widget builItemCompra(List<Compra> compras) {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: ListView.builder(
          itemCount: compras.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(compras[index].cwStatus, style: TextStyle(color: Colors.amber)),
                leading: SizedBox(
                    height: 40,
                    width: 60,
                    child: Center(
                      child: Text("N° ${compras[index].cwId}", style: TextStyle(color: ColoresApp.primario, fontSize: 10),),
                    )),
                subtitle: Text("${compras[index].cwFecha}", style: TextStyle(fontFamily: 'KG'),),
                trailing: Text("${oCcy.format(compras[index].total)}", style: TextStyle(color: ColoresApp.defecto, fontFamily: 'KG'),),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetalleCompraWebView(
                    itemsCarr: compras[index].itemsCompras,
                    totalPedido: compras[index].total,
                  )));
                },
              ),
            );
          }),
    );
  }
}

Future<List<Compra>> getMisCompras() async {
  SharedPreferences preferencias = await SharedPreferences.getInstance();
  String token = preferencias.getString("token");
  List<Compra> compras = [];
  final response = await http.get(InternetString.misCompras, headers: {
    HttpHeaders.authorizationHeader: 'Token $token',
  });  
  
  if (response.statusCode == 200) {
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    for (var item in responseJson) {
      Compra compra = Compra.fromJson(item);
      compras.add(compra);
    }
  }
  return compras;
}
