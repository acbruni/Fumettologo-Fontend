import 'package:flutter/material.dart';
import '../../model/model.dart';
import '../../model/objects/order.dart';

class OrdiniUtente extends StatefulWidget {
  const OrdiniUtente({Key? key});

  @override
  _OrdiniUtenteState createState() => _OrdiniUtenteState();
}

class _OrdiniUtenteState extends State<OrdiniUtente> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    try {
      final retrievedOrders = await Model.sharedInstance.getUserOrders();
      setState(() {
        orders = retrievedOrders;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
        title: const Text(
          'Ordini',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white70),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(220, 220, 220, 1.0),
          ),
          Positioned.fill(
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : orders.isEmpty
                ? Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.blue.shade900, width: 2.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.blue.shade900,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Nessun ordine trovato",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(4.0),
                  child: ListTile(
                    title: Text('Ordine: ${order.id}'),
                    subtitle: Text(
                        'Creato il: ${order.createTime.day}/${order.createTime.month}/${order.createTime.year}'),
                    trailing: Text(
                      'Totale: ${order.total.toStringAsFixed(2)}€',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
