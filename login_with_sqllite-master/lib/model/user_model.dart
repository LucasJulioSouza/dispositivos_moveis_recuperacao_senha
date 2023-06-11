class UserModel {
  String userId;
  String userName;
  String userEmail;
  String userPassword;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
  });

  get name => null;

  get email => null;

  @override
  String toString() {
    return 'UserModel(userId: $userId, userName: $userName, userEmail: $userEmail, userPassword: $userPassword)';
  }
}
