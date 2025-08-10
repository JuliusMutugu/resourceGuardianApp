# Resource Guardian - Flutter Frontend

A beautiful and modern financial management app built with Flutter, converted from the original React Native implementation.

## Features

- **Dashboard**: Overview of your financial status with balance cards, savings goals, and recent transactions
- **Authentication**: Secure login and registration system
- **Transactions**: Track and manage your income and expenses
- **Savings Goals**: Set and monitor your financial goals with progress tracking
- **Profile Management**: User profile and settings management
- **Modern UI**: Clean, intuitive design following Material Design principles

## Screenshots

*Screenshots will be added once the app is running*

## Architecture

This Flutter app follows a clean architecture pattern with:

- **Provider**: State management using the Provider pattern
- **Services**: API communication and business logic
- **Models**: Data models with JSON serialization
- **Widgets**: Reusable UI components
- **Screens**: Page-level UI components
- **Theme**: Centralized theming and design system

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── config/
│   │   └── app_config.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── transaction.dart
│   │   ├── savings_goal.dart
│   │   └── dashboard_data.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── dashboard_provider.dart
│   │   ├── transaction_provider.dart
│   │   └── goals_provider.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── main/
│   │       ├── main_screen.dart
│   │       ├── dashboard_screen.dart
│   │       ├── transactions_screen.dart
│   │       ├── goals_screen.dart
│   │       └── profile_screen.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── auth_service.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── balance_card.dart
│       ├── savings_goal_card.dart
│       └── transaction_list_item.dart
```

## Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for mobile development)

## Installation

1. **Install Flutter**: Follow the official Flutter installation guide for your operating system: https://flutter.dev/docs/get-started/install

2. **Clone and setup the project**:
   ```bash
   cd resource-guardian-app/flutter_frontend
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d chrome          # Web
   flutter run -d android         # Android
   flutter run -d ios             # iOS (macOS only)
   ```

## Backend Integration

The app is configured to work with the Spring Boot backend located in the `../backend` directory. Make sure the backend is running on `http://localhost:8080` before using the app.

To start the backend:
```bash
cd ../backend
./mvnw spring-boot:run
```

## Development

### State Management

The app uses the Provider pattern for state management. Key providers include:

- `AuthProvider`: Handles user authentication and session management
- `DashboardProvider`: Manages dashboard data and statistics
- `TransactionProvider`: Handles transaction operations
- `GoalsProvider`: Manages savings goals

### API Integration

API calls are handled through the `ApiService` class using Dio for HTTP requests. The service includes:

- Automatic request/response logging
- Error handling
- Authentication token management
- Base URL configuration

### Theming

The app uses a centralized theming system with:

- Color palette defined in `AppColors`
- Consistent sizing with `AppSizes`
- Material Design 3 theming
- Support for light mode (dark mode ready)

### Adding New Features

1. **Create Models**: Add data models in `lib/app/models/`
2. **Add Services**: Implement API calls in `lib/app/services/`
3. **Create Providers**: Add state management in `lib/app/providers/`
4. **Build UI**: Create screens and widgets in respective directories
5. **Update Router**: Add routes in `app_router.dart`

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please create an issue in the repository or contact the development team.

---

**Note**: This Flutter app is a complete rewrite of the original React Native implementation, providing a native experience across all platforms with improved performance and maintainability.
