import 'dart:io' as io;
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import 'package:eli_market/models/categoria.dart';
import 'package:eli_market/models/par_tipo_categoria.dart';
import 'package:eli_market/models/producto.dart';
import 'package:eli_market/models/producto_bitacora.dart';
import 'package:eli_market/models/producto_a_comprar.dart';

class DataBaseHelper {
  static final DataBaseHelper db = DataBaseHelper._();
  static Database _database;

  // Datos de la Base de datos
  static const String DB_NAME = 'db_mercado.db';
  // Datos de las tablas
  static const String TABLA_TIPO_CATEGORIA = 'Par_tipo_categoria';
  static const String TABLA_CATEGORIA = 'Categoria';
  static const String TABLA_PRODUCTO = 'Producto';
  static const String TABLA_PRODUCTO_BITACORA = 'Producto_bitacora';
  static const String TABLA_PRODUCTO_A_COMPRAR = 'Producto_a_comprar';

  // Campos para las tablas Bitacora
  static const String ESTADO_REGISTRO = 'estado_registro';
  static const String USUARIO_REGISTRO = 'usuario_registro';
  static const String FECHA_REGISTRO = 'fecha_registro';
  static const String USUARIO_MODIFICACION = 'usuario_modificacion';
  static const String FECHA_MODIFICACION = 'fecha_modificacion';

  // Campos tabla  PAR_TIPO_CATEGORIA
  static const String ID_TIPO_CATEGORIA = 'id_tipo_categoria';
  static const String TIPO_CATEGORIA = 'tipo_categoria';

  // Campos tabla CATEGORIA
  static const String ID_CATEGORIA = 'id_categoria';
  static const String DESC_CATEGORIA = 'desc_categoria';
  static const String PAR_TIPO_CATEGORIA = 'par_tipo_categoria';
  static const String OBSERVACION = 'observacion';
  static const String IMAGEN = 'imagen';

  // Campos tabla PRODUCTO
  static const String ID_PRODUCTO = 'id_producto';
  static const String DESC_PRODUCTO = 'desc_producto';
  static const String PRECIO = 'precio';
  static const String LUGAR_COMPRA = 'lugar_compra';

  // Campos tabla PRODUCTO_BITACORA
  static const String ID_PRODUCTO_BITACORA = 'id_producto_bitacora';
  static const String USUARIO_REGISTRO_PROD = 'usuario_registro_prod';
  static const String FECHA_REGISTRO_PROD = 'fecha_registro_prod';

  // Campos tabla PRODUCTO_A_COMPRAR
  static const String ID_PRODUCTO_A_COMPRAR = 'id_producto_a_comprar';

  DataBaseHelper._();

  Future<Database> get database async {
    // Verifica si la BD es diferente de nulo
    if (_database != null) {
      return _database;
    }

    // envia al metodo para inicializar la BD
    _database = await iniciaDB();
    return _database;
  }

