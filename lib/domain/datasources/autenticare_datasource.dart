import 'dart:async';

import 'package:control_acceso_emlaze/domain/models/autenticate.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class AutenticateDatosurce {
  final String? code;
  late Future<Isar> db;

  AutenticateDatosurce({this.code});
  
  Future<Isar> openDB() async {
    
    final dir = await getApplicationDocumentsDirectory();

    if(Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [AutenticateSchema], 
        inspector: true,
        directory: dir.path
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future autenticate() async {
    db = openDB();
    final dio = Dio(BaseOptions(
      baseUrl: 'https://www.emlaze.net/includes/api/slimAPI/public',
      headers: {
        'Authorization': code
      }
    ));
    final response = await dio.get('/testtokenQR',);
    if(response.data['status'] == true) {
      final isar = await db;
      final dataRes = Autenticate(
        status: response.data['status'], 
        message: response.data['message'], 
        data: response.data['data']
      );
      isar.writeTxnSync(() => isar.autenticates.putSync(dataRes));
      return '/access-screen';
    } else {
      
    }
  }



  
}