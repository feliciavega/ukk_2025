import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualanPage extends StatefulWidget {
  final int idPenjualan;
  DetailPenjualanPage({required this.idPenjualan});

  @override
  _DetailPenjualanPageState createState() => _DetailPenjualanPageState();
}

class _DetailPenjualanPageState extends State<DetailPenjualanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> details = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredDetails = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final response = await supabase
        .from('detail_penjualan')
        .select('jumlah_produk, subtotal, produk(nama_produk)')
        .eq('id_penjualan', widget.idPenjualan);

    setState(() {
      details = response.map((e) => e as Map<String, dynamic>).toList();
      filteredDetails = List.from(details);
    });
  }

  void searchDetails(String query) {
    setState(() {
      filteredDetails = details
          .where((detail) => detail['produk']['nama_produk']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> deleteDetail(int index) async {
    try {
      await supabase.from('detail_penjualan').delete().eq('id_detail', details[index]['id_detail']);
      fetchDetails();
    } catch (error) {
      print("Error menghapus detail penjualan: $error");
    }
  }

  void deleteDetailPenjualan(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Apakah Anda yakin ingin menghapus detail penjualan ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                await deleteDetail(index);
                Navigator.pop(context);
              },
              child: Text("Hapus", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Penjualan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari produk...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: searchDetails,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDetails.length,
                itemBuilder: (context, index) {
                  final detail = filteredDetails[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(detail['produk']['nama_produk'] ?? "Produk Tidak Diketahui",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text("Jumlah: ${detail['jumlah_produk']}",
                          style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Rp${detail['subtotal']}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteDetailPenjualan(context, index),
                          ),
                        ],
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
