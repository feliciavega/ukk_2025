import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> cartItems = [];
  double totalHarga = 0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() {
    // Contoh data sementara (seharusnya dari state sebelumnya)
    setState(() {
      cartItems = [
        {'id_produk': 1, 'nama_produk': 'Donat Coklat', 'harga': 5000, 'jumlah': 2},
        {'id_produk': 2, 'nama_produk': 'Donat Keju', 'harga': 6000, 'jumlah': 1},
      ];
      calculateTotal();
    });
  }

  void calculateTotal() {
    totalHarga = cartItems.fold(0, (sum, item) => sum + (item['harga'] * item['jumlah']));
  }

  void updateJumlah(int index, int newJumlah) {
    if (newJumlah > 0) {
      setState(() {
        cartItems[index]['jumlah'] = newJumlah;
        calculateTotal();
      });
    }
  }

  Future<void> checkout() async {
    try {
      final response = await supabase.from('pelanggan').select().limit(1);
      if (response.isEmpty) {
        showMessage("Tidak ada pelanggan terdaftar!", isError: true);
        return;
      }

      final idPelanggan = response.first['id_pelanggan'];
      final transaksiResponse = await supabase.from('penjualan').insert({
        'tgl_penjualan': DateTime.now().toIso8601String(),
        'total': totalHarga,
        'id_pelanggan': idPelanggan,
      }).select().single();

      if (transaksiResponse == null) {
        showMessage("Gagal melakukan checkout", isError: true);
        return;
      }

      final idPenjualan = transaksiResponse['id_penjualan'];
      for (var item in cartItems) {
        await supabase.from('detail_penjualan').insert({
          'id_penjualan': idPenjualan,
          'id_produk': item['id_produk'],
          'jumlah_produk': item['jumlah'],
          'subtotal': item['harga'] * item['jumlah'],
        });
      }

      showMessage("Checkout berhasil!");
      Navigator.pop(context);
    } catch (error) {
      showMessage("Terjadi kesalahan saat checkout!", isError: true);
    }
  }

  void showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item['nama_produk']),
                    subtitle: Text("Harga: Rp${item['harga']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => updateJumlah(index, item['jumlah'] - 1),
                        ),
                        Text("${item['jumlah']}"),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => updateJumlah(index, item['jumlah'] + 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Total: Rp$totalHarga", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: checkout,
                  child: Text("Konfirmasi Checkout"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
