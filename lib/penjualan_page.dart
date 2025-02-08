import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir/detail_penjualan_page.dart';

class PenjualanPage extends StatefulWidget {
  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> transactions = [];
  List<Map<String, dynamic>> filteredTransactions = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await supabase.from('penjualan').select(
          'id_penjualan, tgl_penjualan, total, pelanggan(nama_pelanggan)');

      setState(() {
        transactions = response.map((e) => e as Map<String, dynamic>).toList();
        filteredTransactions = transactions;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil data. Coba lagi."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void searchTransactions(String query) {
    setState(() {
      filteredTransactions = transactions
          .where((trx) => trx['pelanggan']['nama_pelanggan']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Penjualan")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari pelanggan...",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: searchTransactions,
            ),
            SizedBox(height: 10),

            // Tampilkan indikator loading
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (hasError)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text("Terjadi kesalahan saat memuat data"),
                    ElevatedButton(
                      onPressed: fetchTransactions,
                      child: Text("Coba Lagi"),
                    ),
                  ],
                ),
              )
            else if (filteredTransactions.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_long, size: 100, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Belum ada transaksi", style: TextStyle(fontSize: 16)),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final trx = filteredTransactions[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          "Pelanggan: ${trx['pelanggan']['nama_pelanggan']}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              "Total: Rp${trx['total']}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            SizedBox(height: 5),
                            Text("Tanggal: ${trx['tgl_penjualan']}"),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPenjualanPage(
                                    idPenjualan: trx['id_penjualan']),
                              ),
                            );
                          },
                          child: Text("Lihat Detail"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
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
