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

@immutable
class BookRoutePath {
  final BookAppPageType pageType;
  final int? bookId;

  const BookRoutePath.home()
      : pageType = BookAppPageType.bookList,
        bookId = null;
  const BookRoutePath.details(this.bookId)
      : pageType = BookAppPageType.bookDetail;
  const BookRoutePath.unknown()
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

  BookRoutePath path = const BookRoutePath.home();
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
  BookRoutePath get currentConfiguration {
    if (show404) {
      return const BookRoutePath.unknown();
    } else if (null != _selectedBook) {
      return BookRoutePath.details(books.indexOf(_selectedBook!));
    } else {
      return const BookRoutePath.home();
    }
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath configuration) async {
    path = configuration;
    if (configuration.isHomePage) {
      _selectedBook = null;
      show404 = false;
    } else if (configuration.isDetailsPage) {
      try {
        _selectedBook = books[configuration.bookId!];
        show404 = configuration.isUnknown;
      } catch (e) {
        path = const BookRoutePath.unknown();
        _selectedBook = null;
        show404 = true;
      }
    } else {
      _selectedBook = null;
      show404 = configuration.isUnknown;
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
    if (null == routeInformation.location) return const BookRoutePath.home();

    final uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return const BookRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'book') return const BookRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return const BookRoutePath.unknown();
      return BookRoutePath.details(id);
    }

    // Handle unknown routes
    return const BookRoutePath.unknown();
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
