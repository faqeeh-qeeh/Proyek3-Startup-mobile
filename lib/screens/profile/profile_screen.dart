// // lib/screens/profile/profile_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../api/auth_service.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _isLoading = false;

//   Future<void> _logout() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
    
//     try {
//       await AuthService.logout();
//       await Provider.of<AuthProvider>(context, listen: false).logout();
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, '/login');
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logout failed: ${e.toString()}')),
//       );
//     } finally {
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _logout();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoTile(String title, String value, IconData icon) {
//     return Card(
//       child: ListTile(
//         leading: Icon(icon, color: Colors.blue),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//         subtitle: Text(
//           value,
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Consumer<AuthProvider>(
//         builder: (context, auth, child) {
//           final client = auth.client;
          
//           if (client == null) {
//             return const Center(child: Text('No user data available'));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // Profile Header
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.blue.shade100,
//                           child: Text(
//                             client.fullName.isNotEmpty 
//                                 ? client.fullName[0].toUpperCase()
//                                 : 'U',
//                             style: const TextStyle(
//                               fontSize: 36,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           client.fullName,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '@${client.username}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 // Profile Information
//                 _buildInfoTile('Email', client.email, Icons.email),
//                 _buildInfoTile('WhatsApp', client.whatsappNumber, Icons.phone),
//                 _buildInfoTile('Gender', client.gender, Icons.person),
//                 _buildInfoTile('Address', client.address, Icons.location_on),
//                 _buildInfoTile('Birth Date', client.birthDate, Icons.cake),
                
//                 const SizedBox(height: 30),
                
//                 // Logout Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: _isLoading ? null : _showLogoutDialog,
//                     icon: _isLoading 
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         : const Icon(Icons.logout),
//                     label: Text(_isLoading ? 'Logging out...' : 'Logout'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../api/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  Future<void> _logout() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      await AuthService.logout();
      await Provider.of<AuthProvider>(context, listen: false).logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: ${e.toString()}'),
          backgroundColor: Color(0xFFDA1212),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Keluar Akun',
          style: TextStyle(
            color: Color(0xFF041562),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Color(0xFF11468F)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDA1212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Keluar', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF041562).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Color(0xFF041562),
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF041562),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final client = auth.client;
          
          if (client == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Color(0xFFDA1212),
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Data pengguna tidak tersedia',
                    style: TextStyle(
                      color: Color(0xFF041562),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF041562).withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xFFEEEEEE),
                            child: Text(
                              client.fullName.isNotEmpty 
                                  ? client.fullName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF041562),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          client.fullName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF041562),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${client.username}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF11468F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Profile Information
                _buildInfoTile('Email', client.email, Icons.email),
                _buildInfoTile('Nomor WhatsApp', client.whatsappNumber, Icons.phone),
                _buildInfoTile('Jenis Kelamin', client.gender, Icons.person),
                _buildInfoTile('Alamat', client.address, Icons.location_on),
                _buildInfoTile('Tanggal Lahir', client.birthDate, Icons.cake),
                
                const SizedBox(height: 30),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _showLogoutDialog,
                    icon: _isLoading 
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.logout),
                    label: Text(_isLoading ? 'Sedang keluar...' : 'Keluar Akun'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDA1212),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}