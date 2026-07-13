import 'package:equatable/equatable.dart';

class OwnerNavState extends Equatable {
  final int currentIndex;

  const OwnerNavState({this.currentIndex = 0});

  OwnerNavState copyWith({int? currentIndex}) {
    return OwnerNavState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}
