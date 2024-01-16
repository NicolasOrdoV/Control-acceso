import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const name = "home-screen";
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _scanBarcode = 'Unknown';
  
  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("Aqui esta la respuesta " + barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 260,
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
                      const Text('Control de acceso', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      const Text('EMLAZE ERP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                      const SizedBox(height: 15,),
                      ElevatedButton(
                        onPressed: () => scanQR(),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 51, 122, 183),
                          padding: const EdgeInsets.symmetric(horizontal: 30)
                        ), 
                        child: const Text('Escanear codigo QR', style: TextStyle(color: Colors.white),),
                        
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
      )
    );
  }
}
