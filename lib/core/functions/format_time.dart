String formatTime(String? time) {
  final parts = time?.split(":");
  return "${parts?[0]}:${parts?[1]}";
}
