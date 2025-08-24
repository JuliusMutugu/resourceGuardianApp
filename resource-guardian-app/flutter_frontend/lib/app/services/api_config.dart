class ApiConfig {
  static const String baseUrl =
      'http://localhost:8080/api'; // this will later be converted to use the ipaddrss based on the connected network
  static const String savingsGoalsEndpoint = '/savings-goals';
  static const String transactionsEndpoint = '/transactions';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';

  // API Headers
  static const Map<String, String> headers = {
    /// remember to do the prior check to ensure that the same is accessible using postman
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) {
    return {
      ...headers,
      'Authorization':
          'Bearer $token', // this is the token to be used for authentication
    };
  }
}
