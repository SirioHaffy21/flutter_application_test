import 'package:flutter/material.dart';
import 'package:flutter_application_test/services/ApiService.dart';

class CustomerListPage extends StatefulWidget {
  final ApiService apiService;
  final String token;

  // ignore: use_super_parameters
  const CustomerListPage({Key? key, required this.apiService, required this.token}):super(key: key);
  
  @override
  // ignore: library_private_types_in_public_api
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerListPage>{
  //
  late Future<List<dynamic>> customersFuture;
  
  Future<List<dynamic>> fetchCustomers() async {
    final customerData = await widget.apiService.getCustomers(widget.token);
    if(widget.token.isNotEmpty){
      if(customerData.isNotEmpty){
        return customerData;
      }else{
        throw Exception("Empty");
      }
    }else{
      throw Exception("Invalid token");
    }
  }

  @override
  void initState(){
    super.initState();
    customersFuture = fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer List')),
      body: FutureBuilder<List<dynamic>>(
        future: customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final customers = snapshot.data!;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(customer['CUSTOMER_NAME']),
                  subtitle: Text("Code: ${customer['CUSTOMER_CODE']}"),
                );
              },
            );
          } else {
            return Center(child: Text("No customers found."));
          }
        },
      ),
    );
  }
}

