import 'dart:convert';

import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:ccoapp/paginas/selected_categoria.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriasWidget extends StatefulWidget {
  final VoidCallback updateNotificacion;
  CategoriasWidget(this.updateNotificacion);
  @override
  _CategoriasWidgetState createState() => _CategoriasWidgetState();
}

class _CategoriasWidgetState extends State<CategoriasWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAreas(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColoresApp.secundario),
                ),
              ),
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: snap.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buidCategoria(index, snap.data[index], this.widget.updateNotificacion)),
            );
          }
        });
  }

  Future<List<AreaObject>> getAreas() async {
    final response = await http.get(InternetString.getpageInicial);
    List<AreaObject> areas = [];
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      for (var item in responseJson['area']) {
        AreaObject areaobj = AreaObject(
            item['area_id_area'], item['area_nombre'], item['area_icono']);
        areas.add(areaobj);
      }
    }
    return areas;
  }

  Widget buidCategoria(int index, AreaObject areaObj, VoidCallback updateNotificacion) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedCategoriaProductos(busquedaID: "${areaObj.id}", nombreCategoria: areaObj.nombre, updateNotificacion: updateNotificacion,)));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Container(
          width: 80,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                  child: Container(
                color: ColoresApp.secundario,
                child: Image.network(
                  areaObj.icono,
                  fit: BoxFit.fill,
                  height: 40,
                  width: 40,
                ),
              )),
              SizedBox(height: 10,),
              Hero(
                tag: areaObj.nombre,
                              child: Text(
                  areaObj.nombre,
                  style: TextStyle(
                      color: selectedIndex == index
                          ? ColoresApp.primario
                          : Colors.grey, fontSize: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}