  iniciaDB() async {
    io.Directory documentoDirectorio = await getApplicationDocumentsDirectory();
    String path = join(documentoDirectorio.path, DB_NAME);

    // Delete the database //TODO: esto luego borrar
    //await deleteDatabase(path);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    String sqlParTipoCategoria =
        "CREATE TABLE $TABLA_TIPO_CATEGORIA ($ID_TIPO_CATEGORIA INTEGER PRIMARY KEY, $TIPO_CATEGORIA TEXT, $ESTADO_REGISTRO BOOLEAN, $USUARIO_REGISTRO TEXT, $FECHA_REGISTRO TEXT, $USUARIO_MODIFICACION TEXT, $FECHA_MODIFICACION TEXT)";
    String sqlCategoria =
        "CREATE TABLE $TABLA_CATEGORIA ($ID_CATEGORIA INTEGER PRIMARY KEY AUTOINCREMENT, $DESC_CATEGORIA TEXT, $PAR_TIPO_CATEGORIA INTEGER, $OBSERVACION TEXT, $IMAGEN TEXT, $ESTADO_REGISTRO BOOLEAN, $USUARIO_REGISTRO TEXT, $FECHA_REGISTRO TEXT, $USUARIO_MODIFICACION TEXT, $FECHA_MODIFICACION TEXT)";
    String sqlProducto =
        "CREATE TABLE $TABLA_PRODUCTO ($ID_PRODUCTO INTEGER PRIMARY KEY AUTOINCREMENT, $ID_CATEGORIA INTEGER, $DESC_PRODUCTO TEXT, $PRECIO DOUBLE, $OBSERVACION TEXT, $LUGAR_COMPRA TEXT, $IMAGEN TEXT, $ESTADO_REGISTRO BOOLEAN, $USUARIO_REGISTRO TEXT, $FECHA_REGISTRO TEXT, $USUARIO_MODIFICACION TEXT, $FECHA_MODIFICACION TEXT)";
    String sqlProductoBitacora =
        "CREATE TABLE $TABLA_PRODUCTO_BITACORA ($ID_PRODUCTO_BITACORA INTEGER PRIMARY KEY AUTOINCREMENT, $ID_PRODUCTO INTEGER, $ID_CATEGORIA INTEGER, $DESC_PRODUCTO TEXT, $PRECIO DOUBLE, $OBSERVACION TEXT, $LUGAR_COMPRA TEXT, $IMAGEN TEXT, $USUARIO_REGISTRO_PROD TEXT, $FECHA_REGISTRO_PROD TEXT, $ESTADO_REGISTRO BOOLEAN, $USUARIO_REGISTRO TEXT, $FECHA_REGISTRO TEXT, $USUARIO_MODIFICACION TEXT, $FECHA_MODIFICACION TEXT)";
    String sqlProductoAComprar =
        "CREATE TABLE $TABLA_PRODUCTO_A_COMPRAR ($ID_PRODUCTO_A_COMPRAR INTEGER PRIMARY KEY AUTOINCREMENT, $OBSERVACION TEXT, $ESTADO_REGISTRO BOOLEAN, $USUARIO_REGISTRO TEXT, $FECHA_REGISTRO TEXT, $USUARIO_MODIFICACION TEXT, $FECHA_MODIFICACION TEXT)";

    // Crea las tablas de la BD
    await db.execute(sqlParTipoCategoria);
    await db.execute(sqlCategoria);
    await db.execute(sqlProducto);
    await db.execute(sqlProductoBitacora);
    await db.execute(sqlProductoAComprar);

    //String vDato = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    //Insertar por defecto los tipo de categoria
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA, $TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          1,
          "Verduras y hortalizas",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA,$TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          2,
          "Frutas",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA,$TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          3,
          "Refrescos y bebidas",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA,$TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          4,
          "Carnes y pollos",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA,$TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          5,
          "Limpieza",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA,$TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          6,
          "Abarrotes y aceites",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_TIPO_CATEGORIA($ID_TIPO_CATEGORIA,$TIPO_CATEGORIA,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?)",
        [
          7,
          "Otros",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);

    // Crea por defecto registros para la tabla categoria
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Verduras y hortalizas",
          1,
          "Datos para el regsitro de verduras y hortalizas",
          "assets/imagenes/verduras.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Frutas",
          2,
          "Datos para el registro de frutas",
          "assets/imagenes/frutas.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Refrescos y bebidas",
          3,
          "Datos para el registro de refrescos y bebidas",
          "assets/imagenes/refrescos.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Carnes y pollos",
          4,
          "Datos para el registro de carnes y pollos",
          "assets/imagenes/carnes.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Limpieza",
          5,
          "Datos para el registro de limpieza",
          "assets/imagenes/limpieza.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Abarrotes y aceites",
          6,
          "Datos para el registro de abarrotes y aceites",
          "assets/imagenes/abarrotes.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
    await db.execute(
        "INSERT INTO $TABLA_CATEGORIA($DESC_CATEGORIA,$PAR_TIPO_CATEGORIA,$OBSERVACION,$IMAGEN,$ESTADO_REGISTRO,$USUARIO_REGISTRO,$FECHA_REGISTRO) VALUES(?,?,?,?,?,?,?)",
        [
          "Otros y más...",
          7,
          "Datos para el registro de otros",
          "assets/imagenes/otros_mas.png",
          true,
          "ramiro.trujillo",
          DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())
        ]);
  }

  // CATEGORIA
  // Operacion lista : Obtiene todos los registros de la BD
  Future<List<Categoria>> obtieneCategoria() async {
    var dbClient = await database;
    // List<Map> maps = await dbClient.query(TABLA_CATEGORIA, columns: [ID, NAME, LAST_NAME]);
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_CATEGORIA WHERE $ESTADO_REGISTRO = 1 ORDER BY $DESC_CATEGORIA ASC");
    List<Categoria> listaCategoria = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listaCategoria.add(Categoria.fromMap(maps[i]));
      }
    }
    return listaCategoria;
  }

  // Operacion lista : Obtiene el registro por el identificador de Categoria de la BD
  Future<Categoria> obtieneCategoriaPorId(int idCategoria) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_CATEGORIA WHERE $ESTADO_REGISTRO = 1 AND $ID_CATEGORIA = $idCategoria");
    Categoria listaCategoria = Categoria();
    if (map.length > 0) {
      listaCategoria = Categoria.fromMap(map[0]);
    }
    return listaCategoria;
  }

  // Operacion Adicionar : Registra el objeto categoria a la BD
  Future<Categoria> registraCategoria(Categoria categoria) async {
    var dbClient = await database;

    categoria.estadoRegistro = true;
    categoria.usuarioRegistro = "ramiro.trujillo";
    categoria.fechaRegistro =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    categoria.idCategoria =
        await dbClient.insert(TABLA_CATEGORIA, categoria.toMap());
    return categoria;
  }

  // Operacion actualizacion : Actualiza el objeto categoria a la BD
  Future<int> actualizaCategoria(Categoria categoria) async {
    var dbClient = await database;

    categoria.usuarioModificacion = "ramiro.trujillo";
    categoria.fechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var resultado = await dbClient.update(TABLA_CATEGORIA, categoria.toMap(),
        where: '$ID_CATEGORIA = ?', whereArgs: [categoria.idCategoria]);
    return resultado;
  }

  // Operacion eliminacion : Eliminacion logica Estado_regstro =0 objeto Categoria a la BD
  Future<int> eliminaCategoria(int idCategoria) async {
    var dbClient = await database;

    String vUsuarioModificacion = "ramiro.trujillo";
    String vFechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    String vSql =
        "UPDATE $TABLA_CATEGORIA SET $ESTADO_REGISTRO = 0, $USUARIO_MODIFICACION = '$vUsuarioModificacion', $FECHA_MODIFICACION = '$vFechaModificacion' WHERE $ID_CATEGORIA = $idCategoria";
    var resultado = await dbClient.rawUpdate(vSql);
    return resultado;
  }

