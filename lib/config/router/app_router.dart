import 'package:control_acceso_emlaze/presentation/screens/access_screen.dart';
import 'package:control_acceso_emlaze/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  
  GoRoute(
      path: '/home/0',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(pageIndex: 0,),
  ),
  GoRoute(
    path: '/access-screen',
    name: AccessScreen.name,
    builder: (context, state) => const AccessScreen(),
  ),
  // GoRoute(
  //   path: '/',
  //   redirect: ( _ , __) {
  //     return '/home/0';
  //   }
  // )
]);
