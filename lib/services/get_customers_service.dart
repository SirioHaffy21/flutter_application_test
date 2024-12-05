import 'package:flutter/material.dart';
import 'package:flutter_application_test/services/ApiService.dart';

class CustomerListPage extends StatelessWidget {
  final ApiService apiService;
  final String token;

  const CustomerListPage({Key? key, required this.apiService, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer List')),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getCustomers(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No customers found.'));
          }

          final customers = snapshot.data!;
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer['CUSTOMER_NAME']),
                subtitle: Text('Code: ${customer['CUSTOMER_CODE']}'),
              );
            },
          );
        },
      ),
    );
  }
}
