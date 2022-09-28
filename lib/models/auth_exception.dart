class AuthException implements Exception {

  late AuthError authError;

  AuthException(String message) {
    setAuthError(message);
  }

  @override
  String toString() {
    return generateMessage();
  }

  setAuthError(String message) {
    switch (message) {
      case 'EMAIL_EXISTS':
        authError = AuthError.emailExists;
        break;
      case 'INVALID_EMAIL':
        authError = AuthError.invalidEmail;
        break;
      case 'WEAK_PASSWORD':
        authError = AuthError.weakPassword;
        break;
      case 'EMAIL_NOT_FOUND':
        authError = AuthError.emailNotFound;
        break;
      default:
    }
  }

  String generateMessage() {
    String errorMessage;
    switch(authError) {

      case AuthError.emailExists:
        errorMessage = 'This email is already in use';
        break;
      case AuthError.invalidEmail:
        errorMessage = 'This is not a valid email address';
        break;
      case AuthError.weakPassword:
        errorMessage = 'This password is too week';
        break;
      case AuthError.emailNotFound:
        errorMessage = 'Could not find a user with that email';
        break;
      case AuthError.undefined:
        errorMessage = 'Authentication failed.';
        break;
    }
    return errorMessage;
  }


}



enum AuthError { emailExists, invalidEmail, weakPassword, emailNotFound , undefined }