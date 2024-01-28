import 'dart:convert';

import 'package:flutter/material.dart';

class AlertView {
  final Future<dynamic> response;
  AlertView({required this.response});
  Future<void> viewAlert(BuildContext context) async {
    response.then((value){
      final stringValues = value.toString();
      Map<String, dynamic> resultMap = json.decode(stringValues);
      final status = resultMap['status'];
      final message = resultMap['message'];
      return showDialog<void>(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content:  SizedBox(
              width: 30,
              height: 210,
              child: Column(
                  children: [
                    status == true
                      ? const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80)
                      : const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 80),
                    const SizedBox(height: 20,),
                    Text(message, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ],
                ),
            ),
          );
        },
      );
    });
  }
}