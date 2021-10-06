import 'package:flutter/material.dart';
import '../model/book.dart';
import '../component/page/book_list_page.dart';
import '../component/page/book_details_page.dart';

class BooksApp extends StatefulWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  Book? _selectedBook;

  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      home: Navigator(
        pages: [
          BookListPage(books: books, onBookTappbed: _handleBookTapped),
          if (_selectedBook != null) BookDetailsPage(book: _selectedBook!)
        ],
        onPopPage: _handlePopPage,
      ),
    );
  }

  void _handleBookTapped(Book book) {
    setState(() {
      _selectedBook = book;
    });
  }

  bool _handlePopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    // Update the list of pages by setting _selectedBook to null
    setState(() {
      _selectedBook = null;
    });

    return true;
  }
}
