import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kasir/detail_penjualan_page.dart';
import 'package:kasir/riwayat_penjualan_page.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
 
class PenjualanPage extends StatefulWidget {
  @override
  _PenjualanPageState createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> cartItems = [];
  double totalHarga = 0;
  int? lastIdPenjualan;
  List<Map<String, dynamic>> pelangganList = [];
  int? selectedPelangganId;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
    fetchPelangganList();
  }

   Future<void> fetchPelangganList() async {
    final response = await supabase.from('pelanggan').select();
    setState(() {
      pelangganList = response.map((pelanggan) => {
        'id_pelanggan': pelanggan['id_pelanggan'],
        'nama_pelanggan': pelanggan['nama_pelanggan'],
      }).toList();
    });
  }

 void fetchCartItems() async {
  final response = await supabase.from('produk').select();
  setState(() {
    cartItems = response.map((item) => {
      'id_produk': item['id_produk'], // Gunakan 'id_produk' sesuai Supabase
      'nama_produk': item['nama_produk'],
      'harga': item['harga'],
      'jumlah': 1,
      'selected': false,
      'controller': TextEditingController(text: '1'),
    }).toList();
    calculateTotal();
  });

  // Debugging: Cek apakah ada produk tanpa ID
  for (var item in cartItems) {
    if (item['id_produk'] == null) {
      print("ERROR: Produk ${item['nama_produk']} tidak memiliki ID!");
    }
  }
}

  void calculateTotal() {
    totalHarga = cartItems.fold(0, (sum, item) => sum + (item['selected'] ? item['harga'] * item['jumlah'] : 0));
  }

  void updateJumlah(int index, int newJumlah) {
    if (newJumlah > 0) {
      setState(() {
        cartItems[index]['jumlah'] = newJumlah;
        cartItems[index]['controller'].text = newJumlah.toString();
        calculateTotal();
      });
    }
  }

Future<void> checkout() async {
    if (selectedPelangganId == null) {
      showMessage("Pilih pelanggan terlebih dahulu!", isError: true);
      return;
    }
    
    try {
      final transaksiResponse = await supabase.from('penjualan').insert({
        'tgl_penjualan': DateTime.now().toIso8601String(),
        'total': totalHarga,
        'id_pelanggan': selectedPelangganId,
      }).select().single();

      if (transaksiResponse == null) {
        showMessage("Gagal melakukan checkout", isError: true);
        return;
      }

      final idPenjualan = transaksiResponse['id_penjualan'];
      lastIdPenjualan = idPenjualan;

      for (var item in cartItems.where((item) => item['selected'])) {
        await supabase.from('detail_penjualan').insert({
          'id_penjualan': idPenjualan,
          'id_produk': item['id_produk'],
          'jumlah_produk': item['jumlah'],
          'subtotal': item['harga'] * item['jumlah'],
        });
      }

      showCheckoutSuccessDialog();
    } catch (error) {
      showMessage("Terjadi kesalahan saat checkout!", isError: true);
    }
  }

/// **Generate PDF dan Simpan ke Penyimpanan**
 Future<String> generatePDF() async {
  final pdf = pw.Document();
    final String tanggalStr = DateTime.now().toLocal().toString(); // Ambil tanggal & waktu sekarang
    
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Struk Pembelian",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...cartItems.where((item) => item['selected'] == true).map((item) => pw.Text(
                "${item['nama_produk'] ?? 'Tidak ada nama'} x${item['jumlah'] ?? 0} - Rp${(item['harga'] as num? ?? 0) * (item['jumlah'] as num? ?? 0)}")),
            pw.Divider(),
            pw.Text("Total: Rp${totalHarga.toStringAsFixed(0)}",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final filePath = "${directory.path}/struk_penjualan.pdf";
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  showMessage("Struk berhasil disimpan di: $filePath");
  return filePath;
}

