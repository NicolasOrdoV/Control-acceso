import 'package:isar/isar.dart';
part 'autenticate.g.dart';

@collection
class Autenticate {

  Id? isarId;

  final bool status;
  final String message;
  final String data;

  Autenticate({required this.status, required this.message, required this.data});
}