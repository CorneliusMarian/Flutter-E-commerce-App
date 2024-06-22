import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/providers/products_provider.dart';

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
  String? _imageUrl;

  CategoriesProvider _categoriesProvider = CategoriesProvider();
  ProductsProvider _productsProvider = ProductsProvider();

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.blue),
                title: Text('Gallery'),
                onTap: () {
                  // Implement gallery picker logic here
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.remove_circle, color: Colors.red),
                title: Text('Remove'),
                onTap: () {
                  setState(() {
                    _imageUrl = null;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
          imageUrl: _imageUrl ?? '',
          price: double.parse(_priceController.text),
          stock: int.parse(_qtyController.text),
        );

        // Clear the form
        _titleController.clear();
        _priceController.clear();
        _qtyController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategory = null;
          _imageUrl = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected category not found.')),
        );
      }
    } else {
      // Show an error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields except image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload a new product'),
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
                  onTap: _showImagePickerDialog,
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
                            'Pick Product image',
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
                    return Text('Error loading categories');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No categories available');
                  }

                  List<DropdownMenuItem<String>> categoryItems = snapshot.data!
                      .map((category) => DropdownMenuItem<String>(
                            value: category['name'],
                            child: Text(category['name']),
                          ))
                      .toList();

                  return DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select Category'),
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
                  labelText: 'Product Title',
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
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Product description',
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
                          _imageUrl = null;
                        });
                      },
                      child: Text('Clear'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadProduct,
                      child: Text('Upload Product'),
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
