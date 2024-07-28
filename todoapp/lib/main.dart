import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todolist/utils/routes/routes.dart';
import 'package:todolist/utils/shared_preferance/token_storage.dart';
import 'package:todolist/viewModel/auth_view_model.dart';
import 'package:todolist/views/login_page.dart';
import 'package:todolist/views/register_page.dart';
import 'package:todolist/utils/theme/app_pallete.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final HttpLink httpLink = HttpLink(
    "${dotenv.env['API_BASE_URL']}/graphql" ?? "",
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => await TokenStorage.getBearerToken(),
  );

  final Link link = authLink.concat(httpLink);

  final GraphQLClient client = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
  );
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;

  MyApp({required this.client});
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     initialRoute: '/',
  //     theme: ThemeData(
  //         // scaffoldBackgroundColor: AppPallete.backgroundColor,
  //         useMaterial3: true,
  //         inputDecorationTheme: InputDecorationTheme(
  //           filled: true,
  //           fillColor: Colors.white,
  //           hintStyle: TextStyle(color: AppPallete.secondaryColor),
  //           contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //             borderSide: BorderSide.none,
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //             borderSide: BorderSide.none,
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //             borderSide: BorderSide.none,
  //           ),
  //           errorBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //             borderSide: BorderSide(color: Colors.red, width: 1),
  //           ),
  //           focusedErrorBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10.0),
  //             borderSide: BorderSide(color: Colors.red, width: 1),
  //           ),
  //           labelStyle: TextStyle(color: Colors.black),
  //           errorStyle: TextStyle(color: Colors.red, fontSize: 14),
  //         ),
  //         textTheme:
  //             GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.light).textTheme),
  //         colorScheme: ColorScheme.fromSwatch(backgroundColor: Color(0xfff5f9fd))),
  //     routes: {
  //       '/': (context) => RegisterPage(),
  //       '/login': (context) => LoginPage(),
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _getUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final bool isLoggedIn = snapshot.data ?? false;
          return GraphQLProvider(
            client: ValueNotifier<GraphQLClient>(client),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AuthViewModel()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                    // scaffoldBackgroundColor: AppPallete.backgroundColor,
                    useMaterial3: true,
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(color: AppPallete.secondaryColor),
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      errorStyle: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    textTheme: GoogleFonts.poppinsTextTheme(
                        ThemeData(brightness: Brightness.light).textTheme),
                    colorScheme: ColorScheme.fromSwatch(backgroundColor: Color(0xfff5f9fd))),
                initialRoute: isLoggedIn ? Routes.homeScreen : Routes.loginScreen,
                onGenerateRoute: Routes.controller,
              ),
            ),
          );
        }
      },
    );
  }

  static Future<bool> _getUserStatus() async {
    bool isSignedIn = await TokenStorage.tokenExists();
    return isSignedIn;
  }
}
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
