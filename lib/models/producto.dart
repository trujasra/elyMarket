class Producto {
  int idProducto;
  int idCategoria;
  String descProducto;
  double precio;
  String observacion;
  String lugarCompra;
  String imagen;

  bool estadoRegistro;
  String usuarioRegistro;
  String fechaRegistro;
  String usuarioModificacion;
  String fechaModificacion;

  Producto(
      {this.idProducto,
      this.idCategoria,
      this.descProducto,
      this.precio,
      this.observacion,
      this.lugarCompra,
      this.imagen,
      this.estadoRegistro,
      this.usuarioRegistro,
      this.fechaRegistro,
      this.usuarioModificacion,
      this.fechaModificacion});

  Map<String, dynamic> toMap() {
    return {
      'id_producto': idProducto,
      'id_categoria': idCategoria,
      'desc_producto': descProducto,
      'precio': precio,
      'observacion': observacion,
      'lugar_compra': lugarCompra,
      'imagen': imagen,
      'estado_registro': estadoRegistro,
      'usuario_registro': usuarioRegistro,
      'fecha_registro': fechaRegistro,
      'usuario_modificacion': usuarioModificacion,
      'fecha_modificacion': fechaModificacion
    };
  }

  Producto.fromMap(Map<String, dynamic> map) {
    idProducto = map["id_producto"];
    idCategoria = map["id_categoria"];
    descProducto = map["desc_producto"];
    precio = map["precio"];
    observacion = map["observacion"];
    lugarCompra = map["lugar_compra"];
    imagen = map["imagen"];
    estadoRegistro = map["estado_registro"] == 0 ? false : true;
    usuarioRegistro = map["usuario_registro"];
    fechaRegistro = map["fecha_registro"];
    usuarioModificacion = map["usuario_modificacion"];
    fechaModificacion = map["fecha_modificacion"];
  }
}
