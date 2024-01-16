import 'package:control_acceso_emlaze/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) { 
        final pageIndex = state.pathParameters['page'] ?? '0';
        return HomeScreen(pageIndex: int.parse(pageIndex) ,);
      },
      routes: [
        
      ]),
  GoRoute(
    path: '/',
    redirect: ( _ , __) {
      return '/home/0';
    }
  )
]);
