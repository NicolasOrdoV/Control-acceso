import 'dart:convert';

import 'package:flutter/material.dart';

class AlertView {
  final Future<dynamic>? response;
  AlertView({this.response});
  Future<void> viewAlert(BuildContext context) async {
    response?.then((value) {
      final String stringValues;
      Map<String, dynamic> resultMap;
      final bool status;
      final String message;
      if (value != null) {
        stringValues = value.toString();
        resultMap = json.decode(stringValues);
        status = resultMap['status'];
        message = resultMap['message'];
      } else {
        status = false;
        message = "La ubicación no esta conectada";
      }

      return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              width: 30,
              height: 210,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    status == true
                        ? const Icon(Icons.check_circle,
                            color: Colors.greenAccent, size: 80)
                        : const Icon(Icons.error_outline_rounded,
                            color: Colors.redAccent, size: 80),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
