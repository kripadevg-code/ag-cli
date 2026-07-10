// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:example/constants/enums.dart';
import 'package:example/helpers/query_helper.dart';
import 'package:example/model/common/state_model.dart';
import 'package:example/modules/orders/repos/orders_repo.dart';
import 'package:example/routes/route_management.dart';
import 'package:example/core/services/search_history_service.dart';
import 'package:example/utils/utility.dart';
// TODO: import your model
// import 'package:example/modules/orders/models/orders_model.dart';

class OrdersController extends GetxController with ScrollMixin {
  static OrdersController get find => Get.find();

  final OrdersRepo repo;
  OrdersController({required this.repo});

  static const String historyKey = 'orders_search';

  // ─── Variables ──────────────────────────────────────────────────────────

  bool _isInitialLoaded = false;
  bool _isSearchFieldVisible = false;
  bool _isHistoryVisible = false;
  // ignore: unused_field
  String _lastSearchQuery = '';
  bool _searchFetchedOnce = false;
  String _lastFetchedQuery = '';

  final TextEditingController searchFieldController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 700));

  LoadingStatus _loadingStatus = LoadingStatus.done;
  LoadingStatus _isMoreLoading = LoadingStatus.done;
  // final List<OrdersModel> _items = [];
  final List<StateModel> _topFilterModels = [];
  final Rxn<StateModel> _selectedFilter = Rxn(StateModel(id: 0, name: 'All', isSelected: true));
  RxBool hasNoMoreData = false.obs;
  final Rxn<Map<String, dynamic>?> _timeFilter = Rxn(null);
  final Rxn<String> _filterAppBarText = Rxn(null);
  int page = 1;
  final int itemPerPage = 10;

  // ─── Getters ─────────────────────────────────────────────────────────────

  bool get isInitialLoaded => _isInitialLoaded;
  bool get isSearchFieldVisible => _isSearchFieldVisible;
  bool get isHistoryVisible => _isHistoryVisible;
  // TODO: replace with filtered items list
  bool get hasData => false;
  LoadingStatus get loadingStatus => _loadingStatus;
  LoadingStatus get isMoreLoading => _isMoreLoading;
  List<StateModel> get topFilterModels => _topFilterModels;
  Rxn<StateModel> get filterModelText => _selectedFilter;
  Rxn<String> get filterAppBarText => _filterAppBarText;

  // ─── Setters ─────────────────────────────────────────────────────────────

  set appBarText(String? v) => _filterAppBarText.value = v;
  set loadingStatus(LoadingStatus v) {
    _loadingStatus = v;
    update();
  }

  set isMoreLoading(LoadingStatus v) {
    _isMoreLoading = v;
    update();
  }

  set isInitialLoaded(bool v) {
    _isInitialLoaded = v;
    update();
  }

  set isSearchFieldVisible(bool v) {
    _isSearchFieldVisible = v;
    if (v) {
      _isHistoryVisible = true;
      searchFocusNode.requestFocus();
    }
    update();
  }

  // ─── Search ───────────────────────────────────────────────────────────────

  void _onSearchFieldChanged(String query) {
    _isHistoryVisible = query.trim().isEmpty;
    _searchDebouncer.call(() {
      _lastSearchQuery = query;
      update();
    });
  }

  void _onSubmit(String query) {
    final q = query.trim();
    if (q.length < 3) return;
    if (q == _lastFetchedQuery && _searchFetchedOnce) return; // duplicate guard
    _isHistoryVisible = false;
    _lastSearchQuery = '';
    _lastFetchedQuery = q;
    _searchFetchedOnce = true;
    SearchHistoryService.add(historyKey, q);
    page = 1;
    hasNoMoreData.value = false;
    _getItems(canReturn: false);
    update();
  }

  void _onClearSearch() {
    _searchDebouncer.cancel();
    searchFieldController.clear();
    _lastSearchQuery = '';
    _isHistoryVisible = true;
    if (_searchFetchedOnce) {
      _searchFetchedOnce = false;
      _lastFetchedQuery = '';
      update();
      _onRefresh();
    } else {
      update();
    }
  }

  void _onBackPressed() {
    if (!_isSearchFieldVisible) return;
    _searchDebouncer.cancel();
    _isSearchFieldVisible = false;
    _isHistoryVisible = false;
    _lastSearchQuery = '';
    searchFieldController.clear();
    searchFocusNode.unfocus();
    final hadFetch = _searchFetchedOnce;
    _searchFetchedOnce = false;
    _lastFetchedQuery = '';
    if (hadFetch) {
      page = 1;
      hasNoMoreData.value = false;
      _onRefresh();
    } else {
      update();
    }
  }

  // ─── Data ─────────────────────────────────────────────────────────────────

  // ignore: unused_element
  List<Map<String, dynamic>>? _buildFilter() {
    if (_isSearchFieldVisible && searchFieldController.text.trim().isNotEmpty) {
      // TODO: return QueryHelper.getOrdersSearchFilterQuery(searchFieldController.text.trim());
    }
    if (_selectedFilter.value?.id == 0) return [];
    // TODO: return QueryHelper.getOrdersStateFilterQuery(_selectedFilter.value?.name);
    return [];
  }

  Future<void> _getOptions() async {
    try {
      // TODO: final options = await repo.getOptions();
      // populate _topFilterModels from options
    } catch (e, st) {
      AppUtility.log('_getOptions: $e st=$st', tag: 'error');
    }
  }

  Future<void> _getItems({bool isLoading = true, bool isMore = false, bool canReturn = true}) async {
    if (hasNoMoreData.value && canReturn) return;
    if (isLoading) loadingStatus = LoadingStatus.loading;
    if (isMore) {
      isMoreLoading = LoadingStatus.loading;
      await Future.delayed(const Duration(seconds: 1));
    }
    try {
      // TODO: call repo with page, itemPerPage, timeFilter, filter: _buildFilter()
      loadingStatus = LoadingStatus.done;
      isMoreLoading = LoadingStatus.done;
    } catch (e, st) {
      loadingStatus = LoadingStatus.error;
      AppUtility.log('_getItems: $e st=$st', tag: 'error');
    }
  }

  void _onTopFilterTap(int index) {
    for (final m in _topFilterModels) {
      m.isSelected = false;
    }
    _selectedFilter.value = _topFilterModels[index]..isSelected = true;
    update();
    _onRefresh();
  }

  void _onClearTimeFilterTap() {
    appBarText = null;
    _timeFilter.value = null;
    _onRefresh();
  }

  Future<void> _goToCustomTimeFilterPage() async {
    // TODO: final result = await RouteManagement.goToCustomFilterChannelChatPage();
    // if (result.item1 == null) return;
    // appBarText = result.item2;
    // _getItems();
  }

  Future<void> _onRefresh() async {
    page = 1;
    hasNoMoreData.value = false;
    await _getItems();
  }

  Future<void> _onRefreshFromOutside() async {
    if (_isSearchFieldVisible) {
      _isSearchFieldVisible = false;
      _isHistoryVisible = false;
      _lastSearchQuery = '';
      _searchFetchedOnce = false;
      _lastFetchedQuery = '';
      searchFieldController.clear();
      searchFocusNode.unfocus();
      update();
    }
    await _onRefresh();
  }

  Future<void> _initialize() async {
    loadingStatus = LoadingStatus.loading;
    await Future.wait([_getOptions(), _getItems(isLoading: false)]);
    isInitialLoaded = true;
  }

  // ─── Core & Initialization ────────────────────────────────────────────────

  @override
  void onReady() {
    _initialize();
    super.onReady();
  }

  @override
  void onClose() {
    _searchDebouncer.cancel();
    searchFieldController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  @override
  Future<void> onEndScroll() async {
    if (hasNoMoreData.value) return;
    page++;
    await _getItems(isLoading: false, isMore: true);
  }

  @override
  Future<void> onTopScroll() async {}

  // ─── Public Methods ───────────────────────────────────────────────────────

  Future<void> onRefresh() => _onRefreshFromOutside();
  void onRetryTap() => _initialize();
  void onTopFilterTap(int i) => _onTopFilterTap(i);
  void onClearTimeFilterTap() => _onClearTimeFilterTap();
  void goToCustomTimeFilterPage() => _goToCustomTimeFilterPage();
  void onSearchFieldChanged(String q) => _onSearchFieldChanged(q);
  void onSubmit(String q) => _onSubmit(q);
  void onClearSearch() => _onClearSearch();
  void onBackPressed() => _onBackPressed();
  void onHistoryItemTap(String q) {
    searchFieldController.text = q;
    _lastSearchQuery = '';
    _onSubmit(q);
  }
}
