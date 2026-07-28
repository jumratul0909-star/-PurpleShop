import 'package:flutter/material.dart';

// ==========================================
// 1. DATA PROFIL USER
// ==========================================
Map<String, String> userProfile = {
  'name': 'PurpleShop Member',
  'email': 'member@purpleshop.com',
};

// ==========================================
// 2. DATA NOTIFIKASI (DINAMIS & REAL-TIME)
// ==========================================
/// List notifikasi dimulai dari kosong atau siap menerima data real-time
List<Map<String, dynamic>> globalNotifications = [];

/// Fungsi Helper untuk menambahkan notifikasi baru secara dinamis
void addNotification({
  required String title,
  required String message,
  required IconData icon,
}) {
  globalNotifications.insert(0, {
    'id': DateTime.now().millisecondsSinceEpoch.toString(),
    'title': title,
    'message': message,
    'timestamp': DateTime.now(), // Menyimpan waktu pembuatan aktual
    'isRead': false,
    'icon': icon,
  });
}

/// Helper untuk format waktu relatif yang selalu update (cth: "Baru saja", "10 menit yang lalu")
String getFormattedNotificationTime(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inSeconds < 60) {
    return 'Baru saja';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} menit yang lalu';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} jam yang lalu';
  } else if (difference.inDays == 1) {
    return 'Kemarin';
  } else {
    return '${difference.inDays} hari yang lalu';
  }
}

// ==========================================
// 3. DAFTAR KERANJANG BELANJA (GLOBAL CART)
// ==========================================
List<Map<String, dynamic>> globalCartItems = [];
List<Map<String, dynamic>> get cartItems => globalCartItems;

// ==========================================
// 4. STATUS PESANAN (ORDER MANAGEMENT)
// ==========================================
List<Map<String, dynamic>> globalUnpaidOrders = [];
List<Map<String, dynamic>> globalPackedOrders = [];
List<Map<String, dynamic>> globalShippedOrders = [];
List<Map<String, dynamic>> globalReviewOrders = [];
List<Map<String, dynamic>> globalOrderItems = [];

List<Map<String, dynamic>> get globalOrders => globalShippedOrders;

// ==========================================
// 5. DATA WISHLIST & VOUCHER
// ==========================================
List<Map<String, dynamic>> globalWishlist = [];
List<String> globalVouchers = [
  'Diskon 20% Pengguna Baru',
  'Gratis Ongkir Rp 20.000',
];

// ==========================================
// 6. FUNGSI UTAMA (LOGIKA BISNIS)
// ==========================================

/// Fungsi Universal `addToCart`
void addToCart(dynamic productOrName, [String? priceString, String? imageUrl]) {
  String name;
  String price;
  String image;
  int addQty = 1;

  if (productOrName is Map) {
    name = productOrName['name']?.toString() ?? '';
    price = productOrName['price']?.toString() ?? 'Rp 0';
    image = productOrName['imageUrl']?.toString() ?? '';
    addQty = (productOrName['quantity'] is int) ? productOrName['quantity'] as int : 1;
  } else {
    name = productOrName.toString();
    price = priceString ?? 'Rp 0';
    image = imageUrl ?? '';
  }

  int index = globalCartItems.indexWhere((item) => item['name'] == name);

  if (index != -1) {
    int currentQty = globalCartItems[index]['quantity'] as int? ?? 1;
    globalCartItems[index]['quantity'] = currentQty + addQty;
  } else {
    globalCartItems.add({
      'name': name,
      'price': price,
      'quantity': addQty,
      'imageUrl': image,
    });
  }
}

/// Memproses checkout & OTOMATIS membuat notifikasi update
void processCheckout() {
  if (globalCartItems.isNotEmpty) {
    String todayDate = DateTime.now().toString().split(' ')[0];
    int totalItems = 0;

    for (var item in globalCartItems) {
      var itemCopy = Map<String, dynamic>.from(item);
      itemCopy['status'] = 'Dikemas';
      itemCopy['date'] = todayDate;

      globalPackedOrders.add(itemCopy);
      globalOrderItems.add(itemCopy);

      totalItems += (item['quantity'] as int? ?? 1);
    }

    // 🔔 SECARA OTOMATIS MEMBUAT NOTIFIKASI REAL-TIME SAAT CHECKOUT
    addNotification(
      title: 'Pesanan Berhasil Dibuat! 📦',
      message: 'Sebanyak $totalItems barang sedang diproses dan dikemas oleh penjual.',
      icon: Icons.inventory_2_outlined,
    );

    // Mengosongkan keranjang setelah checkout
    globalCartItems.clear();
  }
}