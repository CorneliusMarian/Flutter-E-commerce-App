import 'dart:convert'; // Importă acest pachet pentru decodificare Base64
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProductPage extends StatefulWidget {
  final String productId;
  final String imageUrl;
  final String productName;
  final String productDescription;
  final double productPrice;

  UpdateProductPage({
    required this.productId,
    required this.imageUrl,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  });

  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _productDescription;
  late double _productPrice;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _productName = widget.productName;
    _productDescription = widget.productDescription;
    _productPrice = widget.productPrice;
    _nameController = TextEditingController(text: _productName);
    _descriptionController = TextEditingController(text: _productDescription);
    _priceController = TextEditingController(text: _productPrice.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productId)
          .update({
        'name': _productName,
        'description': _productDescription,
        'price': _productPrice,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = Base64Decoder().convert(widget.imageUrl);
    final image = Image.memory(imageBytes, fit: BoxFit.cover);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
        backgroundColor: Color(0xFF475269),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: image,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productName = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productDescription = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _productPrice = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
