import 'package:flutter/material.dart';
import 'package:purpleshop/data/cart_data.dart';

// 1. Halaman Status Pesanan (Dinamis sesuai Tab)
class OrderListDetailPage extends StatelessWidget {
  final String statusTitle;
  final List<Map<String, dynamic>> orderList;

  const OrderListDetailPage({
    super.key,
    required this.statusTitle,
    required this.orderList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(statusTitle),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: orderList.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 70, color: Colors.grey),
            const SizedBox(height: 12),
            Text('Tidak ada pesanan di $statusTitle',
                style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          final item = orderList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Image.asset(item['imageUrl'], width: 50, fit: BoxFit.cover),
              title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${item['quantity']}x • Rp ${item['price']}'),
              trailing: Chip(
                label: Text(statusTitle, style: const TextStyle(color: Colors.white, fontSize: 11)),
                backgroundColor: const Color(0xFF8B5CF6),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 2. Halaman Voucher
class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Saya'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalVouchers.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFFF3E8FF),
            child: ListTile(
              leading: const Icon(Icons.confirmation_number, color: Color(0xFF8B5CF6), size: 36),
              title: Text(globalVouchers[index], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Berlaku sampai 31 Des 2026'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                onPressed: () {},
                child: const Text('Pakai', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 3. Halaman Alamat Pengiriman
class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Pengiriman'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Color(0xFF8B5CF6), size: 32),
            title: const Text('Alamat Utama (Rumah)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Jl. Sudirman No. 123, Jakarta Selatan, 12190\n(+62 812-3456-7890)'),
            isThreeLine: true,
            trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ),
        ),
      ),
    );
  }
}