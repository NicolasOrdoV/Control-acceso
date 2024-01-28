import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
// import 'package:barcode_scan2/gen/protos/protos.pb.dart';
// import 'package:barcode_scan2/model/android_options.dart';
// import 'package:barcode_scan2/model/scan_options.dart';
// import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:barcode_scanner/barcode_scanning_data.dart';
import 'package:barcode_scanner/classical_components/barcode_scanner_configuration.dart';
import 'package:barcode_scanner/json/common_data.dart';
import 'package:barcode_scanner/scanbot_barcode_sdk.dart';
import 'package:barcode_scanner/scanbot_sdk_models.dart';
import 'package:control_acceso_emlaze/domain/datasources/autenticare_datasource.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AccessScreen extends StatefulWidget {

  static const name = 'access-screen';
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {

  late Timer _timer;
  
  // ScanResult? scanResult;

  // final _flashOnController = TextEditingController(text: 'Flash on');
  // final _flashOffController = TextEditingController(text: 'Flash off');
  // final _cancelController = TextEditingController(text: 'Cancel');

  // final _aspectTolerance = 100.00;
  // final _selectedCamera = 0;
  // final _useAutoFocus = true;
  // final _autoEnableFlash = true;

  // static final _possibleFormats = [BarcodeFormat.pdf417];

  // List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    AutenticateDatosurce().loadAccess();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content:  SizedBox(
              width: 30,
              height: 210,
              child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
                    SizedBox(height: 20,),
                    Text('¡Bienvenido!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text('Escanee el código de barras de la cédula del personal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                  ],
                ),
            ),

            
          );
        },
      );
    });

    _timer = Timer(const Duration(seconds: 2) , () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future scanBarcode(int tipo) async { 
    String licenseKey =
      "D7LE+Z2la7jpVq1f314y3fS+n44dXPJmHMm8G+X5rKO/ALmeLBPBdC299+RCGcZepG+WxjQNozKS/WlyrKO/h9/k5EXeNBajVkgrOEeV7dVvbg1YHKJinYZgIOV8ytnB7sNgMT/J+Dl4WsVZXtqYDx1xvZ8p0Lu2noz3fw4S/JNNmEg0GQmpY0N+oB1qTCGaUUzvgIzeIiC88IzUM4XC/Pcb6DQp7KQKyMnYQY1jNf1fF0bwk1fmi90PliJiu6+Zbj08Pt0szJIMjVklG3YUVcEnyU1IvsvQV4FDWDIC5LzBvMxCf5smtZblQ/6gi136RfyBBSgRm4i0tj/331HURw==\nU2NhbmJvdFNESwpjb20uZXhhbXBsZS5jb250cm9sX2FjY2Vzb19lbWxhemUKMTcwNzAwNDc5OQo4Mzg4NjA3CjE5\n";
    final config = ScanbotSdkConfig(
      licenseKey: licenseKey,
      loggingEnabled: false,
      useCameraX: true,
      allowGpuAcceleration: true
    );
    ScanbotBarcodeSdk.initScanbotSdk(config);

    //iniciar escaneo//
    final config2 = BarcodeScannerConfiguration(
      barcodeFormats: BarcodeFormat.values,
      topBarBackgroundColor: const Color.fromARGB(255, 51, 122, 183),
      finderTextHint: "Por favor, posicione el codigo de la cedula para poderla escanear.",
      cancelButtonTitle: "Cancelar",
      flashEnabled: false,
      orientationLockMode: OrientationLockMode.LANDSCAPE,
      engineMode: EngineMode.LEGACY,
      successBeepEnabled: true,
      finderAspectRatio: const FinderAspectRatio(
        width: 500,
        height: 100
      ),

    );
    final result = await ScanbotBarcodeSdk.startBarcodeScanner(config2);
    final List<Uint8List?> lista = result.barcodeItems.map((e) => e.rawBytes).toList();
    List<int> bytes = [];
    for (var uint8 in lista) {
      for(int uint82 in uint8!) {
        if(uint82 != 0){
          bytes.add(uint82.toInt());
        }
      }
    }
    final codeCedula = String.fromCharCodes(bytes);

    //print("Aqui ${String.fromCharCodes(bytes)}");


    // try {
    //   SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    //   BarcodeScanner.cameraAccessGranted.characters;
    //   final result = await BarcodeScanner.scan(
    //     options: ScanOptions(
    //       strings: {
    //         'cancel': _cancelController.text,
    //         'flash_on': _flashOnController.text,
    //         'flash_off': _flashOffController.text,
    //       },
    //       restrictFormat: selectedFormats,
    //       useCamera: _selectedCamera,
    //       autoEnableFlash: _autoEnableFlash,
    //       android: AndroidOptions(
    //         aspectTolerance: _aspectTolerance,
    //         useAutoFocus: _useAutoFocus,
    //       ),
    //     ),
    //   );
    //   print("Aqui: ${result.rawContent}");
    // } on PlatformException catch (e) {
    //   setState(() {
    //     scanResult = ScanResult(
    //       rawContent: e.code == BarcodeScanner.cameraAccessDenied
    //           ? 'The user did not grant the camera permission!'
    //           : 'Unknown error: $e',
    //     );
    //   });
    // }
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Control de acceso EMLAZE ERP'),
        backgroundColor: const Color.fromARGB(255, 51, 122, 183),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              AutenticateDatosurce().destroySession();
              context.go('/home/0');
            }, 
            icon: const Icon(Icons.exit_to_app_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fondo.png'), 
              fit: BoxFit.fill
            ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Container(
                  width: 350,
                  height: 305,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        child: Image.asset('assets/images/logo.png', 
                        fit: BoxFit.contain, width: 300,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Text('Indique el tipo de registro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                      const SizedBox(height: 8,),
                      ElevatedButton(
                        onPressed: () {
                          int tipo = 1;
                          scanBarcode(tipo);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 51, 122, 183),
                          padding: const EdgeInsets.only(right: 110, left: 110)
                        ), 
                        child: const Text('Entrada', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        
                      ),
                      const SizedBox(height: 3,),
                      ElevatedButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 51, 122, 183),
                          padding: const EdgeInsets.only(right: 102, left: 102)
                        ), 
                        child: const Text('Descanso', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        
                      ),
                      const SizedBox(height: 3,),
                      ElevatedButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 51, 122, 183),
                          padding: const EdgeInsets.only(right: 115, left: 115)
                        ), 
                        child: const Text('Salida', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child:  Text('Software Emlaze ERP. Todos los derechos reservados, Prohibida su reproducción total o parcial de los contenidos y base de datos. Al ingresar al sistema estara aprobando Terminos y condiciones y Politica de Proteccion y Tratamiento de Datos Personales de www.emlaze.com', style: TextStyle(fontSize: 15,), textAlign: TextAlign.justify),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {}, 
                      icon: const Icon(Icons.facebook_rounded), 
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        iconColor: MaterialStatePropertyAll(Color.fromARGB(255, 51, 122, 183)),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      onPressed: () {}, 
                      icon: const FaIcon(FontAwesomeIcons.twitter), 
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        iconColor: MaterialStatePropertyAll(Color.fromARGB(255, 51, 122, 183)),
                      ),
                    )
                  ],
                )
            ],
          )
        ),
      ),
    );
  }
}