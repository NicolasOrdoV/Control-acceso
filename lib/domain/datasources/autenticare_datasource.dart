import 'dart:async';
import 'dart:convert';
import 'package:control_acceso_emlaze/domain/models/autenticate.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class AutenticateDatosurce {
  final String? code;
  late Future<Isar> db;
  final String url = "https://www.emlaze.net";

  AutenticateDatosurce({this.code});

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([AutenticateSchema],
          inspector: true, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future autenticate() async {
    db = openDB();
    bool isConnection = await InternetConnectionChecker().hasConnection;

    if (isConnection == true) {
      final dio = Dio(BaseOptions(
          baseUrl: '$url/includes/api/slimAPI/public',
          headers: {'Authorization': code}));
      final response = await dio.get(
        '/testtokenQR',
      );

      if (response.data != null &&
          response.data != "Wrong number of segments") {
        if (response.data['status'] == true) {
          final isar = await db;
          final dataRes = Autenticate(data: response.data['data']);

          final data =
              await isar.autenticates.filter().dataIsNotEmpty().findFirst();

          if (data == null) {
            isar.writeTxnSync(() => isar.autenticates.putSync(dataRes));
            // isar.close();
          }
          return '/access-screen';
        } else {
          return response.data['message'];
        }
      } else {
        return "Error de autenticación favor escaneé un QR actualizado";
      }
    } else {
      return '/access-screen';
    }
  }

  Future<String> findStorage() async {
    db = openDB();
    final isar = await db;
    final data = await isar.autenticates.filter().dataIsNotEmpty().findAll();
    if (data.isNotEmpty) {
      return '/access-screen';
    } else {
      return '';
    }
  }

  Future<void> destroySession() async {
    db = openDB();
    final isar = await db;
    final data = await isar.autenticates.filter().dataIsNotEmpty().findAll();
    if (data.isNotEmpty) {
      isar.writeTxn(() =>
          isar.autenticates.deleteAll(data.map((e) => e.isarId!).toList()));
    }
  }

  Future<void> loadAccess() async {
    db = openDB();
    final isar = await db;
    final List<Autenticate> dataRes = await isar.autenticates.where().findAll();
    bool isConnection = await InternetConnectionChecker().hasConnection;

    if (isConnection == true) {
      if (dataRes.isNotEmpty) {
        final dataString = dataRes.map((e) => e.data).toList();
        List<int> bytes = base64Decode(dataString[0]);
        String decodeData = utf8.decode(bytes);
        List<String> des = decodeData.split('/');
        //Desglose de variables
        String usernameapi = des[0];
        String passwordapi = des[1];
        String clienteapli = des[2];
        // String ipPublica = des[3];

        final dio = Dio(BaseOptions(
          baseUrl: '$url/includes/api/slimAPI/public',
        ));
        final response = await dio.post('/gettoken', data: {
          'username': usernameapi,
          'password': passwordapi,
          'client_id': clienteapli
        });
        if (response.data['status'] == true) {
          final dataResAccess =
              Autenticate(data: dataString[0], token: response.data['token']);
          final data =
              await isar.autenticates.filter().dataIsNotEmpty().findFirst();
          if (data != null) {
            isar.writeTxnSync(() => isar.autenticates.deleteSync(data.isarId!));
          }
          isar.writeTxn(() => isar.autenticates.put(dataResAccess));
        } else {
          autenticate();
        }
      }
    }
  }

  Future registerCode(String code, int tipo) async {
    db = openDB();
    final isar = await db;
    final String cedula = code.substring(24, 34);
    if (int.parse(cedula) > 0 && tipo > 0) {
      final List<Autenticate> dataRes =
          await isar.autenticates.where().findAll();
      if (dataRes.isNotEmpty) {
        final token = dataRes.map((e) => e.token).toList();
        //print("token ${token[0]}");
        final dio = Dio(BaseOptions(
            baseUrl: '$url/includes/api/slimAPI/public',
            headers: {'Authorization': token[0]}));
        final response = await dio.post('/access_register', data: {
          'tiporegistro': tipo,
          'idpersona': cedula,
          'latitud': 0.00,
          'longitud': 0.00
        });
        //print("Aqui ${response.data}");
        return response;
      }
    }
    loadAccess();
  }
}
