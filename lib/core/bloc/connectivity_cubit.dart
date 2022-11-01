import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paperless_mobile/core/service/connectivity_status.service.dart';
import 'package:injectable/injectable.dart';

@singleton
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityStatusService connectivityStatusService;
  late final StreamSubscription<bool> _sub;

  ConnectivityCubit(this.connectivityStatusService) : super(ConnectivityState.undefined);

  Future<void> initialize() async {
    final bool isConnected = await connectivityStatusService.isConnectedToInternet();
    emit(isConnected ? ConnectivityState.connected : ConnectivityState.notConnected);
    _sub = connectivityStatusService.connectivityChanges().listen((isConnected) {
      emit(isConnected ? ConnectivityState.connected : ConnectivityState.notConnected);
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}

enum ConnectivityState { connected, notConnected, undefined }