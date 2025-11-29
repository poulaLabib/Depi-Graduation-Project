import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/Request%20section/requests_section_event.dart';
import 'package:depi_graduation_project/bloc/Request%20section/requests_section_state.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class RequestsSectionBloc
    extends Bloc<RequestsSectionEvent, RequestsSectionState> {
  final AuthenticationService auth;
  final RequestFirestoreService request;

  RequestsSectionBloc({required this.auth, required this.request})
    : super(LoadingRequests()) {
    on<LoadRequests>((event, emit) async {
      await emit.forEach(
        request.getRequestsStream(uid: auth.currentUser!.uid),
        onData: (requests) {
          if (requests.isEmpty) {
            return NoRequests();
          }
          return DisplayRequests(requests: requests);
        },
      );
    });
    on<AddRequestButtonPressed>((event, emit) {
      emit(NoRequests(showAddRequestDialog: true));
    });
    on<AddRequestConfirmed>((event, emit) async {
      await request.addRequest(
        uid: auth.currentUser!.uid,
        description: event.description,
        amountOfMoney: event.amountOfMoney,
        equityInReturn: event.equityInReturn,
      );
    });
    add(LoadRequests());
  }
}
