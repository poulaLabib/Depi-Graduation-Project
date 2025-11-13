import 'package:bloc/bloc.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_event.dart';
import 'package:depi_graduation_project/bloc/home/entrep_home_screen/ehs_state.dart';

class EhsBloc extends Bloc<EhsEvent, EhsState> {
  EhsBloc() : super(LoadingHome()) {
    on<ShowInvestors>((event, emit) {
      emit(DisplayHome(displayedSectionIndex: 0));
    });
    on<ShowRequests>((event, emit) {
      emit(DisplayHome(displayedSectionIndex: 1));
    });
    add(ShowInvestors());
  }
}
