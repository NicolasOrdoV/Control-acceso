import 'package:control_acceso_emlaze/presentation/screens.dart';
import 'package:location/location.dart';

class AccessScreen extends StatefulWidget {
  static const name = 'access-screen';
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => AccessScreenState();
}

class AccessScreenState extends State<AccessScreen> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
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
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    Future<dynamic>? data;
    ScanResult? scanResult;
    scanResult = await FlutterHmsScanKit.startScan(
        isToastDebug: false, isContinuousClick: false);
    List<int>? uint8 = scanResult!.valueByte;
    if (uint8!.isNotEmpty) {
      List<int> bytes = [];
      for (int uint82 in uint8) {
        if (uint82 != 0) {
          bytes.add(uint82.toInt());
        } else {
          bytes.add(42); // El caracter 42 representa un (*) en bytes
        }
      }
      final codeCedula = String.fromCharCodes(bytes);
      //generar localizacion//
      final location = Location();
      bool isLocation = await location.serviceEnabled();
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
      body: Container(
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
