import 'package:control_acceso_emlaze/presentation/screens.dart';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:location/location.dart';

class AccessScreen extends StatefulWidget {
  static const name = 'access-screen';
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => AccessScreenState();
}

class AccessScreenState extends State<AccessScreen> {
  bool isConnected = false;
  // Size? _previewBarcode;
  // int? _cameraBarcode = FlutterMobileVision.CAMERA_BACK;
  // Size? _previewOcr;
  // int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;

  @override
  void initState() {
    super.initState();
    // FlutterMobileVision.start().then((previewSizes) => setState(() {
    //       if (previewSizes[_cameraBarcode] == null) {
    //         return;
    //       }
    //       _previewBarcode = previewSizes[_cameraBarcode]!.first;
    //       _previewOcr = previewSizes[_cameraOcr]!.first;
    //     }));
    Future<bool> isConnection = InternetConnectionChecker().hasConnection;
    isConnection.then((value) {
      if (value == true) {
        AutenticateDatosurce().loadAccess();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: SizedBox(
                  width: 30,
                  height: 210,
                  child: Column(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.greenAccent, size: 80),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Escanee el código de barras de la cédula del personal',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });

        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }
    });

    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    isConnected = await InternetConnectionChecker().hasConnection;
    setState(
        () {}); // Actualiza el estado para que se refleje en la interfaz gráfica
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future scanBarcode(int tipo) async {
    // List<Barcode> barcodes = [];
    // Size _scanpreviewOcr = _previewOcr ?? FlutterMobileVision.PREVIEW;
    // try {
    //   barcodes = await FlutterMobileVision.scan(
    //       flash: true,
    //       autoFocus: true,
    //       formats: Barcode.PDF417,
    //       multiple: false,
    //       waitTap: true,
    //       showText: false,
    //       camera: _cameraBarcode ?? FlutterMobileVision.CAMERA_BACK,
    //       fps: 15.0,
    //       scanArea:
    //           Size(_scanpreviewOcr.width + 1300, _scanpreviewOcr.height + 100),
    //       preview: _previewBarcode ?? FlutterMobileVision.PREVIEW,
    //       // preview: const Size(2000, 600),
    //       forceCloseCameraOnTap: false);
    //   //print("Aqui: ${barcodes}");
    // } on Exception {
    //   barcodes.add(Barcode('Failed to get barcode.'));
    // }

    // if (!mounted) return;
    // setState(() {
    //   SystemChrome.setPreferredOrientations(
    //       [DeviceOrientation.landscapeLeft, DeviceOrientation.portraitUp]);
    // });
    Future<dynamic>? data;
    String licenseKey =
        "VRuGAPPYrLUMvCv+BL/XeCzuKfOIv5Fwhj9xgTwn5LfXzbkUmhuSLbBF4wXVgXri0cCLDgk9kqV4FkSPe2jGtjrXSh4/AFRvGqI8zekcHtKDKdONwQncXmsynnN/GwZow8dOaZDWMWoginEI2e6Kk+z8Dm41tElcJ7h/TlM62aRvYhp7mOlA4Kc9k4FPL+8WjQWoqy+kLYU0rwiVZ7XNmZBvZADIbWajBaNbwJRK/NJsXJBZhPgvxPOwdE3g2E2DprUSF0j2DdaXPPZg4VC7QTGFmvLGdZXZNkTE8jJezg+gUJubod7f4f85rzH42NBUQ3SvvGePGMz+V6WtUhkYGw==\nU2NhbmJvdFNESwpjb20uZXhhbXBsZS5jb250cm9sX2FjY2Vzb19lbWxhemUKMTcwOTI1MTE5OQo4Mzg4NjA3CjE5\n";
    final config = ScanbotSdkConfig(
        licenseKey: licenseKey,
        loggingEnabled: false,
        useCameraX: true,
        allowGpuAcceleration: true);
    ScanbotBarcodeSdk.initScanbotSdk(config);

    //iniciar escaneo//
    final config2 = BarcodeScannerConfiguration(
      barcodeFormats: BarcodeFormat.values,
      topBarBackgroundColor: const Color.fromARGB(255, 51, 122, 183),
      finderTextHint:
          "Por favor, posicione el codigo de la cedula para poderla escanear.",
      cancelButtonTitle: "Cancelar",
      flashEnabled: false,
      orientationLockMode: OrientationLockMode.LANDSCAPE,
      engineMode: EngineMode.LEGACY,
      successBeepEnabled: true,
      finderAspectRatio: const FinderAspectRatio(width: 500, height: 100),
    );
    final result = await ScanbotBarcodeSdk.startBarcodeScanner(config2);
    if (result.barcodeItems.isNotEmpty) {
      final List<Uint8List?> lista =
          result.barcodeItems.map((e) => e.rawBytes).toList();
      List<int> bytes = [];
      for (var uint8 in lista) {
        for (int uint82 in uint8!) {
          if (uint82 != 0) {
            bytes.add(uint82.toInt());
          } else {
            bytes.add(42); // El caracter 42 representa un (*) en bytes
          }
        }
      }
      final codeCedula = String.fromCharCodes(bytes);
      //-------------------Obtener localizacion del dispositivo---------//
      final location = Location();
      bool isLocation = await location.serviceEnabled();

      //print("longitud: ${longitud} latitud: ${latitud}");
      if (codeCedula.isNotEmpty) {
        if (isLocation == true) {
          LocationData locationData = await location.getLocation();
          double latitud = locationData.latitude!;
          double longitud = locationData.longitude!;
          data = AutenticateDatosurce()
              .registerCode(codeCedula, tipo, longitud, latitud);
          return data;
        } else {
          return data;
        }
      }
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulación de carga
    AutenticateDatosurce().loadAccess();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Control de acceso EMLAZE ERP'),
        backgroundColor: const Color.fromARGB(255, 51, 122, 183),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
              if (isConnected) {
                AutenticateDatosurce().destroySession();
                Future.delayed(const Duration(seconds: 1), () {
                  context.push('/home/0');
                });
              } else {
                Future.delayed(const Duration(seconds: 2), () {
                  context.go('/home/0');
                });
              }
            },
            icon: const Icon(Icons.exit_to_app_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          height: double.maxFinite,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fondo.png'), fit: BoxFit.fill),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 50.0),
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
                      color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          width: 300,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (isConnected)
                          ? const _OptionsView()
                          : const Text(
                              "Sin conexion a internet",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const FooterView()
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class _OptionsView extends StatelessWidget {
  const _OptionsView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Indique el tipo de registro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
          onPressed: () {
            int tipo = 1;
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
            );
            Future<dynamic> result = AccessScreenState().scanBarcode(tipo);
            AlertView(response: result).viewAlert(context);
          },
          style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 51, 122, 183),
              padding: const EdgeInsets.only(right: 110, left: 110)),
          child: const Text(
            'Entrada',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        ElevatedButton(
          onPressed: () {
            int tipo = 3;
            Future<dynamic> result = AccessScreenState().scanBarcode(tipo);
            AlertView(response: result).viewAlert(context);
          },
          style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 51, 122, 183),
              padding: const EdgeInsets.only(right: 102, left: 102)),
          child: const Text(
            'Descanso',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        ElevatedButton(
          onPressed: () {
            int tipo = 2;
            Future<dynamic> result = AccessScreenState().scanBarcode(tipo);
            AlertView(response: result).viewAlert(context);
          },
          style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 51, 122, 183),
              padding: const EdgeInsets.only(right: 115, left: 115)),
          child: const Text(
            'Salida',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
