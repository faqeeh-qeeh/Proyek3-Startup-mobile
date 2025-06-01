// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/products/product_list_screen.dart';
// import 'screens/orders/order_list_screen.dart';
// import 'screens/devices/device_list_screen.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AuthProvider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const ProductListScreen(),
//     const OrderListScreen(),
//     const DeviceListScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mocid',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: FutureBuilder(
//         future: Provider.of<AuthProvider>(context, listen: false).loadUser(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }
          
//           final auth = Provider.of<AuthProvider>(context);
          
//           return auth.token != null
//               ? Scaffold(
//                   body: IndexedStack(
//                     index: _currentIndex,
//                     children: _screens,
//                   ),
//                   bottomNavigationBar: BottomNavigationBar(
//                     currentIndex: _currentIndex,
//                     onTap: (index) => setState(() => _currentIndex = index),
//                     items: const [
//                       BottomNavigationBarItem(
//                         icon: Icon(Icons.shopping_bag),
//                         label: 'Products',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(Icons.list_alt),
//                         label: 'Orders',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(Icons.devices), // Icon untuk devices
//                         label: 'Devices',
//                       ),
//                     ],
//                     selectedItemColor: Colors.blue,
//                     unselectedItemColor: Colors.grey,
//                     showUnselectedLabels: true,
//                   ),
//                 )
//               : const LoginScreen();
//         },
//       ),
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/products': (context) => const ProductListScreen(),
//         '/orders': (context) => const OrderListScreen(),
//         '/devices': (context) => const DeviceListScreen(), // Tambahkan route
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/products/product_list_screen.dart';
// import 'screens/orders/order_list_screen.dart';
// import 'screens/devices/device_list_screen.dart';
// import 'screens/profile/profile_screen.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => AuthProvider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const ProductListScreen(),
//     const OrderListScreen(),
//     const DeviceListScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mocid',
//       theme: ThemeData(
//         primaryColor: const Color(0xFF041562),
//         colorScheme: const ColorScheme.light(
//           primary: Color(0xFF041562),
//           secondary: Color(0xFFDA1212),
//           surface: Colors.white,
//           background: Color(0xFFEEEEEE),
//         ),
//         scaffoldBackgroundColor: const Color(0xFFEEEEEE),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xFF041562),
//           elevation: 4,
//           centerTitle: true,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//         ),
//         cardTheme: CardTheme(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.all(8),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),
//         buttonTheme: ButtonThemeData(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           buttonColor: const Color(0xFF041562),
//         ),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: FutureBuilder(
//         future: Provider.of<AuthProvider>(context, listen: false).loadUser(),
//         builder: (context, snapshot) {
//           final auth = Provider.of<AuthProvider>(context);
          
//           return auth.token != null
//               ? Scaffold(
//                   body: IndexedStack(
//                     index: _currentIndex,
//                     children: _screens,
//                   ),
//                   bottomNavigationBar: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                       child: BottomNavigationBar(
//                         type: BottomNavigationBarType.fixed,
//                         currentIndex: _currentIndex,
//                         onTap: (index) => setState(() => _currentIndex = index),
//                         backgroundColor: Colors.white,
//                         selectedItemColor: const Color(0xFF041562),
//                         unselectedItemColor: const Color(0xFF11468F).withOpacity(0.6),
//                         selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                         items: [
//                           BottomNavigationBarItem(
//                             icon: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: _currentIndex == 0 
//                                     ? const Color(0xFF041562).withOpacity(0.1) 
//                                     : Colors.transparent,
//                               ),
//                               child: const Icon(Icons.shopping_bag),
//                             ),
//                             label: 'Products',
//                           ),
//                           BottomNavigationBarItem(
//                             icon: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: _currentIndex == 1 
//                                     ? const Color(0xFF041562).withOpacity(0.1) 
//                                     : Colors.transparent,
//                               ),
//                               child: const Icon(Icons.list_alt),
//                             ),
//                             label: 'Orders',
//                           ),
//                           BottomNavigationBarItem(
//                             icon: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: _currentIndex == 2 
//                                     ? const Color(0xFF041562).withOpacity(0.1) 
//                                     : Colors.transparent,
//                               ),
//                               child: const Icon(Icons.devices),
//                             ),
//                             label: 'Devices',
//                           ),
//                           BottomNavigationBarItem(
//                             icon: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: _currentIndex == 3 
//                                     ? const Color(0xFF041562).withOpacity(0.1) 
//                                     : Colors.transparent,
//                               ),
//                               child: const Icon(Icons.person),
//                             ),
//                             label: 'Profile',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               : const LoginScreen();
//         },
//       ),
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/products': (context) => const ProductListScreen(),
//         '/orders': (context) => const OrderListScreen(),
//         '/devices': (context) => const DeviceListScreen(),
//         '/profile': (context) => const ProfileScreen(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/products/product_list_screen.dart';
import 'screens/orders/order_list_screen.dart';
import 'screens/devices/device_list_screen.dart';
import 'screens/profile/profile_screen.dart';

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

  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const ProductListScreen(),
    const OrderListScreen(),
    const DeviceListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mocid',
      theme: ThemeData(
        primaryColor: const Color(0xFF041562),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF041562),
          secondary: Color(0xFFDA1212),
          surface: Colors.white,
          background: Color(0xFFEEEEEE),
        ),
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF041562),
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          buttonColor: const Color(0xFF041562),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false).loadUser(),
        builder: (context, snapshot) {
          final auth = Provider.of<AuthProvider>(context);
          
          return auth.token != null
              ? Scaffold(
                  body: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: _screens,
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: _currentIndex,
                        onTap: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        backgroundColor: Colors.white,
                        selectedItemColor: const Color(0xFF041562),
                        unselectedItemColor: const Color(0xFF11468F).withOpacity(0.6),
                        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        items: [
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _currentIndex == 0 
                                    ? const Color(0xFF041562).withOpacity(0.1) 
                                    : Colors.transparent,
                              ),
                              child: const Icon(Icons.shopping_bag),
                            ),
                            label: 'Products',
                          ),
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _currentIndex == 1 
                                    ? const Color(0xFF041562).withOpacity(0.1) 
                                    : Colors.transparent,
                              ),
                              child: const Icon(Icons.list_alt),
                            ),
                            label: 'Orders',
                          ),
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _currentIndex == 2 
                                    ? const Color(0xFF041562).withOpacity(0.1) 
                                    : Colors.transparent,
                              ),
                              child: const Icon(Icons.devices),
                            ),
                            label: 'Devices',
                          ),
                          BottomNavigationBarItem(
                            icon: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _currentIndex == 3 
                                    ? const Color(0xFF041562).withOpacity(0.1) 
                                    : Colors.transparent,
                              ),
                              child: const Icon(Icons.person),
                            ),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/products': (context) => const ProductListScreen(),
        '/orders': (context) => const OrderListScreen(),
        '/devices': (context) => const DeviceListScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}