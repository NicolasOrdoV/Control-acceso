import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AccessScreen extends StatefulWidget {

  static const name = 'access-screen';
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¡Bienvenido!'),
            content: const Text('Gracias por usar nuestra aplicación.'),
            actions: [
              // Botón de cerrar
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de acceso EMLAZE ERP'),
        backgroundColor: const Color.fromARGB(255, 51, 122, 183),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            onPressed: () {
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
                        onPressed: () {},
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