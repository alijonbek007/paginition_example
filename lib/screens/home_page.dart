import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination_example/models/photos_model.dart';
import 'package:pagination_example/service/photos_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _pageSize = 10;

  final PagingController<int, PhotoModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<PhotoModel> newItems =
          await ServicePhotos.getPhotos(pageKey, _pageSize);
      final bool isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Paginition'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PagedListView<int, PhotoModel>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<PhotoModel>(
            itemBuilder: (context, item, index) => Text(
              item.title.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
