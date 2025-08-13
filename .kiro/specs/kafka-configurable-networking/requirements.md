# Requirements Document

## Introduction

This feature aims to make Kafka Docker configuration more flexible by using environment variables (.env file) to configure network settings, particularly the advertised listeners and controller quorum voters. This will solve the issue where consumers cannot connect to Kafka when the hardcoded "kafka" hostname is not resolvable in their network environment.

## Requirements

### Requirement 1

**User Story:** As a developer, I want to configure Kafka's advertised listeners through environment variables, so that I can easily change the hostname/IP without modifying the docker-compose.yml file.

#### Acceptance Criteria

1. WHEN I set KAFKA_HOST environment variable THEN the system SHALL use this value for KAFKA_CFG_ADVERTISED_LISTENERS
2. WHEN KAFKA_HOST is not set THEN the system SHALL default to "kafka" as the hostname
3. WHEN I change KAFKA_HOST in .env file THEN Kafka SHALL advertise the new hostname to clients
4. WHEN external consumers connect THEN they SHALL be able to resolve the configured hostname/IP

### Requirement 2

**User Story:** As a developer, I want to configure Kafka's controller quorum voters through environment variables, so that I can adapt the configuration for different deployment environments.

#### Acceptance Criteria

1. WHEN I set KAFKA_HOST environment variable THEN the system SHALL use this value for KAFKA_CFG_CONTROLLER_QUORUM_VOTERS
2. WHEN KAFKA_HOST is not set THEN the system SHALL default to "kafka" for controller configuration
3. WHEN I update KAFKA_HOST THEN the controller quorum voters SHALL reflect the new hostname

### Requirement 3

**User Story:** As a developer, I want to use a .env file to manage Kafka configuration, so that I can easily maintain different configurations for different environments without changing docker-compose files.

#### Acceptance Criteria

1. WHEN I create a .env file with KAFKA_HOST THEN docker-compose SHALL read this variable
2. WHEN .env file contains KAFKA_PORT THEN the system SHALL use this port for external access
3. WHEN .env file is missing THEN the system SHALL use sensible defaults
4. WHEN I share the project THEN other developers SHALL be able to customize their environment through .env

### Requirement 4

**User Story:** As a developer, I want clear documentation and examples, so that I can quickly understand how to configure Kafka for my specific network setup.

#### Acceptance Criteria

1. WHEN I look at the project THEN there SHALL be a .env.example file with sample configurations
2. WHEN I read the documentation THEN it SHALL explain how to set up Kafka for different scenarios (localhost, custom IP, domain name)
3. WHEN I follow the setup instructions THEN I SHALL be able to successfully connect consumers from different network contexts