// Fungsi untuk membuka file PDF
Future<void> openFile(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    await Printing.sharePdf(bytes: await file.readAsBytes(), filename: "struk_penjualan.pdf");
  } else {
    showMessage("File tidak ditemukan!", isError: true);
  }
}

  /// **Print PDF langsung**
  Future<void> printPDF() async {
  final pdf = pw.Document();
  final String tanggalStr = DateTime.now().toLocal().toString();
  final font = await PdfGoogleFonts.robotoMonoRegular(); // Font monospace

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80, // Gunakan ukuran kertas thermal 80mm
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, // Semua teks ke kiri
          children: [
            // **Judul**
            pw.Center(
              child: pw.Text("STRUK PEMBELIAN",
                  style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      font: font)),
            ),
            pw.SizedBox(height: 5),
            pw.Text("Tanggal : $tanggalStr",
                style: pw.TextStyle(fontSize: 10, font: font)),

            pw.Text("================================",
                style: pw.TextStyle(fontSize: 10, font: font)),

            // **Header**
            pw.Text("Item           Qty  Harga   Total",
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, font: font)),

            pw.Text("--------------------------------",
                style: pw.TextStyle(fontSize: 10, font: font)),

            // **Daftar Produk**
            ...cartItems.where((item) => item['selected'] == true).map(
              (item) {
                final namaProduk = (item['nama_produk'] ?? "").padRight(12).substring(0, 12);
                final jumlah = item['jumlah'].toString().padLeft(2);
                final harga = item['harga'].toString().padLeft(6);
                final subtotal = (item['harga'] * item['jumlah']).toString().padLeft(7);

                return pw.Text(
                    "$namaProduk  $jumlah  $harga  $subtotal",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(fontSize: 10, font: font));
              },
            ),

            // **Garis Pemisah**
            pw.Text("--------------------------------",
                style: pw.TextStyle(fontSize: 10, font: font)),

            // **Total Harga**
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("TOTAL: Rp${totalHarga.toStringAsFixed(0)}",
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, font: font)),
            ),

            pw.SizedBox(height: 5),

            // **Terima Kasih**
            pw.Center(
              child: pw.Text("TERIMA KASIH",
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      font: font)),
            ),
          ],
        );
      },
    ),
  );

  // **Cetak PDF**
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );


    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  void showCheckoutSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Checkout Berhasil!"),
          content: Text("Pilih tindakan:"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tutup"),
            ),
            
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                printPDF();
              },
              child: Text("Cetak Struk"),
            ),
            TextButton(
  onPressed: () {
    Navigator.pop(context);
    if (lastIdPenjualan != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPenjualanPage(idPenjualan: lastIdPenjualan!),
        ),
      );
    } else {
      showMessage("Gagal mendapatkan ID Penjualan!", isError: true);
    }
  },
  child: Text("Lihat Detail Penjualan"),
),

          ],
        );
      },
    );
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
      appBar: AppBar(
        title: Text("Checkout"),
        actions: [
          IconButton(
  icon: Icon(Icons.history),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RiwayatPenjualanPage()),
    );
  },
),

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: DropdownButton<int>(
              value: selectedPelangganId,
              hint: Text("Pilih Pelanggan"),
              onChanged: (int? newValue) {
                setState(() {
                  selectedPelangganId = newValue;
                });
              },
              items: pelangganList.map((pelanggan) {
                return DropdownMenuItem<int>(
                  value: pelanggan['id_pelanggan'],
                  child: Text(pelanggan['nama_pelanggan']),
                );
              }).toList(),
            ),
          ),
          Expanded(
  child: ListView.builder(
    itemCount: cartItems.length,
    itemBuilder: (context, index) {
      final item = cartItems[index];
      return Card(
        margin: EdgeInsets.all(8),
        child: ListTile(
          leading: Checkbox(
            value: item['selected'],
            onChanged: (bool? value) {
              setState(() {
                cartItems[index]['selected'] = value ?? false;
                calculateTotal();
              });
            },
          ),
          title: Text(item['nama_produk']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Harga: Rp${item['harga']}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (item['jumlah'] > 1) {
                        updateJumlah(index, item['jumlah'] - 1);
                      }
                    },
                  ),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: item['controller'],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        int? jumlah = int.tryParse(value);
                        if (jumlah != null && jumlah > 0) {
                          updateJumlah(index, jumlah);
                        } else {
                          item['controller'].text = item['jumlah'].toString();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateJumlah(index, item['jumlah'] + 1);
                    },
                  ),
                ],
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
            child: ElevatedButton(
              onPressed: checkout,
              child: Text("Konfirmasi Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}