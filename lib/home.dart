// ///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// import 'package:flutter/material.dart';

// class home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 254, 255, 255),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Text(
//                           "Hello",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 14,
//                             color: Color(0xff8c8989),
//                           ),
//                         ),
//                         Text(
//                           "Felicia",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                     width: 50,
//                     child: Stack(
//                       alignment: Alignment.topRight,
//                       children: [
//                         Icon(
//                           Icons.account_circle,
//                           color: Colors.white,
//                           size: 43,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: TextField(
//                 controller: TextEditingController(),
//                 obscureText: false,
//                 textAlign: TextAlign.start,
//                 maxLines: 1,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontStyle: FontStyle.normal,
//                   fontSize: 14,
//                   color: Color(0xff000000),
//                 ),
//                 decoration: InputDecoration(
//                   disabledBorder: UnderlineInputBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                     borderSide: BorderSide(color: Color(0xff000000), width: 1),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                     borderSide: BorderSide(color: Color(0xff000000), width: 1),
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderRadius: BorderRadius.circular(4.0),
//                     borderSide: BorderSide(color: Color(0xff000000), width: 1),
//                   ),
//                   filled: true,
//                   fillColor: Color(0x00ffffff),
//                   isDense: true,
//                   contentPadding: EdgeInsets.all(12),
//                   prefixIcon:
//                       Icon(Icons.search, color: Color(0xffa4a2a2), size: 20),
//                 ),
//               ),
//             ),
//             GridView(
//               padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//               shrinkWrap: true,
//               scrollDirection: Axis.vertical,
//               physics: ClampingScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.7,
//               ),
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(0),
//                   decoration: BoxDecoration(
//                     color: Color(0xffffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.all(0),
//                         padding: EdgeInsets.all(0),
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color.fromARGB(255, 47, 108, 133),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                         child: Text(
//                           "Produk",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color.fromARGB(255, 47, 108, 133),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(0),
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 47, 108, 133),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.all(0),
//                         padding: EdgeInsets.all(0),
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color(0xff217760),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                         child: Text(
//                           "Pelanggan",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(0),
//                   decoration: BoxDecoration(
//                     color: Color(0xffffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.all(0),
//                         padding: EdgeInsets.all(0),
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color(0xff5cde75),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                         child: Text(
//                           "Penjualan",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(0),
//                   decoration: BoxDecoration(
//                     color: Color(0xffffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.all(0),
//                         padding: EdgeInsets.all(0),
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color(0xffe98258),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                         child: Text(
//                           "Detail",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(0),
//                   padding: EdgeInsets.all(0),
//                   decoration: BoxDecoration(
//                     color: Color(0xffffffff),
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.all(0),
//                         padding: EdgeInsets.all(0),
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color(0xff4ee3ce),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
//                         child: Text(
//                           "Registrasi",
//                           textAlign: TextAlign.start,
//                           overflow: TextOverflow.clip,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                             fontSize: 16,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.all(0),
//               padding: EdgeInsets.all(0),
//               height: 170,
//               decoration: BoxDecoration(
//                 color: Color(0x00ffffff),
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.zero,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
