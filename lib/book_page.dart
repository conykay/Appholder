//book method

import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  const Book(this.title, this.author);
}

class BookApp extends StatefulWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  State<BookApp> createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {
  @override
  void initState() {
    super.initState();
  }

  var _selectedBook;
  bool show404 = false;
  List<Book> books = [
    Book('Left hand of darkness', 'Ursala k b'),
    Book('A wrong trip', 'silas k koske'),
    Book('Kinder', 'Nobody is kind')
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('BookListPage'),
            child: BookListScreen(
              books: books,
              onTapped: _handleBookTapped,
            ),
          ),
          if (_selectedBook != null) BookDetailsPage(book: _selectedBook),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          //update list of pages by setting _selectedBook to null
          setState(() {
            _selectedBook = null;
          });
          return true;
        },
      ),
    );
  }

  void _handleBookTapped(Book book) {
    setState(() {
      _selectedBook = book;
    });
  }
}

class BookListScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onTapped;

  const BookListScreen({required this.books, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => onTapped(book),
            )
        ],
      ),
    );
  }
}

class BookDetailsPage extends Page {
  final book;
  BookDetailsPage({this.book}) : super(key: ValueKey(book));

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (context, animation, animation2) {
          final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero);
          final curveTween = CurveTween(curve: Curves.easeInOut);
          return SlideTransition(
            position: animation.drive(curveTween).drive(tween),
            child: BooksDetailScreen(
              book: book,
            ),
          );
        });
  }
}

class BooksDetailScreen extends StatelessWidget {
  final book;
  const BooksDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (book != null) ...[
              Text(
                book.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                book.author,
                style: Theme.of(context).textTheme.subtitle1,
              )
            ]
          ],
        ),
      ),
    );
  }
}
