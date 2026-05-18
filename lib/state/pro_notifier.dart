import 'package:flutter/foundation.dart';

import '../services/iap_service.dart';

class ProNotifier extends ChangeNotifier {
  ProNotifier(this._iap) {
    _iap.addListener(_onIapChanged);
  }

  final IapService _iap;

  bool get isPro => _iap.isPro;
  bool get loading => _iap.loading;
  String? get error => _iap.error;

  void _onIapChanged() => notifyListeners();

  Future<void> purchase() => _iap.purchase();
  Future<void> restore() => _iap.restorePurchases();

  @override
  void dispose() {
    _iap.removeListener(_onIapChanged);
    super.dispose();
  }
}
