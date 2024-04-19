import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fumettologo_frontend/UI/pages/ordini_utente.dart';
import 'package:fumettologo_frontend/UI/pages/registrazione.dart';
import 'carrello.dart';
import 'login.dart';
import '../../model/model.dart';
import '../../model/objects/comic.dart';
import '../widgets/comic_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Comic> comics = [];
  int currentPage = 0;
  int itemsPerPage = 5;
  TextEditingController titleController = TextEditingController();
  bool isLoading = true;
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchComics();
    // Start the auto scrolling
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchComics() async {
    try {
      final retrievedcomics = await Model.sharedInstance.getComics();
      setState(() {
        comics = retrievedcomics;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
    }
  }

  void _selectPage(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(25, 25, 112, 1.0),
          title: const Text(
            'Il Fumettologo',
            style: TextStyle(
              fontFamily: 'Serif',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          actions: [
            Tooltip(
              message: 'Login',
              child: IconButton(
                icon: Icon(Icons.login),
                color: Colors.white70,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
            Tooltip(
              message: 'Registrazione',
              child: IconButton(
                icon: Icon(Icons.person_add),
                color: Colors.white70,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registrazione()),
                  );
                },
              ),
            ),
            Tooltip(
              message: 'Carrello',
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Colors.white70,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Carrello()),
                  );
                },
              ),
            ),
            Tooltip(
              message: 'Ordini',
              child: IconButton(
                icon: Icon(Icons.shopping_bag_outlined),
                color: Colors.white70,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdiniUtente()),
                  );
                },
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Color.fromRGBO(220, 220, 220, 0.7), // Background Color
                child: Image.asset(
                  'images/background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 500,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: titleController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            fetchComics();
                          }
                        },
                        onSubmitted: (String searchTitle) async {
                          List<Comic> searchResults =
                          await Model.sharedInstance
                              .getComicsByTitle(searchTitle);
                          setState(() {
                            comics = searchResults;
                            currentPage = 0;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Titolo',
                          prefixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              titleController.clear();
                              fetchComics();
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search_rounded),
                            onPressed: () async {
                              String searchTitle =
                                  titleController.text;
                              List<Comic> searchResults =
                              await Model.sharedInstance
                                  .getComicsByTitle(searchTitle);
                              setState(() {
                                comics = searchResults;
                                currentPage = 0;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1100,
                  height: 320,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                index == 0
                                    ? 'images/news.jpg'
                                    : index == 1
                                    ? 'images/news3.jpg'
                                    : 'images/news4.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        itemCount: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(3, (int index) {
                          return GestureDetector(
                            onTap: () {
                              _selectPage(index);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0),
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentPage
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: comics.length,
                      itemBuilder: (context, index) {
                        final item = comics[index];
                        return ComicCard(comic: item);
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    Text('Pagina ${_currentPage + 1}'),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
