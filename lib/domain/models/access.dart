import 'package:isar/isar.dart';
part 'access.g.dart';

@collection

class Access {
  Id? isarIdAccess;
  
  final bool status;
  final String? token;
  final int? exp;
  final String? message;

  Access({required this.status, required this.token, required this.exp, required this.message});
}