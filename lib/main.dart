import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(MaterialApp(
    home: Invoice_Details(),
    debugShowCheckedModeBanner: false,
  ));
}

class Invoice_Details extends StatefulWidget {
  const Invoice_Details({Key? key}) : super(key: key);

  @override
  State<Invoice_Details> createState() => _Invoice_DetailsState();
}

class _Invoice_DetailsState extends State<Invoice_Details> {
  // List<int> selectedItemValue  = <int>[];
  //
  // List<DropdownMenuItem<int>> _dropDownItem() {
  //   List<int> itemValue = [0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  //   return itemValue
  //       .map((value) => DropdownMenuItem(
  //     value: value,
  //     child: Text(value.toString()),
  //   ))
  //       .toList();
  // }

  List<DropdownMenuItem> qtyk = [];
  List<DropdownMenuItem> qtyp = [];
  List<DropdownMenuItem> qtym = [];
  String QTYK = "QTY";
  String QTYP = "QTY";
  String QTYM = "QTY";
  TextEditingController rate = TextEditingController();
  TextEditingController rate1 = TextEditingController();
  TextEditingController rate2 = TextEditingController();
  bool check = false;
  bool check1 = false;
  bool check2 = false;
  List product = [];
  List price = [];
  List no_qty = [];
  List<bool> temp = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qtyk.add(DropdownMenuItem(
      child: Text("QTY"),
      value: "QTY",
    ));
    qtyp.add(DropdownMenuItem(
      child: Text("QTY"),
      value: "QTY",
    ));
    qtym.add(DropdownMenuItem(
      child: Text("QTY"),
      value: "QTY",
    ));

    for (int i = 1; i <= 10; i++) {
      qtyk.add(DropdownMenuItem(
        child: Text("${i}"),
        value: "${i}",
      ));
    }
    for (int i = 1; i <= 10; i++) {
      qtyp.add(DropdownMenuItem(
        child: Text("${i}"),
        value: "${i}",
      ));
    }
    for (int i = 1; i <= 10; i++) {
      qtym.add(DropdownMenuItem(
        child: Text("${i}"),
        value: "${i}",
      ));
    }
    temp= List.filled(product.length, false);
    permission();
  }

  permission() async {

    var status = await Permission.storage.status;
    if ( status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
  }
//convert asset image to file flutter
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(child: Text("XYZ Infotech PVT LTD", textAlign: TextAlign.center, style: TextStyle(fontSize: 25),),
            height: 50, width: 250, decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all()),),
          
          Row(
            children: [Container(child: Text("Keybord", style: TextStyle(fontSize: 25),),),
              SizedBox(width: 5,),
              DropdownButton(items: qtyk, value: QTYK, onChanged: (value) {
                QTYK = value.toString();
                  print(QTYK);
                  setState(() {});},),
              Container(width: 50, child: TextField(controller: rate, decoration: InputDecoration(hintText: "Rate"),),),
              Checkbox(value: check, onChanged: (value) {
                  check = value as bool;
                  if (check == true) {
                    product.add("Keybord");
                    price.add(rate.text);
                    no_qty.add(QTYK);

                  }
                  if (check == false) {
                    product.remove("Keybord");
                    price.remove(rate.text);
                    no_qty.remove(QTYK);
                  }

                  setState(() {});
                },),
            ],),
          Row(
            children: [Container(child: Text("Pendrive", style: TextStyle(fontSize: 25),),),
              DropdownButton(items: qtyp, value: QTYP, onChanged: (value) {QTYP = value;
                  setState(() {});},),
              Container(width: 50, child: TextField(controller: rate1, decoration: InputDecoration(hintText: "Rate"),),),
              Checkbox(value: check1, onChanged: (value) {
                  check1 = value as bool;
                  if (check1 == true) {
                    product.add("Pendrive");
                    price.add(rate1.text);
                    no_qty.add(QTYP);
                  }
                  if (check1 == false) {
                    product.remove("Pendrive");
                    price.remove(rate1.text);
                    no_qty.remove(QTYP);
                  }
                  setState(() {});},),
            ],),
          Row(
            children: [Container(child: Text("Mouse", style: TextStyle(fontSize: 25),),),
               DropdownButton(items: qtym, value: QTYM, onChanged: (value) {QTYM = value;
                  setState(() {});},),
              Container(width: 50, child: TextField(controller: rate2, decoration: InputDecoration(hintText: "Rate"),),),
              Checkbox(value: check2, onChanged: (value) {
                  check2 = value as bool;
                  if (check2 == true) {
                    product.add("Mouse");
                    price.add(rate2.text);
                    no_qty.add(QTYM);
                  }
                  if (check2 == false) {
                    product.remove("Mouse");
                    price.remove(rate2.text);
                    no_qty.remove(QTYM);
                  }
                  setState(() {});},),
            ],),

          ElevatedButton(onPressed: () async {
            PdfDocument document = PdfDocument();
             PdfPage maypag=document.pages.add();
            maypag.graphics.drawString(
                'XYZ Infotech ', PdfStandardFont(PdfFontFamily.helvetica, 50),
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                bounds: const Rect.fromLTWH(30, 15, 230, 50));

            //image add in pdf
            File fimg= await getImageFileFromAssets("logo.png");
            Uint8List imageData = fimg.readAsBytesSync();
            PdfBitmap image = PdfBitmap(imageData);
            maypag.graphics.drawImage(image, Rect.fromLTWH(350, 10, 50, 50));

            PdfGrid grid = PdfGrid();
            grid.columns.add(count: 4);
            PdfGridRow headerRow = grid.headers.add(1)[0];
            headerRow.cells[0].value = 'Product';
            headerRow.cells[1].value = 'Price';
            headerRow.cells[2].value = 'QTY';
            headerRow.cells[3].value = 'Total';

             PdfGridRow row = grid.rows.add();
             row.cells[0].value = '${product[0]}';
             row.cells[1].value = '${price[0]}';
             row.cells[2].value = '${no_qty[0]}';
             row.cells[3].value = '${price}';

            headerRow.style.font = PdfStandardFont(PdfFontFamily.helvetica, 25, style: PdfFontStyle.bold);

             grid.draw(page: maypag, bounds: Rect.fromLTWH(30, 100, maypag.getClientSize().width, maypag.getClientSize().height));



              //creat folder
              var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS); //folder path that we have store
              Directory dir=Directory(path);
              if(!await dir.exists()){
                dir.create();
              }
              //file name and reda it
              String str="mypdf${Random().nextInt(1000)}.pdf"; //file name
              File f=File("${dir.path}/str"); //full file path
              f.writeAsBytes(await document.save());
              document.dispose();
              OpenFile.open(f.path); //open file plus pakage


          }, child: Text("SUBMIT")),

          // ListView.builder(
          //   itemCount: product.length,
          //   itemBuilder: (context, index) {
          //     return (temp[index]==true)ListTile(
          //         title: Row(
          //       children: [
          //         Container(
          //           width: 100,
          //           child: Text("${product[index]}"),
          //         ),
          //         Container(
          //           width: 100,
          //           child: Text("${no_qty[index]}"),
          //         ),
          //         Container(
          //           width: 100,
          //           child: Text("${price[index]}"),
          //         )
          //       ],
          //     )):null
          //   },
          // ),
        ]),
      ),
    );
  }
}
