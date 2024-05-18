import 'package:flutter/material.dart';
import 'package:fumettologo_frontend/UI/widgets/comic_card.dart';

import '../../model/model.dart';
import '../../model/objects/comic.dart';

class RisultatiPage extends StatefulWidget {
  final String title;
  final String author;
  final String publisher;
  final String category;
  final String orderBy;

  const RisultatiPage(
      this.title,
      this.author,
      this.publisher,
      this.category,
      this.orderBy, {
        Key? key,
      }) : super(key: key);

  @override
  _RisultatiPageState createState() => _RisultatiPageState();
}

class _RisultatiPageState extends State<RisultatiPage> {
  List<Comic> comics = [];
  int currentPage = 0;
  int itemsPerPage = 10;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      final retrivedCards = await Model.sharedInstance.filter(
        title: widget.title,
        author: widget.author,
        publisher: widget.publisher,
        category: widget.category,
        sortBy: widget.orderBy,
        pageNumber: currentPage,
      );
      setState(() {
        comics = retrivedCards;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void previousPage() async {
    if (currentPage > 0) {
      final List<Comic> retrievedBooks = await Model.sharedInstance.filter(
        title: widget.title,
        author: widget.author,
        publisher: widget.publisher,
        category: widget.category,
        sortBy: widget.orderBy,
        pageNumber: currentPage - 1,
      );
      setState(() {
        currentPage -= 1;
        comics = retrievedBooks;
      });
    }
  }

  void nextPage() async {
    final List<Comic> retrievedCards = await Model.sharedInstance.filter(
      title: widget.title,
      author: widget.author,
      publisher: widget.publisher,
      category: widget.category,
      sortBy: widget.orderBy,
      pageNumber: currentPage + 1,
    );
    if (retrievedCards.isNotEmpty) {
      setState(() {
        currentPage += 1;
        comics = retrievedCards;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(25, 25, 112, 1.0),
        iconTheme: IconThemeData(color: Colors.white70),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
            opacity: 0.9,
          ),
        ),
        child:isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  icon: const Icon(Icons.arrow_back),
                  onPressed: previousPage,
                ),
                Text('Pagina: ${currentPage + 1}'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: nextPage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
