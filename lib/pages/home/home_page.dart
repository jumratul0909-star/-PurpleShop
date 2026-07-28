import 'package:flutter/material.dart';
import 'package:purpleshop/data/cart_data.dart';
import 'package:purpleshop/widgets/product_card.dart';
import 'package:purpleshop/pages/product/detail_product_page.dart';
import 'package:purpleshop/pages/cart/cart_page.dart';

// Class Utama HomePage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeContent();
  }
}

// Class HomeContent
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Daftar Produk Lengkap
  final List<Map<String, String>> _allProducts = [
    {
      'name': 'Nike Air Max 270',
      'price': 'Rp 1.250.000',
      'category': 'Nike',
      'imageUrl': 'assets/images/products/nike_air_max.jpg',
    },
    {
      'name': 'Adidas Samba',
      'price': 'Rp 1.850.000',
      'category': 'Adidas',
      'imageUrl': 'assets/images/products/adidas_samba.jpg',
    },
    {
      'name': 'Air Jordan',
      'price': 'Rp 2.000.000',
      'category': 'Nike',
      'imageUrl': 'assets/images/products/air_jordan.jpg',
    },
    {
      'name': 'Taylor Sneaker',
      'price': 'Rp 1.500.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/taylor_sneaker.jpg',
    },
    {
      'name': 'Unisex',
      'price': 'Rp 3.500.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/unisex.jpg',
    },
    {
      'name': 'Dunk Low',
      'price': 'Rp 2.300.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/dunk_low.webp',
    },
    {
      'name': 'Hoka Skyward',
      'price': 'Rp 2.000.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/Hoka_Skyward.webp',
    },
    {
      'name': 'Women Ultraadidas',
      'price': 'Rp 3.100.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/img.jpg',
    },
    {
      'name': 'New Balance 574',
      'price': 'Rp 2.800.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/New_Balance_574.jpg',
    },
    {
      'name': 'Puma',
      'price': 'Rp 4.000.000',
      'category': 'Casual',
      'imageUrl': 'assets/images/products/puma.jpg',
    },
  ];

  final List<String> _categories = [
    'Semua',
    'Nike',
    'Adidas',
    'Casual'
  ];

  String _selectedCategory = 'Semua';
  List<Map<String, String>> _foundProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foundProducts = _allProducts;
  }

  void _filterProducts() {
    String keyword = _searchController.text.toLowerCase();
    List<Map<String, String>> results = _allProducts.where((product) {
      bool matchesSearch = product['name']!.toLowerCase().contains(keyword);
      bool matchesCategory = _selectedCategory == 'Semua' ||
          product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    setState(() {
      _foundProducts = results;
    });
  }

  // Fungsi Navigasi ke Detail Product dengan Named Parameters
  void _onProductTap(
      BuildContext context, String productName, String price, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProductPage(
          productMap: {'name': productName},
          price: price,
          imageUrl: imageUrl,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    int cartCount =
    globalCartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5CF6),
        elevation: 0,
        toolbarHeight: 80,
        title: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => _filterProducts(),
            decoration: const InputDecoration(
              hintText: 'Cari sepatu idamanmu...',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Color(0xFF8B5CF6)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  ).then((_) => setState(() {}));
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // CATEGORY CHIPS
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: const Color(0xFF8B5CF6),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category;
                            _filterProducts();
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // GRID PRODUK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _foundProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = _foundProducts[index];
                  return GestureDetector(
                    onTap: () => _onProductTap(
                      context,
                      item['name']!,
                      item['price']!,
                      item['imageUrl']!,
                    ),
                    child: ProductCard(
                      name: item['name']!,
                      price: item['price']!,
                      imageUrl: item['imageUrl']!,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}