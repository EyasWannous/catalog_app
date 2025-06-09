import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract class defining the contract for network connectivity information.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Concrete implementation of NetworkInfo using the connectivity_plus package.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  /// Checks if the device has an active internet connection.
  /// It considers all connection types (Wi-Fi, mobile, Ethernet).
  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    // The checkConnectivity() method now returns a List<ConnectivityResult>.
    // We need to check if any of the results indicate actual connectivity.
    return connectivityResult.any((result) => result != ConnectivityResult.none);
  }
}