// TIPO CATEGORIA
  // Operacion lista : Obtiene todos los registros de la BD
  Future<List<ParTipoCategoria>> obtieneTipoCategoria() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_TIPO_CATEGORIA WHERE $ESTADO_REGISTRO = 1 ORDER BY $TIPO_CATEGORIA ASC");
    List<ParTipoCategoria> listaTipoCategoria = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listaTipoCategoria.add(ParTipoCategoria.fromMap(maps[i]));
      }
    }
    return listaTipoCategoria;
  }

  // Operacion lista : Obtiene el registro por el identificador de Tipo Categoria de la BD
  Future<ParTipoCategoria> obtieneTipoCategoriaPorId(
      int idTipoCategoria) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_TIPO_CATEGORIA WHERE $ESTADO_REGISTRO = 1 AND $ID_TIPO_CATEGORIA = $idTipoCategoria");
    ParTipoCategoria listaTipoCategoria = ParTipoCategoria();
    if (map.length > 0) {
      listaTipoCategoria = ParTipoCategoria.fromMap(map[0]);
    }
    return listaTipoCategoria;
  }

  // Operacion Adicionar : Registra el objeto Tipo Categoria a la BD
  Future<ParTipoCategoria> registraTipoCategoria(
      ParTipoCategoria tipoCategoria) async {
    var dbClient = await database;

    tipoCategoria.estadoRegistro = true;
    tipoCategoria.usuarioRegistro = "ramiro.trujillo";
    tipoCategoria.fechaRegistro =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    tipoCategoria.idTipoCategoria =
        await dbClient.insert(TABLA_TIPO_CATEGORIA, tipoCategoria.toMap());
    return tipoCategoria;
  }

  // Operacion actualizacion : Actualiza el objeto Tipo Categoria a la BD
  Future<int> actualizaTipoCategoria(ParTipoCategoria tipoCategoria) async {
    var dbClient = await database;

    tipoCategoria.usuarioModificacion = "ramiro.trujillo";
    tipoCategoria.fechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var resultado = await dbClient.update(
        TABLA_TIPO_CATEGORIA, tipoCategoria.toMap(),
        where: '$ID_TIPO_CATEGORIA = ?',
        whereArgs: [tipoCategoria.idTipoCategoria]);
    return resultado;
  }

  // Operacion eliminacion : Eliminacion logica Estado_registro =0 objeto Tipo Categoria a la BD
  Future<int> eliminaTipoCategoria(int idTipoCategoria) async {
    var dbClient = await database;

    String vUsuarioModificacion = "ramiro.trujillo";
    String vFechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    String vSql =
        "UPDATE $TABLA_TIPO_CATEGORIA SET $ESTADO_REGISTRO = 0, $USUARIO_MODIFICACION = '$vUsuarioModificacion', $FECHA_MODIFICACION = '$vFechaModificacion' WHERE $ID_TIPO_CATEGORIA = $idTipoCategoria";
    var resultado = await dbClient.rawUpdate(vSql);
    return resultado;
  }

