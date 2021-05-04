class Categoria {
  int idCategoria;
  String descCategoria;
  int parTipoCategoria;
  String observacion;
  String imagen;

  bool estadoRegistro;
  String usuarioRegistro;
  String fechaRegistro;
  String usuarioModificacion;
  String fechaModificacion;

  Categoria(
      {this.idCategoria,
      this.descCategoria,
      this.parTipoCategoria,
      this.observacion,
      this.imagen,
      this.estadoRegistro,
      this.usuarioRegistro,
      this.fechaRegistro,
      this.usuarioModificacion,
      this.fechaModificacion});

  Map<String, dynamic> toMap() {
    return {
      'id_categoria': idCategoria,
      'desc_categoria': descCategoria,
      'par_tipo_categoria': parTipoCategoria,
      'observacion': observacion,
      'imagen': imagen,
      'estado_registro': estadoRegistro,
      'usuario_registro': usuarioRegistro,
      'fecha_registro': fechaRegistro,
      'usuario_modificacion': usuarioModificacion,
      'fecha_modificacion': fechaModificacion
    };
  }

  Categoria.fromMap(Map<String, dynamic> map) {
    idCategoria = map["id_categoria"];
    descCategoria = map["desc_categoria"];
    parTipoCategoria = map["par_tipo_categoria"];
    observacion = map["observacion"];
    imagen = map["imagen"];
    estadoRegistro = map["estado_registro"] == 0 ? false : true;
    usuarioRegistro = map["usuario_registro"];
    // fechaRegistro = DateTime.parse(map["fecha_registro"]);
    fechaRegistro = map["fecha_registro"];
    usuarioModificacion = map["usuario_modificacion"];
    fechaModificacion = map["fecha_modificacion"];
  }
}
