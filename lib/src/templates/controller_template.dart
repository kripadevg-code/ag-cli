String controllerMinimalTemplate(String mod, String cls, String pkg) => '''
import 'package:get/get.dart';
import 'package:$pkg/constants/enums.dart';
import 'package:$pkg/modules/$mod/repos/${mod}_repo.dart';
import 'package:$pkg/utils/utility.dart';
// TODO: import your model
// import 'package:$pkg/modules/$mod/models/${mod}_model.dart';

class ${cls}Controller extends GetxController with ScrollMixin {
  static ${cls}Controller get find => Get.find();

  final ${cls}Repo repo;
  ${cls}Controller({required this.repo});

  // ─── Variables ──────────────────────────────────────────────────────────

  bool _isInitialLoaded = false;
  LoadingStatus _loadingStatus = .done;
  LoadingStatus _isMoreLoading = .done;
  // final List<${cls}Model> _items = [];
  RxBool hasNoMoreData = false.obs;
  int page = 1;
  final int itemPerPage = 10;

  // ─── Getters ─────────────────────────────────────────────────────────────

  bool get isInitialLoaded => _isInitialLoaded;
  bool get hasData => false; // TODO: _items.isNotEmpty
  LoadingStatus get loadingStatus => _loadingStatus;
  LoadingStatus get isMoreLoading => _isMoreLoading;
  // List<${cls}Model> get items => _items;

  // ─── Setters ─────────────────────────────────────────────────────────────

  set loadingStatus(LoadingStatus v) { _loadingStatus = v; update(); }
  set isMoreLoading(LoadingStatus v) { _isMoreLoading = v; update(); }
  set isInitialLoaded(bool v) { _isInitialLoaded = v; update(); }

  // ─── Private Methods ─────────────────────────────────────────────────────

  Future<void> _getItems({bool isLoading = true, bool isMore = false}) async {
    if (hasNoMoreData.value && isMore) return;
    if (isLoading) loadingStatus = .loading;
    if (isMore) {
      isMoreLoading = .loading;
      await Future.delayed(const Duration(seconds: 1));
    }
    try {
      // TODO: final model = await repo.getAll(page: page.toString(), itemPerPage: itemPerPage.toString());
      // if (model != null) {
      //   if (page == 1) _items.clear();
      //   if ((model.results?.length ?? 0) < itemPerPage) hasNoMoreData.value = true;
      //   _items.addAll(model.results ?? []);
      //   update();
      // }
      loadingStatus = .done;
      isMoreLoading = .done;
    } catch (e, st) {
      loadingStatus = .error;
      AppUtility.log('_getItems: \$e st=\$st', tag: 'error');
    }
  }

  Future<void> _onRefresh() async {
    page = 1;
    hasNoMoreData.value = false;
    await _getItems();
  }

  Future<void> _initialize() async {
    loadingStatus = .loading;
    await _getItems(isLoading: false);
    isInitialLoaded = true;
  }

  // ─── Core & Initialization ────────────────────────────────────────────────

  @override
  void onReady() { _initialize(); super.onReady(); }

  @override
  Future<void> onEndScroll() async {
    if (hasNoMoreData.value) return;
    page++;
    await _getItems(isLoading: false, isMore: true);
  }

  @override
  Future<void> onTopScroll() async {}

  // ─── Public Methods ───────────────────────────────────────────────────────

  Future<void> onRefresh() => _onRefresh();
  void onRetryTap() => _initialize();
}
''';

String controllerSearchTemplate(String mod, String cls, String pkg) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:$pkg/constants/enums.dart';
import 'package:$pkg/helpers/query_helper.dart';
import 'package:$pkg/model/tickets/responses/state_model.dart';
import 'package:$pkg/modules/$mod/repos/${mod}_repo.dart';
import 'package:$pkg/routes/route_management.dart';
import 'package:$pkg/services/search_history_service.dart';
import 'package:$pkg/utils/utility.dart';
// TODO: import your model
// import 'package:$pkg/modules/$mod/models/${mod}_model.dart';

class ${cls}Controller extends GetxController with ScrollMixin {
  static ${cls}Controller get find => Get.find();

  final ${cls}Repo repo;
  ${cls}Controller({required this.repo});

  static const String historyKey = '${mod}_search';

  // ─── Variables ──────────────────────────────────────────────────────────

  bool _isInitialLoaded = false;
  bool _isSearchFieldVisible = false;
  bool _isHistoryVisible = false;
  String _lastSearchQuery = '';
  bool _searchFetchedOnce = false;
  String _lastFetchedQuery = '';

