import 'package:flutter/material.dart';
import 'package:purpleshop/data/cart_data.dart';
import 'package:purpleshop/pages/profile/profile_detail_pages.dart';
import 'package:purpleshop/pages/profile/wishlist_page.dart';
import 'package:purpleshop/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dialog Edit Profil
  void _showEditProfileDialog() {
    TextEditingController nameController =
    TextEditingController(text: userProfile['name']);
    TextEditingController emailController =
    TextEditingController(text: userProfile['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
            onPressed: () {
              setState(() {
                userProfile['name'] = nameController.text;
                userProfile['email'] = emailController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Dialog Logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Akun'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil keluar dari akun')),
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggabungkan SEMUA pesanan untuk menu "Pesanan Saya"
    List<Map<String, dynamic>> allOrders = [
      ...globalUnpaidOrders,
      ...globalPackedOrders,
      ...globalShippedOrders,
      ...globalReviewOrders,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER PROFIL
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF8B5CF6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(
                  bottom: 24, left: 16, right: 16, top: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showEditProfileDialog,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: Color(0xFFDDD6FE),
                            child: Icon(Icons.person,
                                size: 50, color: Color(0xFF8B5CF6)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 16, color: Color(0xFF8B5CF6)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userProfile['name'] ?? 'Pengguna',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile['email'] ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. KARTU STATISTIK DENGAN COUNTER REALTIME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Belum Bayar', Icons.payment_outlined,
                        globalUnpaidOrders.length),
                    _buildStatItem('Dikemas', Icons.inventory_2_outlined,
                        globalPackedOrders.length),
                    _buildStatItem('Dikirim', Icons.local_shipping_outlined,
                        globalShippedOrders.length),
                    _buildStatItem('Beri Ulasan', Icons.star_border_rounded,
                        globalReviewOrders.length),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. MENU OPSI LENGKAP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // --- PESANAN SAYA (DIPERBAIKI) ---
                    _buildMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Pesanan Saya',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderListDetailPage(
                              statusTitle: 'Semua Pesanan',
                              orderList: allOrders, // <-- SUDAH DIBETULKAN
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      },
                    ),
                    _buildDivider(),

                    // --- MENU WISHLIST ---
                    ListTile(
                      leading: const Icon(Icons.favorite,
                          color: Color(0xFF8B5CF6)),
                      title: const Text(
                        'Wishlist Saya',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (globalWishlist.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${globalWishlist.length}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WishlistPage()),
                        ).then((_) => setState(() {}));
                      },
                    ),

                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.confirmation_number_outlined,
                      title: 'Voucher Saya',
                      trailingText: '${globalVouchers.length} Voucher Baru',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VoucherPage()),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat Pengiriman',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. TOMBOL LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showLogoutDialog,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget Status dengan Badge Angka
  Widget _buildStatItem(String label, IconData icon, int count) {
    List<Map<String, dynamic>> targetList = [];
    if (label == 'Belum Bayar') targetList = globalUnpaidOrders;
    if (label == 'Dikemas') targetList = globalPackedOrders;
    if (label == 'Dikirim') targetList = globalShippedOrders;
    if (label == 'Beri Ulasan') targetList = globalReviewOrders;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderListDetailPage(
              statusTitle: label,
              orderList: targetList,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      child: Column(
        children: [
          Badge(
            label: Text('$count'),
            isLabelVisible: count > 0,
            backgroundColor: const Color(0xFF8B5CF6),
            child: Icon(icon, color: const Color(0xFF8B5CF6), size: 26),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B5CF6)),
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText,
                style:
                const TextStyle(color: Colors.deepOrange, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
        height: 1, indent: 16, endIndent: 16, color: Color(0xFFF1F5F9));
  }
}