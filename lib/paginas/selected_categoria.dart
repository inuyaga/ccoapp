import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/widgets/cards_productos.dart';
import 'package:flutter/material.dart';

class SelectedCategoriaProductos extends StatelessWidget {
  final VoidCallback updateNotificacion;
  final String busquedaID;
  final String nombreCategoria;
  SelectedCategoriaProductos({this.busquedaID, this.nombreCategoria, @required this.updateNotificacion});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Hero(
                tag: this.nombreCategoria,
                child: Text(
                  this.nombreCategoria,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: ColoresApp.primario),
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(15),
              child: CardGridWidget(filtroProductos: busquedaID, updateNotificacion: updateNotificacion,),
            ))
          ],
        ));
  }
}