  final TextEditingController searchFieldController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 700));

  LoadingStatus _loadingStatus = .done;
  LoadingStatus _isMoreLoading = .done;
  // final List<${cls}Model> _items = [];
  var _topFilterModels = <StateModel>[];
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
  set loadingStatus(LoadingStatus v) { _loadingStatus = v; update(); }
  set isMoreLoading(LoadingStatus v) { _isMoreLoading = v; update(); }
  set isInitialLoaded(bool v) { _isInitialLoaded = v; update(); }
  set isSearchFieldVisible(bool v) {
    _isSearchFieldVisible = v;
    if (v) { _isHistoryVisible = true; searchFocusNode.requestFocus(); }
    update();
  }

  // ─── Search ───────────────────────────────────────────────────────────────

  void _onSearchFieldChanged(String query) {
    _isHistoryVisible = query.trim().isEmpty;
    _searchDebouncer.call(() { _lastSearchQuery = query; update(); });
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
    page = 1; hasNoMoreData.value = false;
    _getItems(canReturn: false);
    update();
  }

  void _onClearSearch() {
    _searchDebouncer.cancel();
    searchFieldController.clear();
    _lastSearchQuery = '';
    _isHistoryVisible = true;
    if (_searchFetchedOnce) {
      _searchFetchedOnce = false; _lastFetchedQuery = '';
      update(); _onRefresh();
    } else { update(); }
  }

  void _onBackPressed() {
    if (!_isSearchFieldVisible) return;
    _searchDebouncer.cancel();
    _isSearchFieldVisible = false; _isHistoryVisible = false;
    _lastSearchQuery = ''; searchFieldController.clear(); searchFocusNode.unfocus();
    final hadFetch = _searchFetchedOnce;
    _searchFetchedOnce = false; _lastFetchedQuery = '';
    if (hadFetch) { page = 1; hasNoMoreData.value = false; _onRefresh(); }
    else { update(); }
  }

  // ─── Data ─────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>>? _buildFilter() {
    if (_isSearchFieldVisible && searchFieldController.text.trim().isNotEmpty) {
      // TODO: return QueryHelper.get${cls}SearchFilterQuery(searchFieldController.text.trim());
    }
    if (_selectedFilter.value?.id == 0) return [];
    // TODO: return QueryHelper.get${cls}StateFilterQuery(_selectedFilter.value?.name);
    return [];
  }

  Future<void> _getOptions() async {
    try {
      // TODO: final options = await repo.getOptions();
      // populate _topFilterModels from options
    } catch (e, st) { AppUtility.log('_getOptions: \$e st=\$st', tag: 'error'); }
  }

  Future<void> _getItems({bool isLoading = true, bool isMore = false, bool canReturn = true}) async {
    if (hasNoMoreData.value && canReturn) return;
    if (isLoading) loadingStatus = .loading;
    if (isMore) { isMoreLoading = .loading; await Future.delayed(const Duration(seconds: 1)); }
    try {
      // TODO: call repo with page, itemPerPage, timeFilter, filter: _buildFilter()
      loadingStatus = .done;
      isMoreLoading = .done;
    } catch (e, st) {
      loadingStatus = .error;
      AppUtility.log('_getItems: \$e st=\$st', tag: 'error');
    }
  }

  void _onTopFilterTap(int index) {
    for (final m in _topFilterModels) { m.isSelected = false; }
    _selectedFilter.value = _topFilterModels[index]..isSelected = true;
    update(); _onRefresh();
  }

  void _onClearTimeFilterTap() { appBarText = null; _timeFilter.value = null; _onRefresh(); }

  Future<void> _goToCustomTimeFilterPage() async {
    final result = await RouteManagement.goToCustomFilterChannelChatPage();
    if (result.item1 == null) return;
    // TODO: handle time filter (see tasks_controller.dart for reference)
    appBarText = result.item2;
    _getItems();
  }

  Future<void> _onRefresh() async { page = 1; hasNoMoreData.value = false; await _getItems(); }

  Future<void> _onRefreshFromOutside() async {
    if (_isSearchFieldVisible) {
      _isSearchFieldVisible = false; _isHistoryVisible = false;
      _lastSearchQuery = ''; _searchFetchedOnce = false; _lastFetchedQuery = '';
      searchFieldController.clear(); searchFocusNode.unfocus(); update();
    }
    await _onRefresh();
  }

  Future<void> _initialize() async {
    loadingStatus = .loading;
    await Future.wait([_getOptions(), _getItems(isLoading: false)]);
    isInitialLoaded = true;
  }

  // ─── Core & Initialization ────────────────────────────────────────────────

  @override
  void onReady() { _initialize(); super.onReady(); }

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
    page++; await _getItems(isLoading: false, isMore: true);
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
''';
