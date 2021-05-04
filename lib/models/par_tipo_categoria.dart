class ParTipoCategoria {
  int idTipoCategoria;
  String tipoCategoria;

  bool estadoRegistro;
  String usuarioRegistro;
  String fechaRegistro;
  String usuarioModificacion;
  String fechaModificacion;

  ParTipoCategoria(
      {this.idTipoCategoria,
      this.tipoCategoria,
      this.estadoRegistro,
      this.usuarioRegistro,
      this.fechaRegistro,
      this.usuarioModificacion,
      this.fechaModificacion});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_tipo_categoria': idTipoCategoria,
      'tipo_categoria': tipoCategoria,
      'estado_registro': estadoRegistro,
      'usuario_registro': usuarioRegistro,
      'fecha_registro': fechaRegistro,
      'usuario_modificacion': usuarioModificacion,
      'fecha_modificacion': fechaModificacion
    };
    return map;
  }

  ParTipoCategoria.fromMap(Map<String, dynamic> map) {
    idTipoCategoria = map["id_tipo_categoria"];
    tipoCategoria = map["tipo_categoria"];
    estadoRegistro = map["estado_registro"] == 0 ? false : true;
    usuarioRegistro = map["usuario_registro"];
    fechaRegistro = map["fecha_registro"];
    usuarioModificacion = map["usuario_modificacion"];
    fechaModificacion = map["fecha_modificacion"];
  }
}
