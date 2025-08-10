# Resource Guardian App

A comprehensive financial management and behavior control application built with React Native (Frontend) and Spring Boot (Backend).

## 🌟 Overview

Resource Guardian is a modern, production-ready mobile application designed to help users:

- **Manage Finances**: Track expenses, set budgets, monitor savings goals
- **Control Digital Behavior**: Limit social media usage, block harmful content
- **Stay Motivated**: Receive inspirational quotes and achieve personal goals
- **Integrate with M-Pesa**: Seamless Kenyan mobile money transactions
- **Real-time Analytics**: Comprehensive dashboards and insights

## 🏗️ Architecture

### Frontend (React Native)
- **Framework**: React Native 0.80.2 with TypeScript
- **Navigation**: React Navigation 6.x
- **State Management**: Redux Toolkit + React Query
- **UI Components**: React Native Paper (Material Design 3)
- **Authentication**: JWT-based with secure storage
- **Real-time**: WebSocket integration for live updates

### Backend (Spring Boot)
- **Framework**: Spring Boot 3.2.0 with Java 17
- **Database**: PostgreSQL with JPA/Hibernate
- **Security**: Spring Security with JWT
- **API**: RESTful endpoints with OpenAPI documentation
- **Integrations**: M-Pesa API, Content filtering APIs
- **Monitoring**: Spring Actuator for health checks

## 📁 Project Structure

```
resource-guardian-app/
├── frontend/
│   ├── ResourceGuardianApp/          # React Native App
│   │   ├── src/
│   │   │   ├── components/           # Reusable UI components
│   │   │   ├── screens/             # App screens
│   │   │   ├── navigation/          # Navigation configuration
│   │   │   ├── store/               # Redux store & slices
│   │   │   ├── services/            # API services
│   │   │   ├── types/               # TypeScript definitions
│   │   │   ├── utils/               # Utility functions
│   │   │   └── theme/               # Theme & styling
│   │   ├── android/                 # Android-specific code
│   │   ├── ios/                     # iOS-specific code (future)
│   │   └── package.json
│   └── docs/                        # Frontend documentation
├── backend/
│   ├── src/
│   │   ├── main/java/com/resourceguardian/backend/
│   │   │   ├── controller/          # REST controllers
│   │   │   ├── service/             # Business logic
│   │   │   ├── repository/          # Data access layer
│   │   │   ├── entity/              # JPA entities
│   │   │   ├── dto/                 # Data transfer objects
│   │   │   ├── config/              # Configuration classes
│   │   │   ├── security/            # Security configuration
│   │   │   └── util/                # Utility classes
│   │   └── resources/
│   │       ├── application.properties
│   │       └── data.sql             # Sample data
│   ├── pom.xml
│   └── docs/                        # Backend documentation
├── docs/                            # Project documentation
├── docker-compose.yml               # Local development environment
└── README.md                        # This file
```

## 🚀 Features

### 📱 Mobile App Features

#### 🔐 Authentication & Onboarding
- User registration with email/phone verification
- Secure JWT-based authentication
- Comprehensive onboarding flow
- Biometric authentication support
- Multi-language support (English/Swahili)

#### 💰 Financial Management
- **Transaction Tracking**: Manual entry + M-Pesa integration
- **Budget Management**: Category-based budgets with alerts
- **Savings Goals**: Time-locked savings with progress tracking
- **Expense Analytics**: Visual charts and spending insights
- **Bill Reminders**: Automated payment notifications

#### 🛡️ Behavior Control
- **App Usage Monitoring**: Track time spent on applications
- **Content Blocking**: Filter harmful websites and content
- **Social Media Limits**: Configurable time restrictions
- **Strict Mode**: Enhanced blocking during focus periods
- **Usage Analytics**: Detailed behavior insights

#### 🎯 Goal Tracking
- **Personal Goals**: Custom goal setting and tracking
- **Financial Goals**: Savings and investment targets
- **Behavioral Goals**: Digital wellness objectives
- **Progress Visualization**: Charts and achievement badges
- **Streak Tracking**: Maintain consistency

