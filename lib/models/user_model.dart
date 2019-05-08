class User {
  final String _email;
  final String _password;
  final bool _isAdmin;
  final String _name;
  final String _photo;

  User(this._email, this._password,this._isAdmin, this._name, this._photo){}

  String get email => _email;

  String get password => _password;

  bool get isAdmin => _isAdmin;

  String get name => _name;

  String get photo => _photo;
}

class UserGoogleDetails {
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final bool isAnonymous;
  final bool isEmailVerified;
  final List<UserInfoGoogleDetails> providerData;
  UserGoogleDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);
}

class UserInfoGoogleDetails {
  UserInfoGoogleDetails(
      this.providerId, this.displayName, this.email, this.photoUrl, this.uid);
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
}

class UserInfoDetails {
  UserInfoDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final bool isAnonymous;
  final bool isEmailVerified;
  final List<ProviderDetails> providerData;
}

class ProviderDetails {
  final String providerId;
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  ProviderDetails(
      this.providerId, this.uid, this.displayName, this.photoUrl, this.email);
}