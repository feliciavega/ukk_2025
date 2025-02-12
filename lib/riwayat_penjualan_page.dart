import 'package:flutter/material.dart';
import 'package:kasir/detail_penjualan_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatPenjualanPage extends StatefulWidget {
  @override
  _RiwayatPenjualanPageState createState() => _RiwayatPenjualanPageState();
}

class _RiwayatPenjualanPageState extends State<RiwayatPenjualanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> penjualanList = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  Future<void> fetchPenjualan() async {
    try {
      final response = await supabase.from('penjualan').select();

      if (response.isEmpty) {
        print("Penjualan kosong");
        return;
      }

      print("Response Penjualan: $response");

      setState(() {
        penjualanList = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      print("Error fetching penjualan: $error");
    }
  }

  Future<void> deletePenjualan(int penjualanId) async {
    try {
      await supabase.from('penjualan').delete().match({'id_penjualan': penjualanId});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Penjualan berhasil dihapus")),
      );
      fetchPenjualan();
    } catch (e) {
      print("Kesalahan saat menghapus penjualan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus penjualan")),
      );
    }
  }

  void showDeleteConfirmation(BuildContext context, int idPenjualan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus penjualan ini?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            TextButton(
              onPressed: () {
                deletePenjualan(idPenjualan);
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
      appBar: AppBar(
        title: Text("Riwayat Penjualan"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchPenjualan),
        ],
      ),
      body: penjualanList.isEmpty
          ? Center(child: Text("Tidak ada riwayat penjualan"))
          : ListView.builder(
              itemCount: penjualanList.length,
              itemBuilder: (context, index) {
                final penjualan = penjualanList[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.blue),
                    title: Text(
                      "ID: ${penjualan['id_penjualan']} - Total: Rp${penjualan['total']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Tanggal: ${penjualan['tgl_penjualan']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => showDeleteConfirmation(context, penjualan['id_penjualan']),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPenjualanPage(
                            idPenjualan: penjualan['id_penjualan'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}