

import 'package:ccoapp/paginas/shopingCar.dart';
import 'package:flutter/material.dart';

class BotonApbbar extends StatefulWidget {
  final int conteoCompra;
  final VoidCallback updateNotificacion;
  BotonApbbar({this.conteoCompra,@required this.updateNotificacion});
  @override
  BotonApbbarState createState() => BotonApbbarState();
}

class BotonApbbarState extends State<BotonApbbar> {
  int conteoComprainicial = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      // overflow: Overflow.visible, 
      alignment: AlignmentDirectional.center,
      children: [
        IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShopingCarView())).then((value) => this.widget.updateNotificacion());
          
        }),
        Positioned(
            top: 7,
            right: 4,
            // child: Text("data"),
            child: SizedBox(
              width: 15,
              height: 15,
              child: Text(
                this.widget.conteoCompra > 0 ? "${this.widget.conteoCompra}":"",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )
            )
      ],
    );
  }
}
