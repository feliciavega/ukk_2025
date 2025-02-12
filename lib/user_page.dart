import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Halaman untuk mengelola user
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Inisialisasi Supabase client
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk inputan username dan password
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Map<String, dynamic>> users = []; // List untuk menyimpan data user
  int? editingUserId; // Menyimpan ID user yang sedang diedit

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Ambil data user saat halaman dimuat
  }

  // Fungsi untuk mengambil data user dari Supabase
  Future<void> fetchUsers() async {
    final response = await supabase.from('user').select();
    setState(() {
      users = response.map((e) => e as Map<String, dynamic>).toList();
    });
  }

  // Fungsi untuk menambahkan user baru ke database
  Future<void> addUser() async {
    if (!_formKey.currentState!.validate()) return; // Validasi form

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Cek apakah username sudah digunakan
    final existingUsers =
        await supabase.from('user').select().eq('username', username);
    if (existingUsers.isNotEmpty) {
      showMessage("Username sudah digunakan", isError: true);
      return;
    }

    // Tambahkan user ke database
    await supabase
        .from('user')
        .insert({'username': username, 'password': password});
    showMessage("User berhasil ditambahkan");
    clearForm(); // Hapus inputan form setelah berhasil ditambahkan
    fetchUsers(); // Refresh daftar user
  }

  // Fungsi untuk memperbarui user
  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate() || editingUserId == null) return;

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Cek apakah ada user lain dengan username yang sama (kecuali user yang sedang diedit)
    final existingUsers = await supabase
        .from('user')
        .select()
        .eq('username', username)
        .neq('id', editingUserId as Object);

    if (existingUsers.isNotEmpty) {
      showMessage("Username sudah digunakan", isError: true);
      return;
    }

    // Update user di database berdasarkan ID
    await supabase
        .from('user')
        .update({'username': username, 'password': password}).eq(
            'id', editingUserId as Object);

    showMessage("User berhasil diperbarui");
    clearForm(); // Hapus inputan setelah update berhasil
    fetchUsers(); // Refresh daftar user
  }

  Future<void> deleteUser(int Id) async {
    await supabase.from('user').delete().eq('id', Id);
    showMessage("User berhasil dihapus");
    fetchUsers();
  }

  // Fungsi untuk mengonfirmasi penghapusan user
  void confirmDeleteUser(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus user ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup dialog
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog sebelum menghapus
              deleteUser(id); // Panggil fungsi hapus user
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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

  // Fungsi untuk mulai mengedit user
  void startEditing(Map<String, dynamic> user) {
    setState(() {
      editingUserId = user['id'];
      usernameController.text = user['username'];
      passwordController.text = user['password'];
    });
  }

  // Fungsi untuk mengosongkan form input
  void clearForm() {
    setState(() {
      editingUserId = null;
      usernameController.clear();
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manajemen User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form untuk input user
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "Username tidak boleh kosong"
                        : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? "Password tidak boleh kosong"
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Tombol Tambah/Update User
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: editingUserId == null ? addUser : updateUser,
                  child: Text(
                      editingUserId == null ? "Tambah User" : "Update User"),
                ),
                if (editingUserId != null)
                  ElevatedButton(
                    onPressed: clearForm,
                    child: Text("Batal"),
                  ),
              ],
            ),
            // List user yang ditampilkan
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['username']),
                  
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => startEditing(user),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDeleteUser(user['id']),
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