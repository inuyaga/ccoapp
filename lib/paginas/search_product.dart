import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/widgets/cards_productos.dart';
import 'package:flutter/material.dart';

class SearchViewProducto extends StatefulWidget {
  final VoidCallback updateNotificacion;
  SearchViewProducto({@required this.updateNotificacion});
  @override
  _SearchViewProductoState createState() => _SearchViewProductoState();
}

class _SearchViewProductoState extends State<SearchViewProducto> {
  final _formKey = GlobalKey<FormState>();
  Widget resultado = Container();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                onFieldSubmitted: (value){
                  if (value != '') {
                    setState(() {
                      resultado = CardGridWidget(searchtype: value, updateNotificacion: this.widget.updateNotificacion,);
                    });
                  }
                },
                decoration: InputDecoration(                                    
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Filtrar productos",
                    hintStyle: TextStyle(color: Colors.white70),
                  
                    focusColor: Colors.white,

                    // fillColor: Colors.white,
                    // filled: true,
                    icon: Icon(Icons.search, color: Colors.white,),
                    border: InputBorder.none
                        ),
              ),
            )),
      ),

      body: Container(child: Padding(
        padding: EdgeInsets.all(10),
        child: resultado),),
    );
  }
}
