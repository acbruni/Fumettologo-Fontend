import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../../model/objects/cart_detail.dart';
import '../../model/objects/user.dart';
import '../widgets/error_dialog.dart';

class Carrello extends StatefulWidget {
  const Carrello({Key? key}) : super(key: key);

  @override
  _CarrelloState createState() => _CarrelloState();
}

class _CarrelloState extends State<Carrello> {
  bool isLogged = true;
  User? user;
  List<CartDetail> cartDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    if (isLogged) {
      fetchUser();
      fetchCartDetails();
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      bool loggedIn = Model.sharedInstance.isLogged();
      setState(() {
        isLogged = loggedIn;
      });
    } catch (e) {
      throw ('Error checking login status: $e');
    }
  }

  Future<void> fetchUser() async {
    try {
      final retrievedUser = await Model.sharedInstance.fetchUserProfile();
      setState(() {
        user = retrievedUser;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> fetchCartDetails() async {
    try {
      final retrievedCartDetails = await Model.sharedInstance.getCartDetails();
      setState(() {
        cartDetails = retrievedCartDetails;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var item in cartDetails) {
      total += item.subTotal;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white70),
        backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
        title: const Text(
          'Carrello',
          style: TextStyle(
            fontFamily: 'Serif',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ),
      body: isLogged
          ? buildLoggedInView()
          : buildLoggedOutView(),
    );
  }

  Widget buildLoggedInView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Color.fromRGBO(220, 220, 220, 1.0),
            child: ListView.builder(
              itemCount: cartDetails.length,
              itemBuilder: (context, index) {
                final item = cartDetails[index];
                return Card(
                  color: Colors.white,
                  borderOnForeground: true,
                  margin: const EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: IconButton(
                      tooltip: "Rimuovi",
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        try {
                          await Model.sharedInstance.removeItem(item.id);
                          fetchCartDetails();
                        } catch (e) {
                          fetchCartDetails();
                          showErrorDialog(context, e.toString());
                        }
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.comic.title),
                            Text(
                              "Prezzo: ${item.comic.price}€",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () async {
                                    if (item.quantity == 1) {
                                      try {
                                        await Model.sharedInstance
                                            .removeItem(item.id);
                                        fetchCartDetails();
                                      } catch (e) {
                                        fetchCartDetails();
                                        showErrorDialog(
                                            context, e.toString());
                                      }
                                    } else {
                                      int quantity = item.quantity - 1;
                                      try {
                                        await Model.sharedInstance
                                            .updateItemQuantity(
                                            item.id, quantity);
                                        fetchCartDetails();
                                      } catch (e) {
                                        fetchCartDetails();
                                        showErrorDialog(
                                            context, e.toString());
                                      }
                                    }
                                  },
                                ),
                                Container(
                                    color: Colors.white,
                                    child: Text("${item.quantity}")),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    int quantity = item.quantity + 1;
                                    try {
                                      await Model.sharedInstance
                                          .updateItemQuantity(
                                          item.id, quantity);
                                      fetchCartDetails();
                                    } catch (e) {
                                      fetchCartDetails();
                                      showErrorDialog(
                                          context, e.toString());
                                    }
                                  },
                                ),
                              ],
                            ),
                            Text(
                                "Totale articolo: ${item.subTotal.toStringAsFixed(2)}€")
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          width: 300, // Width increased
          color: Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Riepilogo Carrello',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(25, 25, 112, 1.0),
                  ),
                ),
              ),
              Divider(), // Divider added
              Expanded(
                child: ListView.builder(
                  itemCount: cartDetails.length,
                  itemBuilder: (context, index) {
                    final item = cartDetails[index];
                    return ListTile(
                      title: Text(item.comic.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantità: ${item.quantity}'),
                          Text('Prezzo: ${item.comic.price}€'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Divider(), // Another divider added
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Importo totale: ${calculateTotalPrice().toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(25, 25, 112, 1.0),
                  ),
                ),
              ),
              SizedBox(height: 16), // Added spacing
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (cartDetails.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nessun articolo nel carrello.'),
                        ),
                      );
                    } else {
                      try {
                        await Model.sharedInstance.checkout(cartDetails);
                        fetchCartDetails();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('Il tuo ordine è stato accettato'),
                          ),
                        );
                      } catch (e) {
                        fetchCartDetails();
                        showErrorDialog(context, e.toString());
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
                  ),
                  child: const Text(
                    'Completa Acquisto',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (cartDetails.isNotEmpty) {
                      try {
                        await Model.sharedInstance.clearCart();
                        fetchCartDetails();
                      } catch (e) {
                        fetchCartDetails();
                        showErrorDialog(context, e.toString());
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nessun articolo nel carrello.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    'Svuota Carrello',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoggedOutView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade900, width: 2.0),
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
              "Effettua il login per accedere al carrello",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
