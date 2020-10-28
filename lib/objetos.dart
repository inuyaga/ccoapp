class AreaObject{
  final int id;
  final String nombre;
  final String icono;

  AreaObject(this.id, this.nombre, this.icono);
}

class ProductoObject {
  final String productocodigo;
  final String productonombre;  
  final String productodescripcion;  
  final String productoimagen;  
  final String productomarca;  
  final double productoprecio;  
  final String prductocodigobarras;  
  final String prductounidad;  
  final int prductoexistencia;  
  final String productolinea;
  final String subcategoria;
  final String area;

  ProductoObject(this.productocodigo, this.productonombre, this.productodescripcion, this.productoimagen, this.productomarca, this.productoprecio, this.prductocodigobarras, this.prductounidad, this.prductoexistencia, this.productolinea, this.subcategoria, this.area);  
}



class Domicilio {
  
  
  
  

  
  final int id;
  final String domnomap;
  final int domcodigop;
  final String domestado;

  final String domdelegacion;
  final String domcolonia;
  final String domcalle;
  final int domnumex;
  final int domnuminterior;
  final String domindicaciones;
  final int domtipo;
  final String domtelefono;
  final bool domactivo;
  final int domcreador;
  final String descripcionlarga;

  Domicilio({this.id, this.domnomap, this.domcodigop, this.domestado, this.domdelegacion, this.domcolonia, this.domcalle, this.domnumex, this.domnuminterior, this.domindicaciones, this.domtipo, this.domtelefono, this.domactivo, this.domcreador, this.descripcionlarga});
  factory Domicilio.fromJson(dynamic json){
    return Domicilio(
      id: json['id'],
      domnomap: json['dom_nom_ap'],
      domcodigop: json['dom_codigo_p'],
      domestado: json['dom_estado'],
      domdelegacion: json['dom_delegacion'],
      domcolonia: json['dom_colonia'],
      domcalle: json['dom_calle'],
      domnumex: json['dom_num_ex'],
      domnuminterior: json['dom_num_interior'],
      domindicaciones: json['dom_indicaciones'],
      domtipo: json['dom_tipo'],
      domtelefono: json['dom_telefono'],
      domactivo: json['dom_activo'],
      domcreador: json['dom_creador'],
      descripcionlarga: json['str_domicilio'],
    );
  }
}


class Usuario {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String datejoined;
  final String lastlogin;
  final List<Domicilio> domicilio;

  Usuario({this.id, this.username, this.firstname, this.lastname, this.email, this.datejoined, this.lastlogin, this.domicilio});

  factory Usuario.fromJson(dynamic json){
    List<Domicilio> domicilios = []; 
    if (json['user_domicilio'] != null) {
      for (var item in json['user_domicilio']) {
      Domicilio dom = Domicilio.fromJson(item);
      domicilios.add(dom);
    }
    }
    return Usuario(
      id: json['id'],
      username: json['username'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      email: json['email'],
      datejoined: json['date_joined'],
      lastlogin: json['last_login'],
      domicilio: domicilios
    );
  }
}



class TipoDomicilio {
  final int number;
  final String texto;

  TipoDomicilio({this.number, this.texto});
  
}



class ProductoCarritoCompra{
  final int id;
  final String pedidoid;
  final String productoid;
  final int cantidad;
  final int creadopor;
  final double precio;
  final bool status;
  final double total;
  final String urlImagen;
  final String descripcion;

  ProductoCarritoCompra({this.id, this.pedidoid, this.productoid, this.cantidad, this.creadopor, this.precio, this.status, this.total, this.urlImagen, this.descripcion});

  factory ProductoCarritoCompra.fromJson(dynamic json){
    return ProductoCarritoCompra(
            id:json['id'],
            pedidoid:json['dcw_pedido_id'],
            productoid:json['dcw_producto_id']['producto_codigo'],
            cantidad:json['dcw_cantidad'],
            creadopor:json['dcw_creado_por'],
            precio:json['dcw_precio'],
            status:json['dcw_status'],
            total:json['sub_total'],
            urlImagen:json['dcw_producto_id']['producto_imagen'],
            descripcion:json['dcw_producto_id']['producto_nombre'],
    );
  }
  
  
}