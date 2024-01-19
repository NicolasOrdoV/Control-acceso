import 'dart:async';
import 'dart:convert';
import 'package:control_acceso_emlaze/domain/models/access.dart';
import 'package:control_acceso_emlaze/domain/models/autenticate.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class AutenticateDatosurce {
  final String? code;
  late Future<Isar> db;
  late Future<Isar> dbAccess;
  final String url = "https://www.emlaze.net";

  AutenticateDatosurce({this.code});

  Future<Isar> openDB(CollectionSchema schema) async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([schema],
          inspector: true, directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future autenticate() async {
    db = openDB(AutenticateSchema);
    final dio = Dio(BaseOptions(
        baseUrl: '$url/includes/api/slimAPI/public',
        headers: {'Authorization': code}));
    final response = await dio.get(
      '/testtokenQR',
    );

    if (response.data != null && response.data != "Wrong number of segments") {
      // print("Aqui" + response.data);
      if (response.data['status'] == true) {
        final isar = await db;
        final dataRes = Autenticate(
            status: response.data['status'],
            message: response.data['message'],
            data: response.data['data']);

        final data = await isar.autenticates.filter().dataIsNotEmpty().findFirst();

        if (data == null) {
          isar.writeTxnSync(() => isar.autenticates.putSync(dataRes));
        }
        return '/access-screen';
      } else {
        return response.data['message'];
      }
    } else {
      return "Error de autenticación favor escaneé un QR actualizado";
    }
  }

  Future<void> destroySession() async {
    db = openDB(AutenticateSchema);
    // dbAccess = openDB(AccessSchema);
    final isar = await db;
    // final isarAccess = await dbAccess;
    final data = await isar.autenticates.filter().dataIsNotEmpty().findFirst();
    // final dataAccess = await isarAccess.access.filter().tokenIsNotEmpty().findFirst();
    if (data != null) {
      isar.writeTxnSync(() => isar.autenticates.deleteSync(data.isarId!));
      // isarAccess.writeTxnSync(() => isarAccess.access.deleteSync(dataAccess!.isarIdAccess!));
    }
  }

  Future<void> loadAccess() async {
    db = openDB(AutenticateSchema);
    // dbAccess = openDB(AccessSchema);
    final isar = await db;
    // final isarAccess = await dbAccess;
    final List<Autenticate> data = await isar.autenticates.where().findAll();

    if(data.isNotEmpty) {
      final dataRes = data.map((e) => e.data).toList();
      List<int> bytes = base64Decode(dataRes[0]);
      String decodeData = utf8.decode(bytes);
      
    }
  }
}