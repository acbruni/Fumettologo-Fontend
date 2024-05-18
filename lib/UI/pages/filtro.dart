import 'package:flutter/material.dart';
import 'package:fumettologo_frontend/UI/pages/risultati.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  String orderBy = 'Titolo A-Z';
  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                width: 450,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 220, 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Color.fromRGBO(25, 25, 112, 1.0),
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Titolo',
                              hintText: 'Titolo',
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                              fillColor: Colors.white70,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: authorController,
                            decoration: const InputDecoration(
                              labelText: 'Autore',
                              hintText: 'Autore',
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                              fillColor: Colors.white70,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: publisherController,
                            decoration: const InputDecoration(
                              labelText: 'Casa Editrice',
                              hintText: 'Casa Editrice',
                              border: const OutlineInputBorder(),
                              prefixIcon: Icon(Icons.book_outlined),
                              fillColor: Colors.white70,
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Ordina per:", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(25, 25, 112, 1.0))),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Color.fromRGBO(245, 245, 220, 1.0), // Colore del menu
                        value: orderBy,
                        style: TextStyle(color: Color.fromRGBO(25, 25, 112, 1.0)), // Colore delle voci del menu
                        onChanged: (String? newValue) {
                          setState(() {
                            orderBy = newValue!;
                          });
                        },
                        items: <String>[
                          'Titolo A-Z',
                          'Titolo Z-A',
                          'Prezzo crescente',
                          'Prezzo decrescente',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  RisultatiPage(
                                      titleController.text,
                                      authorController.text,
                                      publisherController.text,
                                      categoryController.text,
                                      orderBy
                                  )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
                          ),
                          child: const Text(
                            "Cerca",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