#### 💬 Motivational Content
- **Daily Quotes**: Inspirational messages
- **Biblical Wisdom**: Faith-based content (optional)
- **Philosophical Insights**: Thought-provoking content
- **Achievement Celebrations**: Milestone recognition
- **Community Features**: Share progress with friends

#### 📊 Advanced Analytics
- **Financial Dashboard**: Comprehensive money insights
- **Behavior Dashboard**: Digital wellness metrics
- **Goal Progress**: Visual progress tracking
- **Trend Analysis**: Long-term pattern recognition
- **Predictive Insights**: AI-powered recommendations

### 🌐 Backend API Features

#### 🔒 Security & Authentication
- JWT token management with refresh tokens
- Role-based access control (RBAC)
- Rate limiting and DDoS protection
- Data encryption at rest and in transit
- Audit logging for all actions

#### 📡 Real-time Features
- WebSocket connections for live updates
- Push notifications for important events
- Real-time spending alerts
- Live goal progress updates
- Instant M-Pesa transaction notifications

#### 🔗 Third-party Integrations
- **M-Pesa API**: Payment processing and transaction sync
- **Content Filter APIs**: Website and content screening
- **SMS Gateway**: OTP and notification services
- **Email Service**: Account verification and alerts
- **Analytics APIs**: Enhanced insights and reporting

#### 📈 Data & Analytics
- Comprehensive user behavior analytics
- Financial trend analysis and predictions
- Goal achievement analytics
- Usage pattern recognition
- Custom reporting capabilities

## 🛠️ Technology Stack

### Frontend Technologies
- **React Native 0.80.2**: Cross-platform mobile development
- **TypeScript**: Type-safe JavaScript
- **Redux Toolkit**: Predictable state management
- **React Query**: Server state management
- **React Navigation**: Navigation library
- **React Native Paper**: Material Design components
- **React Hook Form**: Form management
- **React Native Reanimated**: Smooth animations
- **AsyncStorage**: Local data storage
- **Flipper**: Debugging and development tools

### Backend Technologies
- **Spring Boot 3.2.0**: Java application framework
- **Spring Security**: Authentication and authorization
- **Spring Data JPA**: Data persistence
- **PostgreSQL**: Relational database
- **Redis**: Caching and session storage
- **JWT**: Stateless authentication
- **Maven**: Dependency management
- **Docker**: Containerization
- **Spring Actuator**: Application monitoring

### Development Tools
- **ESLint & Prettier**: Code formatting and linting
- **Husky**: Git hooks for code quality
- **Jest**: Testing framework
- **Detox**: End-to-end testing
- **SonarQube**: Code quality analysis
- **GitHub Actions**: CI/CD pipeline

## 🚀 Getting Started

### Prerequisites
- **Node.js** 18+ and npm/yarn
- **Java** 17+ and Maven
- **Android Studio** with SDK
- **PostgreSQL** 14+
- **Redis** 6+
- **Git**

### Backend Setup

1. **Clone and navigate to backend**:
   ```bash
   git clone <repository-url>
   cd resource-guardian-app/backend
   ```

2. **Configure database**:
   ```bash
   # Create PostgreSQL database
   createdb resource_guardian
   
   # Update application.properties with your credentials
   ```

3. **Install dependencies and run**:
   ```bash
   ./mvnw clean install
   ./mvnw spring-boot:run
   ```

4. **Verify backend**:
   - API: http://localhost:8080/api
   - Health: http://localhost:8080/api/actuator/health

### Frontend Setup

1. **Navigate to frontend**:
   ```bash
   cd resource-guardian-app/frontend/ResourceGuardianApp
   ```

2. **Install dependencies**:
   ```bash
   npm install
   # or
   yarn install
   ```

3. **Install iOS dependencies** (Mac only):
   ```bash
   cd ios && pod install && cd ..
   ```

4. **Start Metro bundler**:
   ```bash
   npm start
   # or
   yarn start
   ```

5. **Run on device/emulator**:
   ```bash
   # Android
   npm run android
   
   # iOS (Mac only)
   npm run ios
   ```

### Quick Development Setup

Use Docker Compose for rapid local development:

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 📱 Supported Features by Platform

