import 'package:flutter/material.dart';
import '../../model/model.dart';
import '../../model/objects/comic.dart';
import 'error_dialog.dart';

class ComicCard extends StatelessWidget {
  final Comic comic;

  const ComicCard({Key? key, required this.comic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(245, 245, 220, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    comic.title,
                    style: const TextStyle(
                      color: Color.fromRGBO(25, 25, 112, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 125,
                  height: 190,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        comic.image,
                        fit: BoxFit.cover, // Ensure the image covers the container
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: _buildTooltipMessage(comic),
                  child: IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      if (Model.sharedInstance.isLogged()) {
                        try {
                          Model.sharedInstance.addToCart(comic.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Articolo aggiunto al carrello"),
                            ),
                          );
                        } catch (e) {
                          showErrorDialog(context, e.toString());
                        }
                      } else {
                        showErrorDialog(context, "Accedi per acquistare");
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (Model.sharedInstance.isLogged()) {
                      try {
                        await Model.sharedInstance.addToCart(comic.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Articolo aggiunto al carrello"),
                          ),
                        );
                      } catch (e) {
                        showErrorDialog(context, e.toString());
                      }
                    } else {
                      showErrorDialog(context, "Accedi per acquistare");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
                  ),
                  child: const Text(
                    'Aggiungi al carrello',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildTooltipMessage(Comic comic) {
    return 'Titolo: ${comic.title}\n'
        'Autore: ${comic.author}\n'
        'Editore: ${comic.publisher}\n'
        'Categoria: ${comic.category}\n'
        'Prezzo: ${comic.price}€';
  }
}
