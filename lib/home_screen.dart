import 'dart:convert';
import 'package:crud/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'add_new_product_screen.dart';
import 'model_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  List<Products>product=[];

  bool inProgress = false;
  bool deleteProgress = false;

  @override
  void initState() {
    super.initState();
   getProduct();
  }

   void getProduct() async{

    inProgress = true;
     String url = "https://crud.teamrabbil.com/api/v1/ReadProduct";
     Response response = await get(Uri.parse(url));

     final Map<String,dynamic> jsonData = jsonDecode(response.body);
     if(response.statusCode == 200 && jsonData['status']== 'success'){
       product.clear();
       for (var allData in jsonData['data'] ){
         product.add(Products.toJson(allData));
       }
     }
     inProgress = false;
     setState(() {});
   }


   Future<void> deleteProduct(String id)async{
    deleteProgress = true;
    if(mounted){
      setState(() {});
    }
    final response = await get(Uri.parse("https://crud.teamrabbil.com/api/v1/DeleteProduct/$id"));
    final Map<String,dynamic> jsonData = jsonDecode(response.body);
    if(response.statusCode == 200 && jsonData["status"] == "success"){
      getProduct();
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Successfully Delete!")));
      }
      deleteProgress = false;
      if(mounted){
        setState(() {});
      }

    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
            content: Text("Delete Failed!")));
      }
    }
   }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('CRUD'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewProductScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          color: Colors.green,
          onRefresh: ()async{
            getProduct();
          },
          child: inProgress? const Center(
            child:CircularProgressIndicator(),):ListView.separated(
            itemCount: product.length,
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.only(left: 16),
                          contentPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                          title: Row(
                            children: [
                              const Text('Choose an action'),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              )
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context)=> UpdateProductScreen(products:product[index],)));
                                },
                                leading: const Icon(Icons.edit,color: Colors.green,),
                                title: const Text('Edit'),
                              ),
                              const Divider(
                                height: 0,
                              ),
                              ListTile(
                                onTap: () {
                                  deleteProduct(product[index].id);
                                  Navigator.pop(context);
                                },
                                leading: const Icon(Icons.delete_forever_outlined,color: Colors.red,),
                                title: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      });
                },
                title:  Text(product[index].productName),
                subtitle:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product code: ${product[index].productCode}"),
                    Text("Total price: ${product[index].totalPrice}"),
                    Text("Total Quantity: ${product[index].quantity}"),
                  ],
                ),
                leading: Image.network(
                    product[index].image,
                    width: 50,
                    errorBuilder: ( context, object, stackTrace) {
                      return const Icon(
                        Icons.image,
                        size: 32,
                      );
                    }),
                trailing:  Text(product[index].unitPrice),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
                color: Colors.grey,
              );
            },
          ),
        ));
  }
}