| Feature | Android | iOS | Web |
|---------|---------|-----|-----|
| Core App | ✅ | 🚧 | ❌ |
| Authentication | ✅ | 🚧 | ❌ |
| Financial Tracking | ✅ | 🚧 | ❌ |
| M-Pesa Integration | ✅ | ❌ | ❌ |
| Content Blocking | ✅ | 🚧 | ❌ |
| App Usage Monitoring | ✅ | 🚧 | ❌ |
| Push Notifications | ✅ | 🚧 | ❌ |
| Biometric Auth | ✅ | 🚧 | ❌ |

✅ Implemented | 🚧 Planned | ❌ Not Supported

## 🌍 Localization

The app supports multiple languages:
- **English (en)**: Primary language
- **Swahili (sw)**: For Kenyan users
- **More languages**: Planned for future releases

## 🔒 Security Features

### Data Protection
- End-to-end encryption for sensitive data
- Secure token storage with encryption
- Biometric authentication support
- Session management with automatic logout
- Regular security audits and updates

### Privacy Controls
- Granular privacy settings
- Data export capabilities
- Account deletion with data cleanup
- GDPR compliance ready
- Transparent data usage policies

## 📊 Performance & Monitoring

### Application Performance
- **Response Times**: < 200ms for most API calls
- **App Launch**: < 3 seconds cold start
- **Memory Usage**: Optimized for low-end devices
- **Battery Optimization**: Minimal background processing
- **Offline Support**: Core features work offline

### Monitoring & Analytics
- Real-time performance monitoring
- Crash reporting and automatic fixes
- User behavior analytics (anonymized)
- API performance metrics
- Database query optimization

## 🧪 Testing Strategy

### Frontend Testing
- **Unit Tests**: Component and utility testing
- **Integration Tests**: Screen and navigation flow tests
- **E2E Tests**: Complete user journey testing
- **Performance Tests**: Memory and rendering tests
- **Accessibility Tests**: Screen reader compatibility

### Backend Testing
- **Unit Tests**: Service and utility testing
- **Integration Tests**: API endpoint testing
- **Security Tests**: Authentication and authorization
- **Performance Tests**: Load and stress testing
- **Contract Tests**: API contract validation

## 🚀 Deployment

### Production Environment
- **Backend**: AWS/Azure with auto-scaling
- **Database**: Managed PostgreSQL with backups
- **CDN**: Global content delivery network
- **Monitoring**: 24/7 uptime monitoring
- **Security**: WAF and DDoS protection

### Mobile App Distribution
- **Android**: Google Play Store + Direct APK
- **iOS**: Apple App Store (planned)
- **Enterprise**: MDM-compatible versions
- **Beta Testing**: TestFlight and Firebase App Distribution

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](./CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Run the test suite
6. Submit a pull request

### Code Standards
- Follow established code formatting
- Write comprehensive tests
- Update documentation
- Use conventional commit messages
- Ensure backwards compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 📞 Support

### Getting Help
- **Documentation**: Check our [Wiki](./docs)
- **Issues**: GitHub Issues for bug reports
- **Discussions**: GitHub Discussions for questions
- **Email**: support@resourceguardian.app

### Community
- **Discord**: Join our development community
- **Twitter**: Follow [@ResourceGuardian](https://twitter.com/resourceguardian)
- **LinkedIn**: Professional updates and news

## 🗺️ Roadmap

### Version 2.0 (Q2 2025)
- ✅ Complete Android implementation
- 🚧 iOS app development
- 🚧 Advanced AI-powered insights
- 🚧 Social features and community
- 🚧 Investment tracking integration

### Version 3.0 (Q4 2025)
- 📋 Web dashboard for detailed analytics
- 📋 API marketplace for third-party integrations
- 📋 Advanced reporting and export features
- 📋 Multi-currency support expansion
- 📋 Enterprise features and admin panel

### Long-term Vision
- Global expansion beyond Kenya
- Additional payment provider integrations
- Advanced AI-powered financial advice
- Comprehensive wellness platform
- Enterprise and family plan features

---

**Built with ❤️ for financial wellness and digital mindfulness**

*Last updated: August 2025*
