import 'package:bloc/bloc.dart';

import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_event.dart';
import 'package:depi_graduation_project/bloc/investor%20request/investor_requests_state.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class InvestorRequestsBloc
    extends Bloc<InvestorRequestsEvent, InvestorRequestsState> {
  final RequestFirestoreService requestService;

  InvestorRequestsBloc({required this.requestService})
      : super(LoadingInvestorRequests()) {
    on<LoadInvestorRequests>((event, emit) async {
      emit(LoadingInvestorRequests());
      try {
        final requests = await requestService.getRequests();
        emit(DisplayInvestorRequests(requests: requests));
      } catch (e) {
        emit(ErrorLoadingInvestorRequests(message: e.toString()));
      }
    });

    add(LoadInvestorRequests());
  }
}

