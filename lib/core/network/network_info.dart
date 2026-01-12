import 'package:connectivity_plus/connectivity_plus.dart';

/// 네트워크 정보 인터페이스
abstract class NetworkInfo {
  /// 네트워크 연결 여부
  Future<bool> get isConnected;

  /// 네트워크 연결 상태 변경 스트림
  Stream<bool> get onConnectivityChanged;
}

/// 네트워크 정보 구현체
class NetworkInfoImpl implements NetworkInfo {
  /// 네트워크 정보 구현체 생성자
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map((result) => result != ConnectivityResult.none);
  }
}