// PRODUCTO
  // Operacion lista : Obtiene todos los productos de la BD
  Future<List<Producto>> obtieneProducto() async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO WHERE $ESTADO_REGISTRO = 1 ORDER BY $DESC_PRODUCTO ASC");
    List<Producto> listaProducto = [];
    if (map.length > 0) {
      for (var i = 0; i < map.length; i++) {
        listaProducto.add(Producto.fromMap(map[i]));
      }
    }
    return listaProducto;
  }

  // Operacion producto : Obtiene el registro por el identificador de producto de la BD
  Future<Producto> obtieneProductoPorId(int idProducto) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO WHERE $ESTADO_REGISTRO = 1 AND $ID_PRODUCTO = $idProducto");
    Producto producto = Producto();
    if (map.length > 0) {
      producto = Producto.fromMap(map[0]);
    }
    return producto;
  }

  // Operacion lista : Obtiene los productos por el identificador de categoria de la BD
  Future<List<Producto>> obtieneProductoPorIdCategoria(int idCategoria) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO WHERE $ESTADO_REGISTRO = 1 AND $ID_CATEGORIA = $idCategoria ORDER BY $DESC_PRODUCTO ASC");
    List<Producto> listaProducto = [];
    if (map.length > 0) {
      for (var i = 0; i < map.length; i++) {
        listaProducto.add(Producto.fromMap(map[i]));
      }
    }
    return listaProducto;
  }

  // Operacion Adicionar : Registra el objeto Producto a la BD
  Future<Producto> registraProducto(Producto producto) async {
    var dbClient = await database;

    producto.estadoRegistro = true;
    producto.usuarioRegistro = "ramiro.trujillo";
    producto.fechaRegistro =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    producto.idProducto =
        await dbClient.insert(TABLA_PRODUCTO, producto.toMap());
    return producto;
  }

  // Operacion actualizacion : Actualiza el objeto Producto a la BD
  Future<int> actualizaProducto(Producto producto) async {
    var dbClient = await database;

    producto.usuarioModificacion = "ramiro.trujillo";
    producto.fechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var resultado = await dbClient.update(TABLA_PRODUCTO, producto.toMap(),
        where: '$ID_PRODUCTO = ?', whereArgs: [producto.idProducto]);
    return resultado;
  }

  // Operacion eliminacion : Eliminacion logica Estado_registro =0 objeto Producto a la BD
  Future<int> eliminaProducto(int idProducto) async {
    var dbClient = await database;

    String vUsuarioModificacion = "ramiro.trujillo";
    String vFechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    String vSql =
        "UPDATE $TABLA_PRODUCTO SET $ESTADO_REGISTRO = 0, $USUARIO_MODIFICACION = '$vUsuarioModificacion', $FECHA_MODIFICACION = '$vFechaModificacion'  WHERE $ID_PRODUCTO = $idProducto";
    var resultado = await dbClient.rawUpdate(vSql);
    return resultado;
  }

  // PRODUCTO BITACORA
  // Operacion lista : Obtiene todos los productos bitacora de la BD
  Future<List<ProductoBitacora>> obtieneProductoBitacora() async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO_BITACORA WHERE $ESTADO_REGISTRO = 1 ORDER BY $ID_PRODUCTO_BITACORA ASC");
    List<ProductoBitacora> listaProductoBitacora = [];
    if (map.length > 0) {
      for (var i = 0; i < map.length; i++) {
        listaProductoBitacora.add(ProductoBitacora.fromMap(map[i]));
      }
    }
    return listaProductoBitacora;
  }

  // Operacion producto bitacora : Obtiene el registro por el identificador de producto bitacora de la BD
  Future<ProductoBitacora> obtieneProductoBitacoraPorId(
      int idProductoBitacora) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO_BITACORA WHERE $ESTADO_REGISTRO = 1 AND $ID_PRODUCTO_BITACORA = $idProductoBitacora");
    ProductoBitacora productoBitacora = ProductoBitacora();
    if (map.length > 0) {
      productoBitacora = ProductoBitacora.fromMap(map[0]);
    }
    return productoBitacora;
  }

  // Operacion lista : Obtiene los producto bitacora por el identificador de producto de la BD
  Future<List<ProductoBitacora>> obtieneProductoBitacoraPorIdProducto(
      int idProducto) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO_BITACORA WHERE $ESTADO_REGISTRO = 1 AND $ID_PRODUCTO = $idProducto ORDER BY $FECHA_REGISTRO DESC");
    List<ProductoBitacora> listaProductoBitacora = [];
    if (map.length > 0) {
      for (var i = 0; i < map.length; i++) {
        listaProductoBitacora.add(ProductoBitacora.fromMap(map[i]));
      }
    }
    return listaProductoBitacora;
  }

  // Operacion Adicionar : Registra el objeto Producto Bitacora a la BD
  Future<ProductoBitacora> registraProductoBitacora(
      ProductoBitacora productoBitacora) async {
    var dbClient = await database;

    productoBitacora.estadoRegistro = true;
    productoBitacora.usuarioRegistro = "ramiro.trujillo";
    productoBitacora.fechaRegistro =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    productoBitacora.idProductoBitacora = await dbClient.insert(
        TABLA_PRODUCTO_BITACORA, productoBitacora.toMap());
    return productoBitacora;
  }

  // Operacion actualizacion : Actualiza el objeto Producto Bitacora a la BD
  Future<int> actualizaProductoBitacora(
      ProductoBitacora productoBitacora) async {
    var dbClient = await database;

    productoBitacora.usuarioModificacion = "ramiro.trujillo";
    productoBitacora.fechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var resultado = await dbClient.update(
        TABLA_PRODUCTO_BITACORA, productoBitacora.toMap(),
        where: '$ID_PRODUCTO_BITACORA = ?',
        whereArgs: [productoBitacora.idProductoBitacora]);
    return resultado;
  }

  // Operacion eliminacion : Eliminacion logica Estado_registro =0 objeto Producto Bitacora a la BD
  Future<int> eliminaProductoBitacora(int idProductoBitacora) async {
    var dbClient = await database;

    String vUsuarioModificacion = "ramiro.trujillo";
    String vFechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    String vSql =
        "UPDATE $TABLA_PRODUCTO_BITACORA SET $ESTADO_REGISTRO = 0, $USUARIO_MODIFICACION = '$vUsuarioModificacion', $FECHA_MODIFICACION = '$vFechaModificacion' WHERE $ID_PRODUCTO_BITACORA = $idProductoBitacora";
    var resultado = await dbClient.rawUpdate(vSql);
    return resultado;
  }

  // PRODUCTO A COMPRAR
  // Operacion lista : Obtiene todos los productos a comparar de la BD
  Future<List<ProductoAComprar>> obtieneProductoAComparar() async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO_A_COMPRAR WHERE $ESTADO_REGISTRO = 1 ORDER BY $FECHA_REGISTRO DESC");
    List<ProductoAComprar> listaProductoAComprar = [];
    if (map.length > 0) {
      for (var i = 0; i < map.length; i++) {
        listaProductoAComprar.add(ProductoAComprar.fromMap(map[i]));
      }
    }
    return listaProductoAComprar;
  }

  // Operacion producto bitacora : Obtiene el registro por el identificador de producto a comparar  de la BD
  Future<ProductoAComprar> obtieneProductoACompararPorId(
      int idProductoAComprar) async {
    var dbClient = await database;
    List<Map> map = await dbClient.rawQuery(
        "SELECT * FROM $TABLA_PRODUCTO_A_COMPRAR WHERE $ESTADO_REGISTRO = 1 AND $ID_PRODUCTO_A_COMPRAR = $idProductoAComprar");
    ProductoAComprar productoAComprar = ProductoAComprar();
    if (map.length > 0) {
      productoAComprar = ProductoAComprar.fromMap(map[0]);
    }
    return productoAComprar;
  }

  // Operacion Adicionar : Registra el objeto Producto a comparar a la BD
  Future<ProductoAComprar> registraProductoAComparar(
      ProductoAComprar productoAComprar) async {
    var dbClient = await database;

    productoAComprar.estadoRegistro = true;
    productoAComprar.usuarioRegistro = "ramiro.trujillo";
    productoAComprar.fechaRegistro =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    productoAComprar.idProductoAComprar = await dbClient.insert(
        TABLA_PRODUCTO_A_COMPRAR, productoAComprar.toMap());
    return productoAComprar;
  }

  // Operacion actualizacion : Actualiza el objeto Producto a comparar a la BD
  Future<int> actualizaProductoAComparar(
      ProductoAComprar productoAComprar) async {
    var dbClient = await database;

    productoAComprar.usuarioModificacion = "ramiro.trujillo";
    productoAComprar.fechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    var resultado = await dbClient.update(
        TABLA_PRODUCTO_A_COMPRAR, productoAComprar.toMap(),
        where: '$ID_PRODUCTO_A_COMPRAR = ?',
        whereArgs: [productoAComprar.idProductoAComprar]);
    return resultado;
  }

  // Operacion eliminacion : Eliminacion logica Estado_registro =0 objeto Producto a comparar a la BD
  Future<int> eliminaProductoAComparar(int idProductoAComprar) async {
    var dbClient = await database;

    String vUsuarioModificacion = "ramiro.trujillo";
    String vFechaModificacion =
        DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

    String vSql =
        "UPDATE $TABLA_PRODUCTO_A_COMPRAR SET $ESTADO_REGISTRO = 0, $USUARIO_MODIFICACION = '$vUsuarioModificacion', $FECHA_MODIFICACION = '$vFechaModificacion' WHERE $ID_PRODUCTO_A_COMPRAR = $idProductoAComprar";
    var resultado = await dbClient.rawUpdate(vSql);
    return resultado;
  }

  Future close() async {
    var dbCliente = await database;
    dbCliente.close();
  }
}
