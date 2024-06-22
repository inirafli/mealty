import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mealty/data/model/user.dart' as model;
import 'package:mealty/data/model/food_order.dart';
import 'package:mealty/services/firestore_services.dart';
import 'package:mealty/utils/data_conversion.dart';

class PDFGenerator {
  final FirestoreService firestoreService;

  PDFGenerator(this.firestoreService);

  Future<File> generateSummaryPDF(
      model.User currentUser, List<FoodOrder> buyerOrders, List<FoodOrder> sellerOrders) async {
    final pdf = pw.Document();

    final buyerOrderDetails = await _fetchOrderDetails(buyerOrders, isBuyer: true);
    final sellerOrderDetails = await _fetchOrderDetails(sellerOrders, isBuyer: false);

    final totalBuyerAmount = buyerOrders.fold<int>(0, (sum, order) => sum + order.totalPrice);
    final totalSellerAmount = sellerOrders.fold<int>(0, (sum, order) => sum + order.totalPrice);

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Rangkuman Pesanan di Mealty', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Nama: ${currentUser.username}'),
            pw.Text('No Telepon: ${currentUser.phoneNumber}'),
            pw.SizedBox(height: 20),
            pw.Text('Pembelian', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...buyerOrderDetails,
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Total Pembelian: ${formatPrice(totalBuyerAmount)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Penjualan', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...sellerOrderDetails,
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Total Penjualan: ${formatPrice(totalSellerAmount)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
          ],
        );
      },
    ));

    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/summary-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<List<pw.Widget>> _fetchOrderDetails(List<FoodOrder> orders, {required bool isBuyer}) async {
    final List<pw.Widget> details = [];

    for (var order in orders) {
      final userId = isBuyer ? order.sellerId : order.buyerId;
      final userDoc = await firestoreService.getUser(userId);

      for (var item in order.foodItems) {
        final foodDoc = await firestoreService.getFoodPostById(item.foodId);
        final foodData = foodDoc?.data() as Map<String, dynamic>?;  // Ensure proper type checking
        final foodName = foodData?['name'] ?? 'Unknown Food';

        details.add(pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('x${item.quantity} $foodName'),
            pw.Text('Total: ${formatPrice(order.totalPrice)}'),
            pw.Text('pada: ${formatDate(order.completionDate!)}'),
            pw.Text('${isBuyer ? 'Dibeli dari' : 'Dijual kepada'}: ${userDoc.username} - ${userDoc.phoneNumber}'),
            pw.SizedBox(height: 10),
          ],
        ));
      }
    }

    return details;
  }
}
