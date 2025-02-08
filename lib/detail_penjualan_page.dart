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
        .select('id_detail, jumlah_produk, subtotal, produk(nama_produk)')
        .eq('id_penjualan', widget.idPenjualan);

    setState(() {
      details = response.map((e) => e as Map<String, dynamic>).toList();
      filteredDetails = details;
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

  Future<void> deleteDetail(int idDetail) async {
    await supabase.from('detail_penjualan').delete().eq('id_detail', idDetail);
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Penjualan")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari produk...",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: searchDetails,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDetails.length,
                itemBuilder: (context, index) {
                  final detail = filteredDetails[index];
                  return ListTile(
                    title: Text(detail['produk']['nama_produk']),
                    subtitle: Text("Jumlah: ${detail['jumlah_produk']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Rp${detail['subtotal']}"),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteDetail(detail['id_detail']),
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
