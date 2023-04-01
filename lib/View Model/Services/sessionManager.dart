class SessionController {
  static final SessionController _session = SessionController.internal();
  String? userID;
  factory SessionController() {
    return _session;
  }
  SessionController.internal() {}
}
