import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/providers/order_details_provider.dart';
import 'package:ecommerce_app/widgets/CartProvider.dart'; // Import CartProvider

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _formKey = GlobalKey<FormState>();
  String _streetName = '';
  String _city = '';
  String _country = '';
  String _postalCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date de livrare'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Strada'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _streetName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Oras'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tara'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
                onSaved: (value) {
                  _country = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cod Postal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _postalCode = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Provider.of<AddressProvider>(context, listen: false)
                        .addAddress(
                      streetName: _streetName,
                      city: _city,
                      country: _country,
                      postalCode: _postalCode,
                    );

                    try {
                      final orderId = await Provider.of<OrderProvider>(context,
                              listen: false)
                          .createOrder();
                      await Provider.of<OrderDetailsProvider>(context,
                              listen: false)
                          .createOrderDetails(orderId);
                      await Provider.of<CartProvider>(context, listen: false)
                          .clearCart();
                      Navigator.pop(context);
                    } catch (e) {
                      // Handle error
                      print(e);
                    }
                  }
                },
                child: Text('Continua'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
