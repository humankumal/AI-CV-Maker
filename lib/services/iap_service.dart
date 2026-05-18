import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

class IapService extends ChangeNotifier {
  static const String _productId = AppConstants.proProductId;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  bool _available = false;
  bool _isPro = false;
  bool _loading = false;
  String? _error;

  bool get isPro => _isPro;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> initialize(SharedPreferences prefs) async {
    // Restore persisted Pro status immediately (no IAP latency on launch)
    _isPro = prefs.getBool(AppConstants.proStatusKey) ?? false;

    if (kIsWeb) return;

    _available = await _iap.isAvailable();
    if (!_available) return;

    _sub = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _sub?.cancel(),
      onError: (_) {},
    );
  }

  Future<void> purchase() async {
    if (_isPro) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      if (!_available) throw Exception('Store not available on this device.');

      final ProductDetailsResponse response =
          await _iap.queryProductDetails({_productId});

      if (response.error != null) {
        throw Exception(response.error!.message);
      }
      if (response.productDetails.isEmpty) {
        throw Exception(
            'Product not found. Please check your store configuration.');
      }

      final PurchaseParam param = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      await _iap.buyNonConsumable(purchaseParam: param);
      // Result comes via _onPurchaseUpdates stream
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    if (!_available) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _iap.restorePurchases();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails p in purchases) {
      if (p.productID == _productId) {
        if (p.status == PurchaseStatus.purchased ||
            p.status == PurchaseStatus.restored) {
          await _setPro(true);
        } else if (p.status == PurchaseStatus.error) {
          _error = p.error?.message ?? 'Purchase failed';
          _loading = false;
          notifyListeners();
        }
        if (p.pendingCompletionData != null) {
          await _iap.completePurchase(p);
        }
      }
    }
  }

  Future<void> _setPro(bool value) async {
    _isPro = value;
    _loading = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.proStatusKey, value);
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
