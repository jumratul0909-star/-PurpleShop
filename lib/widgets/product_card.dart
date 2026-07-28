import 'package:flutter/material.dart';
import 'package:purpleshop/data/cart_data.dart'; // Sesuaikan lokasi cart_data.dart Anda

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // Cek apakah produk ini sudah ada di globalWishlist
  bool get _isWishlisted {
    return globalWishlist.any((item) => item['name'] == widget.name);
  }

  void _toggleWishlist() {
    setState(() {
      if (_isWishlisted) {
        // Hapus dari wishlist
        globalWishlist.removeWhere((item) => item['name'] == widget.name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.name} dihapus dari Wishlist'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Tambah ke wishlist
        globalWishlist.add({
          'name': widget.name,
          'price': widget.price,
          'imageUrl': widget.imageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.name} ditambahkan ke Wishlist ❤️'),
            duration: const Duration(seconds: 1),
            backgroundColor: const Color(0xFF8B5CF6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              Expanded(
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    widget.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Detail Teks (Nama & Harga)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --- TOMBOL FAVOURITE (WISHLIST) ---
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _toggleWishlist,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _isWishlisted ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: _isWishlisted ? Colors.red : Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}