# GitHub Copilot Instructions for Resource Guardian

## Project Overview
Resource Guardian is a comprehensive financial management and digital behavior control application built with React Native frontend and Spring Boot backend. This is a production-ready, market-ready application that helps users control their spending, manage savings goals, and control their digital behavior for better life balance.

## Architecture
- **Frontend**: React Native 0.80.2 with TypeScript, Redux Toolkit, React Navigation 6, Material Design 3
- **Backend**: Spring Boot 3.2.0 with Java 17, PostgreSQL, JWT Authentication, M-Pesa Integration
- **Database**: PostgreSQL with comprehensive entity relationships
- **Authentication**: JWT-based with role-based access control

## Code Quality Standards

### React Native (Frontend)
- Use TypeScript with strict type checking
- Follow React Native best practices and performance optimization
- Use Redux Toolkit for state management with proper slices
- Implement Material Design 3 components consistently
- Use React Navigation 6 for navigation with TypeScript support
- Implement proper error boundaries and loading states
- Use React Query for API data fetching and caching
- Follow functional component patterns with hooks

### Spring Boot (Backend)
- Use Java 17 features and best practices
- Follow Spring Boot conventions and patterns
- Implement proper REST API design principles
- Use Spring Security for authentication and authorization
- Implement comprehensive validation using Bean Validation
- Use JPA/Hibernate with proper entity relationships
- Follow repository-service-controller pattern
- Implement proper exception handling and error responses

### Database Design
- Use proper JPA annotations and relationships
- Implement database constraints and validations
- Use PostgreSQL-specific features when beneficial
- Follow normalization principles
- Implement proper indexing for performance

## Key Features to Maintain

### Financial Management
- Transaction tracking with M-Pesa integration
- Savings goals with time-locking mechanism
- Budget creation and monitoring
- Financial analytics and reporting
- Expense categorization

### Digital Behavior Control
- App usage tracking and limits
- Website blocking and filtering
- Social media usage control
- Digital wellness insights
- Parental controls

### User Experience
- Material Design 3 interface
- Dark/light theme support
- Offline capability
- Real-time notifications
- Accessibility features

## Development Guidelines

### Code Structure
- Maintain clean architecture with clear separation of concerns
- Use dependency injection properly
- Implement proper error handling throughout
- Write comprehensive unit and integration tests
- Document public APIs and complex logic

### Security
- Never hardcode sensitive information
- Use environment variables for configuration
- Implement proper input validation and sanitization
- Follow OWASP security guidelines
- Use secure communication protocols

### Performance
- Optimize database queries
- Implement proper caching strategies
- Use lazy loading where appropriate
- Optimize React Native performance
- Monitor and profile application performance

## Current Entity Structure

### User Entity
- Authentication fields (email, password, phone)
- Personal information (name, date of birth, etc.)
- Preferences and settings
- Digital behavior control settings
- Financial preferences

### Transaction Entity
- M-Pesa integration fields
- Amount and currency
- Categories and descriptions
- Timestamps and status

### SavingsGoal Entity
- Goal details and target amounts
- Time-locking mechanisms
- Progress tracking
- Achievement rewards

### Goal Entity
- General goal management
- Progress tracking
- Categories and priorities

### AppUsage Entity
- Application usage tracking
- Time limits and restrictions
- Behavior analytics

## API Design Principles
- Use RESTful conventions
- Implement proper HTTP status codes
- Provide comprehensive error messages
- Use pagination for large datasets
- Implement API versioning
- Document APIs with OpenAPI/Swagger

## Mobile App Guidelines
- Design for both iOS and Android
- Implement responsive layouts
- Use native features appropriately
- Handle different screen sizes
- Implement proper navigation patterns
- Follow platform-specific guidelines

## Integration Points
- M-Pesa API for mobile payments
- Content filtering services
- Push notification services
- Analytics and monitoring
- External banking APIs (future)

## Testing Strategy
- Unit tests for business logic
- Integration tests for API endpoints
- End-to-end tests for critical user flows
- Performance testing for bottlenecks
- Security testing for vulnerabilities

## Deployment Considerations
- Use Docker for containerization
- Implement CI/CD pipelines
- Use environment-specific configurations
- Monitor application health and performance
- Implement proper logging and monitoring

## Code Style
- Follow established coding conventions
- Use meaningful variable and function names
- Write self-documenting code
- Implement proper commenting for complex logic
- Use consistent formatting and indentation

## When Suggesting Code
1. Always consider the existing architecture and patterns
2. Ensure compatibility with the current tech stack
3. Follow the established coding standards
4. Consider security implications
5. Think about performance impact
6. Maintain consistency with existing code style
7. Provide production-ready, not prototype code
8. Consider error handling and edge cases
9. Ensure proper typing (TypeScript/Java generics)
10. Follow the repository-service-controller pattern for backend

## Special Considerations
- This is a market-ready application, not a prototype
- All code should be production-quality
- Consider scalability and maintainability
- Implement proper monitoring and logging
- Follow security best practices throughout
- Consider user experience in all implementations
- Implement proper data validation and error handling

Remember: This application is designed to be a comprehensive, production-ready solution for financial management and digital behavior control. Every suggestion should maintain the high standards and comprehensive feature set that makes this application market-ready.
