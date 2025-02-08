import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Fungsi untuk memperbarui produk
  Future<void> updateProduk() async {
    if (!_formKey.currentState!.validate() || editingProdukId == null) return;

    final namaProduk = namaController.text.trim();
    final harga = double.tryParse(hargaController.text.trim());
    final stok = int.tryParse(stokController.text.trim());

    // Cek apakah ada produk lain dengan nama yang sama (kecuali produk yang sedang diedit)
    final existingProduk = await supabase
        .from('produk')
        .select()
        .eq('nama_produk', namaProduk)
        .neq('id', editingProdukId as Object);

    if (existingProduk.isNotEmpty) {
      showMessage("Produk sudah ada", isError: true);
      return;
    }

    // Update produk di database berdasarkan ID
    await supabase
        .from('produk')
        .update({'nama_produk': namaProduk, 'harga': harga, 'stok': stok}).eq(
            'id', editingProdukId as Object);

    showMessage("Produk berhasil diperbarui");
    clearForm(); // Hapus inputan setelah update berhasil
    fetchProduk(); // Refresh daftar produk
  }

  // Fungsi untuk menghapus produk berdasarkan ID
  Future<void> deleteProduk(int id) async {
    await supabase.from('produk').delete().eq('id', id);
    showMessage("Produk berhasil dihapus");
    fetchProduk(); // Refresh daftar produk
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

  // Fungsi untuk mulai mengedit produk
  void startEditing(Map<String, dynamic> produk) {
    setState(() {
      editingProdukId = produk['id'];
      namaController.text = produk['nama_produk'];
      hargaController.text = produk['harga'].toString();
      stokController.text = produk['stok'].toString();
    });
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

            // Tombol Tambah/Update Produk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: editingProdukId == null ? addProduk : updateProduk,
                  child: Text(editingProdukId == null
                      ? "Tambah Produk"
                      : "Update Produk"),
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
                          onPressed: () => startEditing(produk),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteProduk(produk['id']),
                        ),
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
