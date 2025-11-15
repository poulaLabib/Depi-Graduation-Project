import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_event.dart';
import 'package:depi_graduation_project/bloc/request_screen/request_screen_state.dart';
import 'package:depi_graduation_project/models/request.dart';
import 'package:depi_graduation_project/services/firebase_auth_service.dart';
import 'package:depi_graduation_project/services/firestore.dart';

class RequestScreenBloc extends Bloc<RequestScreenEvent, RequestScreenState> {
  final RequestFirestoreService request;
  final AuthenticationService auth;
  late Request req;

  RequestScreenBloc({required this.request, required this.auth})
      : super(LoadingRequest()) {
    on<LoadRequest>((event, emit) async {
      await emit.forEach(
        request.getRequest(auth.currentUser!.uid, event.request.requestId),
        onData: (requestData) {
          req = requestData ?? event.request;
          return DisplayingRequest(request: requestData ?? event.request);
        },
      );
    });

    on<EditRequestRequested>((event, emit) {
      emit(EditingRequest(request: req));
    });

    on<EditRequestConfirmed>((event, emit) async {
      final updatedRequest = {
        'uid': auth.currentUser!.uid,
        'description': event.description,
        'amountOfMoney': double.tryParse(event.amountOfMoney),
        'equityInReturn': event.equityInReturn,
        'whyAreYouRaising': event.whyAreYouRaising,
        'submittedAt': req.submittedAt,
      };

      await request.updateRequest(
        requestId: req.requestId,
        updatedData: updatedRequest,
      );

      emit(DisplayingRequest(request: req));
    });

    on<CancelButtonPressed>((event, emit) {
      emit(DisplayingRequest(request: req));
    });

    on<DeleteRequest>((event, emit) async {
      try {
        await request.deleteRequest(requestId: req.requestId);
        emit(RequestDeleted());
      } catch (e) {
        emit(RequestError(message: 'Failed to delete request: $e'));
      }
    });
  }
}
