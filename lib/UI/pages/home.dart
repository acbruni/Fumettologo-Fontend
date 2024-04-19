import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fumettologo_frontend/UI/pages/ordini_utente.dart';
import 'package:fumettologo_frontend/UI/pages/registrazione.dart';
import 'carrello.dart';
import 'login.dart';
import '../../model/model.dart';
import '../../model/objects/comic.dart';
import '../widgets/comic_card.dart';
import '../widgets/scroll.dart';

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
  PageController _newsPageController = PageController();
  int _currentNewsPage = 0;

  @override
  void initState() {
    super.initState();
    fetchComics();
    // Start auto scrolling of news every 5 seconds
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentNewsPage < 2) {
        _currentNewsPage++;
      } else {
        _currentNewsPage = 0;
      }
      if (_newsPageController.hasClients) {
        _newsPageController.animateToPage(
          _currentNewsPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchComics() async {
    try {
      final retrievedComics = await Model.sharedInstance.getComics();
      setState(() {
        comics = retrievedComics;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
    }
  }

  void previousPage() async {
    if (currentPage > 0) {
      final List<Comic> retrievedComics;
      if (titleController.text == '') {
        retrievedComics =
        await Model.sharedInstance.getComics(pageNumber: currentPage - 1);
      } else {
        retrievedComics = await Model.sharedInstance.getComicsByTitle(
            titleController.text, pageNumber: currentPage - 1);
      }
      setState(() {
        currentPage -= 1;
        comics = retrievedComics;
      });
    }
  }

  void nextPage() async {
    final List<Comic> retrievedComics;
    if (titleController.text == '') {
      retrievedComics =
      await Model.sharedInstance.getComics(pageNumber: currentPage + 1);
    } else {
      retrievedComics = await Model.sharedInstance.getComicsByTitle(
          titleController.text, pageNumber: currentPage + 1);
    }
    if (retrievedComics.isNotEmpty) {
      setState(() {
        currentPage += 1;
        comics = retrievedComics;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(220, 220, 220, 1.0),
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
            ? const Center(child: CircularProgressIndicator())
            : Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background.png'),
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
                    child: PageView(
                      controller: _newsPageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentNewsPage = page;
                        });
                      },
                      children: const [
                        NewsImage(imagePath: 'images/news.jpg'),
                        NewsImage(imagePath: 'images/news3.jpg'),
                        NewsImage(imagePath: 'images/news5.jpg'),
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
                ],
              ),
              Positioned(
                left: 8.0,
                top: 530.0,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: previousPage,
                ),
              ),
              Positioned(
                right: 8.0,
                top: 530.0,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: nextPage,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'images/logo2.png',
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
