import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  // Inisialisasi Supabase client
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk inputan
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  // List untuk menyimpan data produk dari Supabase
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> cart = [];
  int? editingProdukId; // Menyimpan ID produk yang sedang diedit

  @override
  void initState() {
    super.initState();
    fetchProduk(); // Ambil data produk saat halaman dimuat
  }

  // Fungsi untuk mengambil data produk dari Supabase
  Future<void> fetchProduk() async {
    final response = await supabase.from('produk').select();
    setState(() {
      produkList = response.map((e) => e as Map<String, dynamic>).toList();
      filteredList = produkList;  
    });
  }

  // Fungsi untuk menambahkan produk baru ke database
  Future<void> addProduk() async {
    if (!_formKey.currentState!.validate()) return; // Validasi form

    final namaProduk = namaController.text.trim();
    final harga = double.tryParse(hargaController.text.trim());
    final stok = int.tryParse(stokController.text.trim());

    // Cek apakah produk dengan nama yang sama sudah ada
    final existingProduk =
        await supabase.from('produk').select().eq('nama_produk', namaProduk);
    if (existingProduk.isNotEmpty) {
      showMessage("Produk sudah ada", isError: true);
      return;
    }

    // Tambahkan produk ke database
    await supabase
        .from('produk')
        .insert({'nama_produk': namaProduk, 'harga': harga, 'stok': stok});
    showMessage("Produk berhasil ditambahkan");
    clearForm(); // Hapus inputan form setelah berhasil ditambahkan
    fetchProduk(); // Refresh daftar produk
  }



  Future<void> _editProduk(BuildContext context, Map<String, dynamic> produk) async {
  final _formKey = GlobalKey<FormState>();

  // Isi controller dengan nilai lama agar tidak NULL
  TextEditingController nameController = TextEditingController(text: produk['nama_produk']);
  TextEditingController priceController = TextEditingController(text: produk['harga'].toString());
  TextEditingController stockController = TextEditingController(text: produk['stok'].toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit Produk', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nama produk tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
                  final price = int.tryParse(value);
                  if (price == null || price <= 0) return 'Masukkan harga dengan benar';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Stok tidak boleh kosong';
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) return 'Masukkan stok dengan benar';
                  return null;
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Batal', style: GoogleFonts.poppins(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Ambil data dari input atau gunakan data lama jika kosong
                final name = nameController.text.isNotEmpty ? nameController.text : produk['nama_produk'];
                final price = priceController.text.isNotEmpty ? int.tryParse(priceController.text) ?? produk['harga'] : produk['harga'];
                final stock = stockController.text.isNotEmpty ? int.tryParse(stockController.text) ?? produk['stok'] : produk['stok'];

                try {
                  await Supabase.instance.client.from('produk').update({
                    'nama_produk': name,
                    'harga': price,
                    'stok': stock,
                  }).match({'id_produk': produk['id_produk']});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Produk berhasil diperbarui'))
                  );

                  fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kesalahan: $e'))
                  );
                }
              }
            },
            child: Text('Simpan', style: GoogleFonts.poppins()),
          ),
        ],
      );
    },
  );
}




  Future<void> deleteProduk(int produkId) async {
    await supabase.from('produk').delete().eq('id_produk', produkId);
    showMessage("Produk berhasil dihapus");
    fetchProduk();
  }

