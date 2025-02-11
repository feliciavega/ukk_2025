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

    print("Response Detail Penjualan: $response");
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

  Future<void> deleteDetail(int idDetail) async {
  try {
    await supabase.from('detail_penjualan').delete().eq('id_detail', idDetail);
    fetchDetails(); // Pastikan fungsi ini ada untuk memperbarui tampilan
  } catch (error) {
    print("Error menghapus detail penjualan: $error");
  }
}

void deleteDetailPenjualan(BuildContext context, int detailId) {
  print("ID detail penjualan yang akan dihapus: $detailId"); // Debugging
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus detail penjualan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () async { // Tambahkan async di sini
              print("Menghapus detail penjualan dengan ID: $detailId"); // Debugging
              await deleteDetail(detailId); // Tambahkan await agar selesai dulu
              Navigator.pop(context);
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Penjualan #${widget.idPenjualan}")),
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
                    title: Text(detail['produk']['nama_produk'] ?? "Produk Tidak Diketahui"),
                    subtitle: Text("Jumlah: ${detail['jumlah_produk']}",
                        style: TextStyle(color: Colors.grey[600])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Rp${detail['subtotal']}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteDetailPenjualan(context, detail['id_detail']),

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
