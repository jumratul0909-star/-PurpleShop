import 'package:flutter/material.dart';
import 'package:purpleshop/data/cart_data.dart';
import 'package:purpleshop/models/product.dart';

class DetailProductPage extends StatefulWidget {
  final Product? product;
  final Map<String, dynamic>? productMap;
  final String? productName;
  final String? price;
  final String? image;
  final String? imageUrl; // 👈 Ditambahkan untuk mendukung pemanggilan dari home_page.dart
  final String? description;

  const DetailProductPage({
    super.key,
    this.product,
    this.productMap,
    this.productName,
    this.price,
    this.image,
    this.imageUrl,
    this.description,
  });

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  int quantity = 1;
  String selectedSize = 'EU 42';

  @override
  void initState() {
    super.initState();
    if (widget.product != null && widget.product!.sizes.isNotEmpty) {
      selectedSize = widget.product!.sizes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ambil Nama Produk
    final String name = widget.productName ??
        widget.product?.name ??
        widget.productMap?['name'] ??
        'Air Jordan';

    // 2. Ambil Harga Produk
    final String price = widget.price ??
        (widget.product != null ? 'Rp ${widget.product!.price}' : null) ??
        (widget.productMap?['price'] ?? 'Rp 2.000.000');

    // 3. Ambil Gambar Produk (mencakup imageUrl & image)
    final String imagePath = widget.imageUrl ??
        widget.image ??
        widget.product?.image ??
        widget.productMap?['imageUrl'] ??
        widget.productMap?['image'] ??
        'assets/images/products/air_jordan.jpg';

    // 4. Ambil Deskripsi Produk
    final String description = widget.description ??
        widget.product?.description ??
        widget.productMap?['description'] ??
        'Desain high-top klasik dengan kombinasi warna memberikan kesan sporty sekaligus premium.';

    // 5. Ambil Rating Produk
    final double rating = widget.product?.rating ??
        (widget.productMap?['rating'] as double?) ??
        4.8;

    // 6. Ambil Daftar Ukuran (Sizes)
    final List<String> sizes = widget.product?.sizes ??
        (widget.productMap?['sizes'] as List<String>?) ??
        ['EU 40', 'EU 41', 'EU 42', 'EU 43', 'EU 44'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF8B5CF6),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- GAMBAR PRODUK ---
                  Container(
                    width: double.infinity,
                    height: 280,
                    color: Colors.grey.shade200,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- NAMA, HARGA & RATING ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Komponen Rate
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Rate',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                        (index) => Icon(
                                      Icons.star_rounded,
                                      size: 18,
                                      color: index < rating.floor()
                                          ? Colors.amber
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$rating (1,234 ulasan)',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // --- PILIHAN UKURAN (SIZE) ---
                        const Text(
                          'Ukuran (Size)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sizes.length,
                            itemBuilder: (context, index) {
                              final size = sizes[index];
                              final isSelected = selectedSize == size;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF8B5CF6).withOpacity(0.1)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF8B5CF6)
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? const Color(0xFF8B5CF6)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // --- JUMLAH / QUANTITY ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jumlah',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                      }
                                    },
                                  ),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: () {
                                      setState(() => quantity++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // --- DESKRIPSI ---
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- TOMBOL MASUKKAN KERANJANG ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  addToCart({
                    'name': '$name ($selectedSize)',
                    'price': price,
                    'imageUrl': imagePath,
                    'quantity': quantity,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name ($selectedSize) ditambahkan ke keranjang!'),
                      backgroundColor: const Color(0xFF8B5CF6),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                label: const Text(
                  'Masukkan Keranjang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}