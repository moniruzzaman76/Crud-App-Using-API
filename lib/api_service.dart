// import 'dart:convert';
// import 'package:crud/model_class.dart';
// import 'package:http/http.dart';
//
// class ApiService{
//    static List<Products>product=[];
//
//   void getProduct() async{
//     String url = "https://crud.teamrabbil.com/api/v1/ReadProduct";
//     Response response = await get(Uri.parse(url));
//     print(response.body);
//     final Map<String,dynamic> jsonData = jsonDecode(response.body);
//     print(jsonData['data'].length);
//     if(response.statusCode == 200 && jsonData['status']== 'success'){
//       for (var allData in jsonData['data'] ){
//        product.add(Products(
//          allData['_id'],
//          allData['ProductName'],
//          allData['ProductCode'],
//          allData['Img'],
//          allData['UnitPrice'],
//          allData['Qty'],
//          allData['TotalPrice'],
//          allData['CreatedDate'],
//        ));
//      }
//     }
//   }
// }

