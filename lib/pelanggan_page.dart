import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PelangganPage extends StatefulWidget {
  @override
  _PelangganPageState createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Controller untuk inputan
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

// List untuk menyimpan data produk dari Supabase
  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> pelangganList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> daftarPelanggan = [];

  int? editingPelangganId;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan([String query = '']) async {
    final response = await supabase
        .from('pelanggan')
        .select()
        .ilike('nama_pelanggan', '%$query%');
    setState(() {
      pelanggan = response.map((e) => e as Map<String, dynamic>).toList();
    });
  }

  Future<void> addPelanggan() async {
    if (!_formKey.currentState!.validate()) return;

    final nama = namaController.text.trim();
    final noTelp = noTelpController.text.trim();
    final alamat = alamatController.text.trim();

    final existingPelanggan =
        await supabase.from('pelanggan').select().eq('no_telp', noTelp);

    if (existingPelanggan.isNotEmpty) {
      showMessage("Nomor telepon sudah terdaftar", isError: true);
      return;
    }

    await supabase.from('pelanggan').insert({
      'nama_pelanggan': nama,
      'no_telp': noTelp,
      'alamat': alamat,
    });
    showMessage("Pelanggan berhasil ditambahkan");
    clearForm();
    fetchPelanggan();
  }

Future<void> _editPelanggan(BuildContext context, Map<String, dynamic> pelanggan) async {
  final _formKey = GlobalKey<FormState>();

  // Isi controller dengan nilai lama agar tidak NULL
  TextEditingController nameController = TextEditingController(text: pelanggan['nama_pelanggan']);
  TextEditingController phoneController = TextEditingController(text: pelanggan['no_telp']);
  TextEditingController addressController = TextEditingController(text: pelanggan['alamat']);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit Pelanggan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nama pelanggan tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nomor telepon tidak boleh kosong';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Masukkan nomor telepon yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Alamat tidak boleh kosong';
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
                final name = nameController.text.isNotEmpty ? nameController.text : pelanggan['nama_pelanggan'];
                final phone = phoneController.text.isNotEmpty ? phoneController.text : pelanggan['no_telp'];
                final address = addressController.text.isNotEmpty ? addressController.text : pelanggan['alamat'];

                try {
                  await Supabase.instance.client.from('pelanggan').update({
                    'nama_pelanggan': name,
                    'no_telp': phone,
                    'alamat': address,
                  }).match({'id_pelanggan': pelanggan['id_pelanggan']});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pelanggan berhasil diperbarui'))
                  );

                  fetchPelanggan(); // Refresh daftar pelanggan setelah update
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



  //alert hapus
  void showDeleteConfirmation(BuildContext context, int pelangganId) {
    print("ID pelanggan yang akan dihapus: $pelangganId"); // Debugging
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus pelanggan ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                print(
                    "Menghapus pelanggan dengan ID: $pelangganId"); // Debugging
                deletePelanggan(pelangganId);
                Navigator.pop(context);
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePelanggan(int pelangganId) async {
    await supabase.from('pelanggan').delete().eq('id_pelanggan', pelangganId);
    showMessage("Pelanggan berhasil dihapus");
    fetchPelanggan();
  }

  void showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color.fromARGB(255, 163, 46, 38)
            : const Color.fromARGB(255, 33, 126, 36),
      ),
    );
  }

  void startEditing(Map<String, dynamic> pelanggan) {
    setState(() {
      editingPelangganId = pelanggan['id_pelanggan'];
      namaController.text = pelanggan['nama_pelanggan'];
      noTelpController.text = pelanggan['no_telp'];
      alamatController.text = pelanggan['alamat'];
    });
  }

  // Fungsi untuk mencari produk berdasarkan nama
  void searchPelanggan(String query) {
    setState(() {
      filteredList = pelangganList
          .where((produk) => produk['nama_pelanggan']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearForm() {
    setState(() {
      editingPelangganId = null;
      namaController.clear();
      noTelpController.clear();
      alamatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manajemen Pelanggan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari Pelanggan",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: fetchPelanggan,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(labelText: "Nama Pelanggan"),
                    validator: (value) =>
                        value!.isEmpty ? "Nama tidak boleh kosong" : null,
                  ),
                  TextFormField(
                    controller: noTelpController,
                    decoration: InputDecoration(labelText: "No Telepon"),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty)
                        return "No Telepon tidak boleh kosong";
                      if (!RegExp(r'^[0-9]+$').hasMatch(value))
                        return "No Telepon harus angka";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: alamatController,
                    decoration: InputDecoration(labelText: "Alamat"),
                    validator: (value) =>
                        value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ElevatedButton(
      onPressed: () {
        if (editingPelangganId == null) {
          addPelanggan(); // Fungsi untuk menambah pelanggan baru
        } else {
          // Ambil data pelanggan berdasarkan ID yang sedang diedit
          final pelanggan = daftarPelanggan.firstWhere((p) => p['id_pelanggan'] == editingPelangganId);
          _editPelanggan(context, pelanggan); // Panggil fungsi edit pelanggan
        }
      },
      child: Text(editingPelangganId == null ? "Tambah Pelanggan" : "Update Pelanggan"),
    ),
  ],
),

            Expanded(
              child: ListView.builder(
                itemCount: pelanggan.length,
                itemBuilder: (context, index) {
                  final p = pelanggan[index];
                  return ListTile(
                    title: Text(p['nama_pelanggan']),
                    subtitle: Text(p['no_telp']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit,
                                color: const Color.fromARGB(255, 31, 89, 136)),
                            onPressed: () => _editPelanggan(context, p)),
                        IconButton(
                          icon: Icon(Icons.delete,
                              color: const Color.fromARGB(255, 163, 29, 19)),
                          onPressed: () => showDeleteConfirmation(
                              context, p['id_pelanggan']),
                        )
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
