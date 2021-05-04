class ProductoAComprar {
  int idProductoAComprar;
  String observacion;

  bool estadoRegistro;
  String usuarioRegistro;
  String fechaRegistro;
  String usuarioModificacion;
  String fechaModificacion;

  ProductoAComprar(
      {this.idProductoAComprar,
      this.observacion,
      this.estadoRegistro,
      this.usuarioRegistro,
      this.fechaRegistro,
      this.usuarioModificacion,
      this.fechaModificacion});

  Map<String, dynamic> toMap() {
    return {
      'id_producto_a_comprar': idProductoAComprar,
      'observacion': observacion,
      'estado_registro': estadoRegistro,
      'usuario_registro': usuarioRegistro,
      'fecha_registro': fechaRegistro,
      'usuario_modificacion': usuarioModificacion,
      'fecha_modificacion': fechaModificacion
    };
  }

  ProductoAComprar.fromMap(Map<String, dynamic> map) {
    idProductoAComprar = map["id_producto_a_comprar"];
    observacion = map["observacion"];
    estadoRegistro = map["estado_registro"] == 0 ? false : true;
    usuarioRegistro = map["usuario_registro"];
    fechaRegistro = map["fecha_registro"];
    usuarioModificacion = map["usuario_modificacion"];
    fechaModificacion = map["fecha_modificacion"];
  }
}
