import 'package:control_acceso_emlaze/presentation/screens.dart';

class HomeScreen extends StatefulWidget {
  static const name = "home-screen";
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    Future<String> isStorage = AutenticateDatosurce().findStorage();
    isStorage.then((value) {
      String route = value.toString();
      if (route.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 5), () {
          context.push(route);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      // print("Aqui esta la respuesta " + barcodeScanRes);
      Future<dynamic> route =
          AutenticateDatosurce(code: barcodeScanRes).autenticate();
      return route;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    width: 300,
                  ),
                ),
                const SizedBox(height: 10,),
                const CircularProgressIndicator(color: Color.fromARGB(255, 51, 122, 183),),
                const SizedBox(height: 10,),
                const Text('EMLAZE ERP Control de acceso \n Version 4.0', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),),
                
              ],
            )
          );
        } else {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fondo.png'),
                  fit: BoxFit.fill),
            ),
            child: Center(
                child: FadeIn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 260,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: Column(
                      children: [
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
                        const Text(
                          'Control de acceso',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                          'EMLAZE ERP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Future<dynamic> result = scanQR();
                            result.then((value) {
                              String result = value.toString();

                              if (result == '/access-screen') {
                                context.push(result);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 30,
                                        height: 210,
                                        child: Column(
                                          children: [
                                            const Icon(
                                                Icons.warning_amber_rounded,
                                                color: Colors.orange,
                                                size: 80),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'Advertencia!',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              result,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 51, 122, 183),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)),
                          child: const Text(
                            'Escanear codigo QR',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const FooterView(),
                ],
              ),
            )),
          );
        }
      },
    ));
  }
}
