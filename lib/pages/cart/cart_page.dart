import 'package:flutter/material.dart';
import 'package:purpleshop/data/cart_data.dart';
import 'package:purpleshop/pages/profile/profile_detail_pages.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Helper untuk membersihkan format string harga ke angka (misal: "Rp 1.250.000" -> 1250000)
  int _parsePrice(String priceStr) {
    String cleanStr = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }

  // Menghitung total harga seluruh belanjaan
  int _calculateTotal() {
    int total = 0;
    for (var item in globalCartItems) {
      int price = _parsePrice(item['price'].toString());
      int qty = int.tryParse(item['quantity'].toString()) ?? 1;
      total += price * qty;
    }
    return total;
  }

  // Format angka ke Rupiah
  String _formatRupiah(int number) {
    return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Keranjang Saya'),
        backgroundColor: const Color(0xFF8B5CF6),
        elevation: 0,
      ),
      body: globalCartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Keranjang Belanja Masih Kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Yuk, pilih sepatu favoritmu terlebih dahulu!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // LIST ITEM KERANJANG
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: globalCartItems.length,
              itemBuilder: (context, index) {
                final item = globalCartItems[index];
                int quantity =
                    int.tryParse(item['quantity'].toString()) ?? 1;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Gambar Produk
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['imageUrl'].toString(),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image,
                                    color: Colors.grey),
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Info Nama & Harga
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['price'].toString(),
                              style: const TextStyle(
                                color: Color(0xFF8B5CF6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tombol Tambah/Kurang Qty & Hapus
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                size: 22, color: Colors.purple),
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  globalCartItems[index]['quantity'] =
                                      quantity - 1;
                                } else {
                                  globalCartItems.removeAt(index);
                                }
                              });
                            },
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                size: 22, color: Colors.purple),
                            onPressed: () {
                              setState(() {
                                globalCartItems[index]['quantity'] =
                                    quantity + 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // SUMMARY & BOTTOM CHECKOUT BAR
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style:
                        TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        _formatRupiah(_calculateTotal()),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (globalCartItems.isNotEmpty) {
                        int itemCount = globalCartItems.length;

                        setState(() {
                          // 1. Simpan item dari keranjang ke daftar pesanan Dikemas & Riwayat Utama
                          for (var item in globalCartItems) {
                            var itemCopy = {
                              'name': item['name'],
                              'price': item['price'],
                              'imageUrl': item['imageUrl'],
                              'quantity': item['quantity'] ?? 1,
                              'status': 'Dikemas',
                              'date': DateTime.now()
                                  .toString()
                                  .split(' ')[0],
                            };

                            globalPackedOrders.add(itemCopy);
                            globalOrderItems.add(itemCopy);
                          }

                          // 2. Tambahkan Notifikasi Otomatis ke tab Notifikasi
                          globalNotifications.insert(0, {
                            'title': 'Pesanan Diproses! 📦',
                            'message':
                            '$itemCount jenis produk berhasil dicheckout dan sedang dikemas.',
                            'time': 'Baru saja',
                            'isRead': false,
                            'icon': Icons.inventory_2_outlined,
                          });

                          // 3. Kosongkan keranjang belanja
                          globalCartItems.clear();
                        });

                        // 4. Notifikasi Toast / SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Checkout Berhasil! Pesanan sedang dikemas.'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // 5. Buka Halaman Detail Pesanan Dikemas
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderListDetailPage(
                              statusTitle: 'Dikemas',
                              orderList: globalPackedOrders,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}