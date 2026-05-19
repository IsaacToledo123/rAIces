class UserProfile {
  final String username;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final List<String> interests;
  final double defaultBudget;

  const UserProfile({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.interests,
    required this.defaultBudget,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
}
