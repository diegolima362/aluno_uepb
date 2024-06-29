bool isEmail(String str) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regExp = RegExp(pattern);

  return str.isNotEmpty && regExp.hasMatch(str);
}
