import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/products/product_list_screen.dart';
import 'screens/orders/order_list_screen.dart';
import 'screens/devices/device_list_screen.dart'; // Import baru

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProductListScreen(),
    const OrderListScreen(),
    const DeviceListScreen(), // Tambahkan DeviceListScreen
  ];

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          final auth = Provider.of<AuthProvider>(context);
          
          return auth.token != null
              ? Scaffold(
                  body: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_bag),
                        label: 'Products',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt),
                        label: 'Orders',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.devices), // Icon untuk devices
                        label: 'Devices',
                      ),
                    ],
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    showUnselectedLabels: true,
                  ),
                )
              : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/products': (context) => const ProductListScreen(),
        '/orders': (context) => const OrderListScreen(),
        '/devices': (context) => const DeviceListScreen(), // Tambahkan route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}