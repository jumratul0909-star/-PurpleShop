import 'package:flutter/material.dart';

class AlamatPengirimanScreen extends StatefulWidget {
  const AlamatPengirimanScreen({super.key});

  @override
  State<AlamatPengirimanScreen> createState() => _AlamatPengirimanScreenState();
}

class _AlamatPengirimanScreenState extends State<AlamatPengirimanScreen> {
  // Variable data alamat yang dapat diubah
  String labelAlamat = "Alamat Utama (Rumah)";
  String jalan = "Jl. Sudirman No. 123";
  String kotaDanKodePos = "Jakarta Selatan, 12190";
  String nomorTelepon = "+62 812-3456-7890";

  // Fungsi Pop-Up Dialog untuk Edit Alamat
  void _showEditDialog() {
    TextEditingController labelController = TextEditingController(text: labelAlamat);
    TextEditingController jalanController = TextEditingController(text: jalan);
    TextEditingController kotaController = TextEditingController(text: kotaDanKodePos);
    TextEditingController teleponController = TextEditingController(text: nomorTelepon);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Edit Alamat Pengiriman",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: labelController,
                  decoration: const InputDecoration(
                    labelText: "Label Alamat",
                    hintText: "Contoh: Rumah / Kantor",
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: jalanController,
                  decoration: const InputDecoration(
                    labelText: "Jalan / No. Rumah",
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: kotaController,
                  decoration: const InputDecoration(
                    labelText: "Kota & Kode Pos",
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: teleponController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Nomor Telepon",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B3293), // Warna menyesuaikan tema
              ),
              onPressed: () {
                setState(() {
                  labelAlamat = labelController.text;
                  jalan = jalanController.text;
                  kotaDanKodePos = kotaController.text;
                  nomorTelepon = teleponController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B3293), // Warna ungu sesuai gambar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        title: const Text(
          "Alamat Pengiriman",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kartu Alamat Pengiriman
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFDCDCDC),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Lokasi Ungu
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xFF7B3293),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Informasi Alamat
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labelAlamat,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          jalan,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          kotaDanKodePos,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        Text(
                          "($nomorTelepon)",
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Pensil Edit
                  GestureDetector(
                    onTap: _showEditDialog,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black54,
                        size: 20,
                      ),
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
}