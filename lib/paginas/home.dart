import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/paginas/compras.dart';
import 'package:ccoapp/paginas/inicio.dart';
import 'package:ccoapp/paginas/search_product.dart';
import 'package:ccoapp/paginas/usuario.dart';
import 'package:ccoapp/widgets/shop_car_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccoapp/conexionesString.dart';
import 'package:http/http.dart' as http;
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
int _selectIndex = 0;
Widget pagecontend;
Widget appbarCco;
String token;
  Future<void> updateNotificacion() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    token = preferencias.getString("token") ?? "";
    final response = await http.get(InternetString.conteoShopNotifiquer, headers: {HttpHeaders.authorizationHeader: 'Token $token',});
    if (response.statusCode == 200) {
      print("Codigo de notificacion ${response.statusCode}");
      var responseJson = json.decode(utf8.decode(response.bodyBytes));  
    setState(()  {    
    appbarCco = BotonApbbar(
      conteoCompra: responseJson['conteo_pre_compra'],
      updateNotificacion: updateNotificacion,
    );
    });
    }
    
  }


 @override
  void initState() {    
    super.initState();
    updateNotificacion();
    appbarCco = BotonApbbar(conteoCompra: 0,updateNotificacion: updateNotificacion,);
    pagecontend=InicioView(updateNotificacion: updateNotificacion,);
  }

 


  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          pagecontend = InicioView(updateNotificacion: updateNotificacion);
        });
        break;
      case 1:
        setState(() {
          pagecontend = UsuarioViewPage();
        });
        break;        
      case 2:
        setState(() {
          pagecontend = ComprasView();
        });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
      
      appBar: AppBar(
        centerTitle: true,
        title:Image(image: AssetImage('cco.png'), width: 120,),
        // elevation: 5,
        actions: [
          appbarCco,
          IconButton(icon: Icon(Icons.search), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchViewProducto(updateNotificacion: updateNotificacion,)));
          })
        ],
      ),
      body: pagecontend,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(icon:Icon(Icons.home), title: Text("Inicio")),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Compras'),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: ColoresApp.primario,
        currentIndex: _selectIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
