# GithubApiApp
This application, which supports ios 15 and above, shows the information of the searched user and the repositories of that user. We save the data it pulls from the internet locally using Realm and read it from the local, updating the user's data as it connects to the internet.

In order for the application to work efficiently, it would be appropriate to perform its tests on a physical device.

## Features

* Searches users over the internet by Github Rest API.
* Retrieves repository information about the searched user using the pagination structure.
* Allows data received over the Internet to be saved in the database using Realm.
* After connecting to the Internet, it updates local data according to the search made locally.
* Lists the repositories of the searched user in 1, 2 or 3 columns, depending on the user's selection.
* Instantly monitors the user's internet connection and determines the strategy for displaying data by notifying the user of the current internet connection.

## File Structure
* DateHelper: Convert Server Date To User Friendly Date.
* AppConfiguration: Access to constant values defined in AppConfig.xcconfig like base_url.
* DependencyContainer: Holds instances of NetworkManager, LocalStorageManager and NetworkMonitoringManager to provide dependency injection between ViewModels.
* Endpoint Protocol: Defines contract for API endpoints to handle paths and other endpoint-related properties through enums or structs.
* LocalStorageManager: Manages saving and reading user data and repositories to/from local Realm database.
* NetworkManager: Handles creation and processing of network requests and responses.
* RepositoryListView: Handles UI presentation of repositories.
* RepositoryListViewModel: Contains business logic for repository operations and data management.
* UserSearchListView: Manages user search interface and display.
* UserSearchListViewModel: Implements user search logic and manages search related operations.

## Technical Stack

### Architecture
- **MVVM Pattern** - For clear separation of concerns and testable architecture
- **Protocol-Oriented Programming** - For flexibility and dependency injection
- **Combine Framework** - For reactive programming and data binding

### Storage
- **Realm Database** - For local data persistence
  - User information storage
  - Repository data caching
  - Relationship mapping between models

### Networking
- **URLSession** - For API communication
- **Combine** - For handling asynchronous network requests
- **Network Monitoring** (SPM Package, NWPathMonitor) - For real-time network status tracking

## Data Flow

1. **Search Flow**
   - User initiates search → Check network availability → Fetch from API/Local Storage → Display results

2. **Repository Sync Flow**
   - Network becomes available → Fetch updates → Update local storage → Refresh UI

3. **Offline Flow**
   - Network unavailable → Queue request → Use local data → Sync when online

## Security Considerations

### Current Security Measures
- Network Traffic Security using ATS (App Transport Security)
- HTTPS enforcement for all network calls
- Basic data encryption

### Security Improvements Needed
1. **Certificate Pinning**
   - Protection against MITM attacks
   - Custom certificate validation
   - Certificate rotation mechanism

2. **Data Storage Security**
   - Keychain integration for sensitive data
   - Enhanced database encryption
   - Secure key storage
   - Input data sanitization

3. **TLS Security**
   - Minimum TLS version enforcement (TLS 1.3)
   - Certificate validation
   - Secure cipher suite configuration
   - Connection security verification

4. **Authentication Security**
   - Proper OAuth 2.0 implementation
   - Token rotation mechanism
   - Secure session management

5. **Local Storage Encryption**
   - Sensitive data encryptiom in Realm
   - Data migration handling

## Potential Improvements

### 1. Modularization
- **Storage Module**
  - Generic storage implementation
  - Reusable database layer
  - Better separation of concerns
  - Enhanced testing capabilities

- **Network Module**
  - Better error handling
  - Enhanced monitoring capabilities

- **Authentication and Rate Limiting**
  - GitHub OAuth implementation
  - Token-based authentication
  - Rate limit handling
  - Token refresh mechanism
  - Secure token storage


### 2. Image Caching
- Implementation of efficient image caching system
- Memory and disk cache management

### 3. Logging System
- **Error Logging**
  - Comprehensive error tracking
  - Error categorization

- **Network Logging**
  - Request/Response logging
  - Network error tracking

### 4. iPad Support
- Adaptive layouts for different screen sizes
- Optimized UI for tablet experience

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Dependencies

### Swift Package Manager
- **NetworkMonitoring** - For network reachability tracking
- **RealmSwift** - Swift wrapper for Realm

## Getting Started

1. Clone the repository
2. Install dependencies using SPM
3. Open `GitHubApiApp.xcodeproj`
4. Build and run

## Contact

For any inquiries or issues, please open an issue in the GitHub repository.

## Project Status

This project is actively maintained and under continuous development. New features and improvements are regularly being added.
