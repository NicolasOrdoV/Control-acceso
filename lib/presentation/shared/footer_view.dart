import 'package:control_acceso_emlaze/presentation/screens.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
              'Software Emlaze ERP. Todos los derechos reservados, Prohibida su reproducción total o parcial de los contenidos y base de datos. Al ingresar al sistema estara aprobando Terminos y condiciones y Politica de Proteccion y Tratamiento de Datos Personales de www.emlaze.com',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.justify),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                const url =
                    "https://www.facebook.com/EmlazeSystems/?locale=es_LA";
                await launchUrl(Uri.parse(url));
              },
              icon: const Icon(Icons.facebook_rounded),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                iconColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 51, 122, 183)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () async {
                const url = "https://twitter.com/EMLAZE";
                await launchUrl(Uri.parse(url));
              },
              icon: const FaIcon(FontAwesomeIcons.twitter),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                iconColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 51, 122, 183)),
              ),
            )
          ],
        )
      ],
    );
  }
}
