import 'package:flutter/material.dart';
import '../../model/book.dart';
import '../template/book_list_screen.dart';

class BookListPage extends Page {
  final List<Book> books;
  final Function(Book) onBookTappbed;

  const BookListPage({required this.books, required this.onBookTappbed})
      : super(key: const ValueKey('BooksListPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return BooksListScreen(
          books: books,
          onTapped: onBookTappbed,
        );
      },
    );
  }
}
