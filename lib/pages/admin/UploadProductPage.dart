import 'dart:convert'; // Importați acest pachet pentru codificare Base64
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce_app/providers/products_provider.dart';
import 'package:ecommerce_app/providers/categories_provider.dart';

class UploadProductPage extends StatefulWidget {
  @override
  _UploadProductPageState createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  String? _selectedCategory;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _imageBase64;

  CategoriesProvider _categoriesProvider = CategoriesProvider();
  ProductsProvider _productsProvider = ProductsProvider();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_selectedCategory != null &&
        _titleController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _qtyController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      List<QueryDocumentSnapshot> categories =
          await _categoriesProvider.getCategories();
      try {
        String categoryId =
            categories.firstWhere((cat) => cat['name'] == _selectedCategory).id;

        await _productsProvider.addProduct(
          categoryId: categoryId,
          name: _titleController.text,
          description: _descriptionController.text,
          imageBase64: _imageBase64 ?? '',
          price: double.parse(_priceController.text),
          stock: int.parse(_qtyController.text),
        );

        _titleController.clear();
        _priceController.clear();
        _qtyController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategory = null;
          _imageBase64 = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoria selectata nu a fost gasită.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completati toate campurile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adăugare produs nou'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50, color: Colors.blue),
                          SizedBox(height: 8),
                          Text(
                            'Adaugă imagine',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<QueryDocumentSnapshot>>(
                future: _categoriesProvider.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Eroare la incarcarea categoriilor');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Nu sunt categorii valabile');
                  }

                  List<DropdownMenuItem<String>> categoryItems = snapshot.data!
                      .map((category) => DropdownMenuItem<String>(
                            value: category['name'],
                            child: Text(category['name']),
                          ))
                      .toList();

                  return DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Alege Categorie'),
                    value: _selectedCategory,
                    items: categoryItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nume produs',
                  counterText: '0/80',
                ),
                maxLength: 80,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Preț',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      decoration: InputDecoration(
                        labelText: 'Cantitate',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrierea produsului',
                  counterText: '0/1000',
                ),
                maxLength: 1000,
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _titleController.clear();
                        _priceController.clear();
                        _qtyController.clear();
                        _descriptionController.clear();
                        setState(() {
                          _selectedCategory = null;
                          _imageBase64 = null;
                        });
                      },
                      child: Text('Sterge'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadProduct,
                      child: Text('Adauga produs'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
