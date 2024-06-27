import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secretKey =
      "sk_test_51PVwGbRrNVLnHseDKkuyuSu1ZxYzHHLjmUP49637ZdL5Du86Ub0B6wBxJJkJrxlfZXkVQMSaMRTfdHBvvqbRoGJY00k3nB3R2x";
  static String publishableKey =
      "pk_test_51PVwGbRrNVLnHseDTyY30e8LszHFg8OWo6LwTSS59TQxgucXVyMMaNS02qrcijP8LoyIP88CwwDPole0CRsHAU0U00UYyUBXeu";

  static Future<String> createCheckoutSession(
      List<dynamic> productItems, int totalAmount) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

    String lineItems = "";
    int index = 0;

    productItems.forEach((val) {
      var productPrice = (val["productPrice"] * 100).round().toString();
      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val['productName']}";
      lineItems += "&line_items[$index][price_data][unit_amount]=$productPrice";
      lineItems += "&line_items[$index][price_data][currency]=RON";
      lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
      index++;
    });

    final response = await http.post(
      url,
      body:
          'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)["id"];
    } else {
      throw Exception("Failed to create checkout session: ${response.body}");
    }
  }

  static Future<void> stripePaymentCheckout(
    List<dynamic> productItems,
    int subTotal,
    BuildContext context,
    bool mounted, {
    required Function onSuccess,
    required Function onCancel,
    required Function onError,
  }) async {
    try {
      final String sessionId =
          await createCheckoutSession(productItems, subTotal);

      final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: publishableKey,
        successUrl: "https://checkout.stripe.dev/success",
        canceledUrl: "https://checkout.stripe.dev/cancel",
      );

      if (mounted) {
        result.when(
          redirected: () => print('Redirected Successfully'),
          success: () => onSuccess(),
          canceled: () => onCancel(),
          error: (e) => onError(e), // Pass the error argument
        );
      }
    } catch (e) {
      onError(e); // Pass the error argument
    }
  }
}
