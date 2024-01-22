import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class BarcodeScan extends StatelessWidget {

  const BarcodeScan();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRCodeDartScanView(
        scanInvertedQRCode: true,
        typeScan: TypeScan.live,
        takePictureButtonBuilder: (context,controller,isLoading){ // if typeScan == TypeScan.takePicture you can customize the button.
          // if(loading) return CircularProgressIndicator();
          return ElevatedButton(
              onPressed:controller.takePictureAndDecode,
              child:Text('Take a picture'),
          );
        },
        resolutionPreset: QRCodeDartScanResolutionPreset.high,
        formats: const [ // You can restrict specific formats.
          BarcodeFormat.PDF_417,
        ],
        onCapture: (Result result) {
          print(result.text);
        },
      ),
    );
  }
}