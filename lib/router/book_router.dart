import 'package:flutter/material.dart';
import '../model/book.dart';
import '../component/page/book_list_page.dart';
import '../component/page/book_details_page.dart';
import '../component/page/unknown.dart';

enum BookAppPageType {
  unknown,
  loading,
  bookList,
  bookDetail,
}

class BookRoutePath {
  final BookAppPageType pageType;
  final int? bookId;

  BookRoutePath.home()
      : pageType = BookAppPageType.bookList,
        bookId = null;
  BookRoutePath.details(this.bookId) : pageType = BookAppPageType.bookDetail;
  BookRoutePath.unknown()
      : pageType = BookAppPageType.unknown,
        bookId = null;

  bool get isHomePage => pageType == BookAppPageType.bookList;
  bool get isDetailsPage => pageType == BookAppPageType.bookDetail;
  bool get isUnknown => pageType == BookAppPageType.unknown;
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  BookRoutePath path = BookRoutePath.home();
  Book? _selectedBook;
  bool show404 = false;

  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        BookListPage(books: books, onBookTappbed: _handleBookTapped),
        if (show404)
          const UnknownPage()
        else if (_selectedBook != null)
          BookDetailsPage(book: _selectedBook!),
      ],
      onPopPage: _onPopPage,
    );
  }

  @override
  BookRoutePath get currentConfiguration => path;

  @override
  Future<void> setNewRoutePath(BookRoutePath configuration) async {
    path = configuration;
    if (path.isDetailsPage) {
      try {
        _selectedBook = books[path.bookId!];
        show404 = path.isUnknown;
      } catch (e) {
        _selectedBook = null;
        show404 = true;
      }
    } else {
      _selectedBook = null;
      show404 = path.isUnknown;
    }
  }

  void _handleBookTapped(Book book) {
    _selectedBook = book;
    notifyListeners();
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }

    // Update the list of pages by setting _selectedBook to null
    path = BookRoutePath.home();
    _selectedBook = null;
    show404 = false;
    notifyListeners();

    return true;
  }
}

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (null == routeInformation.location) return BookRoutePath.home();

    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return BookRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'book') return BookRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return BookRoutePath.unknown();
      return BookRoutePath.details(id);
    }

    // Handle unknown routes
    return BookRoutePath.unknown();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  RouteInformation? restoreRouteInformation(BookRoutePath path) {
    if (path.isUnknown) {
      return const RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/book/${path.bookId}');
    }
    return null;
  }
}
