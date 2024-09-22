sealed class OnboardState {
  final int? pageIndex;

  const OnboardState({
    this.pageIndex,
  });

  OnboardState copyWith({
    int? pageIndex,
  });
}

class OnboardStateInitial extends OnboardState {
  const OnboardStateInitial({
    super.pageIndex,
  });

  @override
  OnboardState copyWith({
    int? pageIndex,
  }) {
    return OnboardStateInitial(
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}
