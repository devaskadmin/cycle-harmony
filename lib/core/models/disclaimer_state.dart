class DisclaimerState {
  const DisclaimerState({
    required this.accepted,
    required this.firstLaunchComplete,
    required this.version,
    this.acceptedDate,
    this.lastShown,
  });

  final bool accepted;
  final DateTime? acceptedDate;
  final DateTime? lastShown;
  final String version;
  final bool firstLaunchComplete;

  bool needsDisplay(String currentVersion) {
    if (!accepted) {
      return true;
    }
    if (!firstLaunchComplete) {
      return true;
    }
    return version != currentVersion;
  }
}
