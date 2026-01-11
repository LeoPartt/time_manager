# Time Manager Backend

Spring Boot backend for the Time Manager application.

## Tech Stack
- Java 21
- Spring Boot 3.5.6
- PostgreSQL
- Maven
- JaCoCo for code coverage

## Getting Started

### Prerequisites
- JDK 21
- Maven (or use the included `mvnw` wrapper)
- PostgreSQL

### Running the application
```bash
./mvnw spring-boot:run
```

### Running tests with coverage
```bash
./mvnw clean test jacoco:report
```

Coverage report available at: `target/site/jacoco/index.html`

## Code Coverage
Current coverage: **76%** (target: 80%)
