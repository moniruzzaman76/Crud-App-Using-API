import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({Key? key}) : super(key: key);

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {

  final TextEditingController nameEController = TextEditingController();
  final TextEditingController productCodeEController = TextEditingController();
  final TextEditingController priceEController = TextEditingController();
  final TextEditingController quantityEController = TextEditingController();
  final TextEditingController totalPriceEController = TextEditingController();
  final TextEditingController imageEController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _addInProgress = false;


  void addProduct()async{
    _addInProgress =true;
    if(mounted){
      setState(() {});
    }

    final url = Uri.parse("https://crud.teamrabbil.com/api/v1/CreateProduct");
    final response = await post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "ProductName": nameEController.text,
          "ProductCode": productCodeEController.text,
          "Img":imageEController.text,
          "UnitPrice": priceEController.text,
          "Qty": quantityEController.text,
          "TotalPrice": totalPriceEController.text,
        })
    );

    _addInProgress =false;
    if(mounted){
      setState(() {});
    }

    final decodeResponse = jsonDecode(response.body);
    if(response.statusCode == 200 && decodeResponse["status"]=="success"){

      nameEController.clear();
      productCodeEController.clear();
      imageEController.clear();
      priceEController.clear();
      quantityEController.clear();
      totalPriceEController.clear();

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
            content: Text("Successfully Add")));
      }
    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("failed data")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Product Name";
                    }
                    return null;
                  },
                  controller: nameEController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Product Code";
                    }
                    return null;
                  },
                  controller: productCodeEController,
                  decoration: const InputDecoration(hintText: 'Product code'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Product Price";
                    }
                    return null;
                  },
                  controller: priceEController,
                  decoration: const InputDecoration(hintText: 'Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Product Quantity";
                    }
                    return null;
                  },
                  controller: quantityEController,
                  decoration: const InputDecoration(hintText: 'Quantity'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Total Price";
                    }
                    return null;
                  },
                  controller: totalPriceEController,
                  decoration: const InputDecoration(hintText: 'Total Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Enter Valid Image Link";
                    }
                    return null;
                  },
                  controller: imageEController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: !_addInProgress,
                  replacement: const Center(child: CircularProgressIndicator(),),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: ()async {
                       if(_formKey.currentState!.validate()){
                         addProduct();
                       }},
                      child: const Text('Add'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
