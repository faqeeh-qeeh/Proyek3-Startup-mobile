import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/products/product_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Client App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false).loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final authProvider = Provider.of<AuthProvider>(context);
            return authProvider.token != null
                ? ProductListScreen()
                : LoginScreen();
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/products': (context) => ProductListScreen(),
      },
    );
  }
}