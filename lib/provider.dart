import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Use this at enry
// ChangeNotifierProvider(
// create: (context) => LibraryModel(),
// child: BookListApp(),)

enum ListType { Cart, Books }

class BookListApp extends StatefulWidget {
  const BookListApp({Key? key}) : super(key: key);

  @override
  State<BookListApp> createState() => _BookListAppState();
}

class _BookListAppState extends State<BookListApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito'),
      home: BookList(),
    );
  }
}

class BookList extends StatelessWidget {
  BookList({Key? key}) : super(key: key);
  final List<Book> _books = [
    Book(title: 'Left hand of darkness', author: 'Ursala k b'),
    Book(title: 'A wrong trip', author: 'silas k koske'),
    Book(title: 'Kinder', author: 'Nobody is kind')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.greenAccent),
        title: Text(
          'Available books',
          style: TextStyle(color: Colors.greenAccent),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (builder) => Library(),
              ),
            ),
            icon: Icon(
              Icons.shopping_cart_rounded,
              size: 35,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          for (var book in _books)
            BookListTiles(book: book, context: context, isCart: false)
        ],
      ),
    );
  }
}

class BookListTiles extends StatelessWidget {
  const BookListTiles({
    Key? key,
    required this.book,
    required this.context,
    required this.isCart,
  }) : super(key: key);

  final Book book;
  final BuildContext context;
  final bool isCart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10.0),
      tileColor: Colors.white,
      title: Text(
        book.title,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      leading: Icon(
        !isCart ? Icons.library_books : Icons.local_library,
        size: 55,
        color: Colors.orange,
      ),
      subtitle: Text(
        book.author,
        style: TextStyle(color: Colors.black54),
      ),
      trailing: IconButton(
          onPressed: () => !isCart
              ? Provider.of<LibraryModel>(
                  context,
                  listen: false,
                ).addBooksToList(book)
              : Provider.of<LibraryModel>(context, listen: false)
                  .removeBookFromList(book),
          padding: const EdgeInsets.all(0.0),
          icon: Icon(
            !isCart ? Icons.add : Icons.remove_circle_outline,
            color: !isCart ? Colors.greenAccent : Colors.redAccent,
            size: 30,
          )),
    );
  }
}

class Book {
  final String title, author;
  Book({required this.title, required this.author});
}

class LibraryModel extends ChangeNotifier {
  final List<Book> _books = [];

  UnmodifiableListView<Book> get books => UnmodifiableListView(_books);

  void addBooksToList(Book book) {
    if (!books.contains(book)) {
      _books.add(book);
      notifyListeners();
    }
  }

  void removeBookFromList(Book book) {
    _books.remove(book);
    notifyListeners();
  }

  void removeAllBooks() {
    _books.clear();
    notifyListeners();
  }
}

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.greenAccent),
          elevation: 0.5,
          title: Text(
            'Library',
            style: TextStyle(color: Colors.greenAccent),
          ),
          actions: [
            IconButton(
              onPressed: () => Provider.of<LibraryModel>(context, listen: false)
                  .removeAllBooks(),
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
                size: 35,
              ),
            )
          ],
        ),
        body: Consumer<LibraryModel>(
          builder: (context, books, child) {
            return ListView(
              children: [
                for (var book in books.books)
                  BookListTiles(
                    book: book,
                    context: context,
                    isCart: true,
                  )
              ],
            );
          },
        ));
  }
}
