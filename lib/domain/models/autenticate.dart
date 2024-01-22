import 'package:isar/isar.dart';
part 'autenticate.g.dart';

@collection
class Autenticate {

  Id? isarId;

  final String data;
  final String? token;

  Autenticate({this.token, required this.data});
}