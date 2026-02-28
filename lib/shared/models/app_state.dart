class AppState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final String theme;

  const AppState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.theme = 'light',
  });

  AppState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    String? theme,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      theme: theme ?? this.theme,
    );
  }
}