//alert hapus
  void showDeleteConfirmation(BuildContext context, int produkId) {
    print("ID produk yang akan dihapus: $produkId"); // Debugging
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus produk ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                print("Menghapus produk dengan ID: $produkId"); // Debugging
                deleteProduk(produkId);
                Navigator.pop(context);
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan pesan notifikasi
  void showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Fungsi untuk mengosongkan form input
  void clearForm() {
    setState(() {
      editingProdukId = null;
      namaController.clear();
      hargaController.clear();
      stokController.clear();
    });
  }

  // Fungsi untuk mencari produk berdasarkan nama
  void searchProduk(String query) {
    setState(() {
      filteredList = produkList
          .where((produk) =>
              produk['nama_produk'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

// Future<void> beliProduk(BuildContext context, Map<String, dynamic> produk, int jumlah) async {
//   if (jumlah <= 0 || jumlah > produk['stok']) {
//     showMessage("Jumlah tidak valid", isError: true);
//     return;
//   }

//   final totalHarga = produk['harga'] * jumlah;

//   try {
//     // Ambil pelanggan pertama dari database
//     final response = await supabase.from('pelanggan').select().limit(1);
//     if (response.isEmpty) {
//       showMessage("Tidak ada pelanggan di database!", isError: true);
//       return;
//     }

//     final idPelanggan = response.first['id_pelanggan'];

//     // Tambahkan transaksi ke tabel penjualan
//     final transaksiResponse = await supabase.from('penjualan').insert({
//       'tgl_penjualan': DateTime.now().toIso8601String(),
//       'total': totalHarga,
//       'id_pelanggan': idPelanggan, // Gunakan id pelanggan yang valid
//     }).select().single();

//     if (transaksiResponse == null) {
//       showMessage("Gagal menambahkan transaksi", isError: true);
//       return;
//     }

//     final idPenjualan = transaksiResponse['id_penjualan'];
//     print("Transaksi berhasil, ID: $idPenjualan");

//     // Tambahkan ke tabel detail_penjualan
//     final detailResponse = await supabase.from('detail_penjualan').insert({
//       'id_penjualan': idPenjualan,
//       'id_produk': produk['id_produk'],
//       'jumlah_produk': jumlah,
//       'subtotal': totalHarga,
//     }).select();

//     if (detailResponse == null) {
//       showMessage("Gagal menambahkan detail transaksi", isError: true);
//       return;
//     }

//     // Kurangi stok produk
//     await supabase
//         .from('produk')
//         .update({'stok': produk['stok'] - jumlah})
//         .eq('id_produk', produk['id_produk']);

//     showMessage("Produk berhasil dibeli");

//     // Tutup dialog sebelum navigasi
//     Navigator.pop(context);

//     // Navigasi ke halaman penjualan dan refresh data
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => PenjualanPage()),
//     );
//   } catch (error) {
//     print("Error saat membeli produk: $error");
//     showMessage("Terjadi kesalahan!", isError: true);
//   }
// }


// // Dialog beli produk
// dynamic showBeliDialog(BuildContext context, Map<String, dynamic> produk) {
//   final jumlahController = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text("Beli ${produk['nama_produk']}"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Harga: Rp${produk['harga']}", style: TextStyle(fontSize: 16)),
//             Text("Stok: ${produk['stok']}", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 12),
//             TextField(
//               controller: jumlahController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Jumlah yang ingin dibeli",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Batal"),
//           ),
//           TextButton(
//             onPressed: () {
//               final jumlah = int.tryParse(jumlahController.text) ?? 0;
//               if (jumlah <= 0) {
//                 showMessage("Masukkan jumlah yang benar", isError: true);
//                 return;
//               }
//               beliProduk(context, produk, jumlah);
//             },
//             child: Text("Beli"),
//           ),
//         ],
//       );
//     },
//   );
// }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manajemen Produk")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form untuk input produk
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(labelText: "Nama Produk"),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "Nama produk tidak boleh kosong"
                        : null,
                  ),
                  TextFormField(
                    controller: hargaController,
                    decoration: InputDecoration(labelText: "Harga"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return "Harga tidak boleh kosong";
                      if (double.tryParse(value) == null)
                        return "Harga harus berupa angka";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: stokController,
                    decoration: InputDecoration(labelText: "Stok"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return "Stok tidak boleh kosong";
                      if (int.tryParse(value) == null)
                        return "Stok harus berupa angka";
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),


            // Tombol Tambah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
  onPressed: addProduk,
  child: Text("Tambah Produk"),
),

                if (editingProdukId != null)
                  ElevatedButton(
                    onPressed: clearForm,
                    child: Text("Batal"),
                  ),
              ],
            ),
            SizedBox(height: 16),

            // Input untuk mencari produk
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari Produk",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: searchProduk,
            ),

            // List produk yang ditampilkan
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final produk = filteredList[index];
                  return ListTile(
                    title: Text(produk['nama_produk']),
                    subtitle: Text(
                        "Harga: Rp${produk['harga']} | Stok: ${produk['stok']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editProduk(context, produk),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteConfirmation(
                              context, produk['id_produk']),
                        ),
                        // IconButton(
                        //   icon:
                        //       Icon(Icons.add_shopping_cart, color: Colors.blue),
                        //   onPressed: () => showBeliDialog(context, produk),
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}