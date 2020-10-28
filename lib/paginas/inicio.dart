
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/widgets/cards_productos.dart';
import 'package:ccoapp/widgets/categorias.dart';
import 'package:flutter/material.dart';

class InicioView extends StatelessWidget {
  final VoidCallback updateNotificacion;
  InicioView({this.updateNotificacion});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text(
                        "Categorias",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.amber),
                      ),
                    ),
                ],
              ),
              CategoriasWidget(this.updateNotificacion),

              Divider(),
              Row(
                children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Text(
                        "Promociones",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.amber),
                      ),
                    ),
                ],
              ),
              
              Expanded(
                child: Padding(
                padding: EdgeInsets.all(10), child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColoresApp.secundario, width: 3)
                  ),
                  child: CardGridWidget(updateNotificacion: updateNotificacion,)),))
            ],
          ),
                  ),
        );
  }
}