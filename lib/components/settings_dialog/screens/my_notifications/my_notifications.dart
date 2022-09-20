import 'package:cs_mobile/screens/questions_screen/tabs/widgets/error_indicator.dart';
import 'package:cs_mobile/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:cs_mobile/models/notification.dart';



class MyNotifications extends ConsumerStatefulWidget {
  final userAuth;
  const MyNotifications(this.userAuth, {Key? key}) : super(key: key);

  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

class _MyNotificationsState extends ConsumerState<MyNotifications> {
  static const _pageSize = 5;

  final PagingController<int, NotificationModel> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
     _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(widget.userAuth ,pageKey);
    });
    super.initState();
  }
  Future<void> _fetchPage(auth,int pageKey, ) async {
    try {
      final newItems = await fetchNotifications(auth ,pageKey,);
      final isLastPage = newItems.length < _pageSize;
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
    return Material(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,),
              child: PagedListView<int, NotificationModel>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
                      firstPageErrorIndicatorBuilder:(context) => ErrorIndicator(
                  onTryAgain: () => _pagingController.refresh(),
                ),
                      itemBuilder: (context, item, index) {
                        return Text(item.title);
                      },
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}