abstract class EhsState {}

class LoadingHome extends EhsState {}

class DisplayHome extends EhsState {
  final int displayedSectionIndex;
  DisplayHome({required this.displayedSectionIndex});
}