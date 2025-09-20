import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  final String consumerKey = 'YOUR_CONSUMER_KEY';
  final String consumerSecret = 'YOUR_CONSUMER_SECRET';
  final String shortCode = '174379';
  final String passKey = 'YOUR_PASSKEY';
  final String lipaNaMpesaUrl =
      'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
  final String oauthUrl =
      'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';

  /// Generate Access Token
  Future<String?> generateAccessToken() async {
    final credentials = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

    final response = await http.get(
      Uri.parse(oauthUrl),
      headers: {'Authorization': 'Basic $credentials'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      print('Failed to get access token: ${response.body}');
      return null;
    }
  }

  /// Generate timestamp: yyyyMMddHHmmss
  String _generateTimestamp() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
  }

  /// Initiate STK Push
  Future<void> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required String accountReference,
    required String transactionDesc,
  }) async {
    final token = await generateAccessToken();
    if (token == null) {
      print("Token generation failed.");
      return;
    }

    final timestamp = _generateTimestamp();
    final password = base64Encode(utf8.encode('$shortCode$passKey$timestamp'));

    final body = {
      "BusinessShortCode": shortCode,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amount.toInt(),
      "PartyA": phoneNumber,
      "PartyB": shortCode,
      "PhoneNumber": phoneNumber,
      "CallBackURL": "https://YOUR_CALLBACK_URL_HERE",
      "AccountReference": accountReference,
      "TransactionDesc": transactionDesc
    };

    final response = await http.post(
      Uri.parse(lipaNaMpesaUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('STK Push initiated successfully: ${response.body}');
    } else {
      print('Failed to initiate STK Push: ${response.body}');
    }
  }
}
