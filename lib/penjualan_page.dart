import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanPage extends StatefulWidget {
  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> penjualanList = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
  final response = await supabase.from('penjualan').select();
  print(response); // Tambahkan ini untuk melihat hasil query
  setState(() {
    penjualanList = response.map((e) => e as Map<String, dynamic>).toList();
  print("Data yang disimpan di state: $penjualanList");
});
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Penjualan")),
      body: ListView.builder(
        itemCount: penjualanList.length,
        itemBuilder: (context, index) {
          final penjualan = penjualanList[index];
          return ListTile(
            title: Text("ID: ${penjualan['id_penjualan']} - Total: Rp${penjualan['total']}",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Tanggal: ${penjualan['tgl_penjualan']}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPenjualanPage(idPenjualan: penjualan['id_penjualan']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPenjualanPage extends StatefulWidget {
  final int idPenjualan;
  DetailPenjualanPage({required this.idPenjualan});

  @override
  _DetailPenjualanPageState createState() => _DetailPenjualanPageState();
}

class _DetailPenjualanPageState extends State<DetailPenjualanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> detailPenjualanList = [];

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
  }

  Future<void> fetchDetailPenjualan() async {
    final response = await supabase
        .from('detail_penjualan')
        .select('*, produk(nama_produk)')
        .eq('id_penjualan', widget.idPenjualan);
    setState(() {
      detailPenjualanList = response.map((e) => e as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Penjualan #${widget.idPenjualan}")),
      body: ListView.builder(
        itemCount: detailPenjualanList.length,
        itemBuilder: (context, index) {
          final detail = detailPenjualanList[index];
          return ListTile(
            title: Text("${detail['produk']['nama_produk']}"),
            subtitle: Text("Jumlah: ${detail['jumlah_produk']} | Subtotal: Rp${detail['subtotal']}"),
          );
        },
      ),
    );
  }
}
