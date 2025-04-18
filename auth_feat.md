# Authentication Implementation Plan

## Overview

This document outlines the implementation plan for adding authentication to the Tien Giang Mystic Flutter application using Google Sign-In with Supabase session management.

## Technology Stack

-   **Frontend**: Flutter
-   **Backend**: Supabase
-   **Authentication**: Google Sign-In SDK
-   **State Management**: GetX
-   **Local Storage**: SharedPreferences

## Authentication Features

### 1. Authentication Method

-   Google Sign-In (exclusive authentication method)
-   Session ID management through Supabase

### 2. Core Features

1. **Google Authentication**

    - Single-tap Google sign-in
    - Google account information retrieval
    - Token management

2. **Session Management with Supabase**

    - Session ID generation and storage
    - Session state tracking
    - Session persistence
    - Auto-login capability

3. **Profile Management**
    - Store Google profile in Supabase
    - Session tracking
    - Handle sign-out

## Implementation Structure

### 1. Directory Structure

```
lib/
├── modules/
│   └── auth/
│       ├── controllers/
│       │   └── auth_controller.dart        # Handles auth state and logic
│       ├── views/
│       │   ├── auth_screen.dart           # Main auth screen
│       │   └── widgets/                   # Auth-related widgets
│       │       └── google_signin_button.dart
│       └── bindings/
│           └── auth_binding.dart          # Dependency injection
├── models/
│   └── user_session_model.dart            # Session data model
├── services/
│   ├── auth_service.dart                  # Google Sign-In and auth logic
│   └── supabase_service.dart              # Supabase operations
├── utils/
│   └── session_utils.dart                 # Session management helpers
└── route/
    └── app_pages.dart                     # Updated with auth routes

```

### 2. Key Components

#### Auth Controller (auth_controller.dart)

```dart
// Manages auth state and session handling
- Google Sign-In flow
- Session management
- User state
- Navigation logic
```

#### Auth Service (auth_service.dart)

```dart
// Handles authentication operations
- Google Sign-In implementation
- Token management
- Session creation/validation
```

#### Supabase Service (supabase_service.dart)

```dart
// Manages Supabase operations
- Session storage in JSONB array
- User session queries
- Database operations
```

#### User Session Model (user_session_model.dart)

```dart
// Data model for sessions
- Session data structure
- JSON serialization
- Session state management
```

### 3. Integration Points

#### Main Binding (main_binding.dart)

```dart
// Update with auth dependencies
- Register AuthController
- Register AuthService
- Register SupabaseService
```

#### Route Management (app_pages.dart)

```dart
// Add auth routes
- Auth screen route
- Auth middleware
- Protected routes
```

### 4. Implementation Flow

1. **Service Layer**

    - Implement Google Sign-In in `auth_service.dart`
    - Set up Supabase operations in `supabase_service.dart`
    - Create session management utilities

2. **Data Layer**

    - Implement session model
    - Set up database operations
    - Handle session array management

3. **UI Layer**

    - Create auth screen
    - Implement Google Sign-In button
    - Add loading states
    - Handle error displays

4. **State Management**
    - Set up auth controller
    - Implement session state management
    - Handle auth flow

## Implementation Steps

### Phase 1: Setup

1. Configure Google Sign-In
2. Set up Supabase session handling
3. Create user_sessions table in Supabase
4. Initialize services in the app
5. Set up session cleanup policies

### Phase 2: Core Authentication

1. Implement Google Sign-In
2. Set up Supabase session creation
3. Implement session tracking
4. Create secure storage for tokens

### Phase 3: State Management

1. Implement authentication state handling
2. Set up session monitoring
3. Handle app lifecycle events
4. Implement auto-login logic

### Phase 4: UI/UX

1. Design Google Sign-In screen
2. Implement loading states
3. Add error handling
4. Create success notifications

## State Management

### Authentication States

```dart
enum AuthState {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error
}
```

### Session States

-   Track Supabase session
-   Monitor Google authentication state
-   Handle session transitions
-   Manage session lifecycle

## Error Handling

-   Google Sign-In errors
-   Supabase session errors
-   Network connectivity issues
-   Token validation errors

## Security Considerations

1. **Session Management**

    - Secure session ID storage
    - Session monitoring in Supabase
    - Session invalidation
    - Concurrent session handling
    - Regular cleanup of expired sessions
    - JWT token encryption at rest

2. **Token Security**
    - Secure Google token storage
    - Token lifecycle management
    - Session token validation
    - JWT token rotation policies
    - Token expiration handling

## Dependencies

-   google_sign_in
-   supabase_flutter
-   get
-   shared_preferences

## Notes

-   Keep Google Sign-In flow simple
-   Maintain robust session tracking in Supabase
-   Handle offline scenarios gracefully
-   Log authentication events
-   Implement proper error recovery
-   Follow Supabase best practices
-   Handle edge cases in Google Sign-In flow

## Resources

-   Google Sign-In Documentation
-   Supabase Documentation
-   Flutter Google Sign-In Guide
-   GetX Documentation

## Database Structure

### Authentication Tables

#### 1. Auth Users (auth.users)

```sql
-- Built-in Supabase auth.users table will store:
- id (uuid, primary key)          -- Supabase user ID
- email (text)                    -- Google email
- raw_user_meta_data (jsonb)      -- Google profile data
- created_at (timestamptz)
```

#### 2. User Sessions (public.user_sessions)

```sql
Table: public.user_sessions
- id (uuid, primary key, default: gen_random_uuid())
- user_id (uuid, not null, references auth.users(id))
- sessions (jsonb, not null, default: '[]')  -- Array of session objects
- updated_at (timestamptz, default: now())

-- Session object structure in the sessions array:
{
  "session_id": "string",      -- For external database queries
  "jwt_token": "string",       -- Google auth JWT
  "created_at": "timestamp"    -- When this session was created
}
```

#### 3. Indexes

```sql
-- For user lookups
CREATE INDEX idx_user_sessions_user_id ON public.user_sessions(user_id);

-- For searching within the sessions array
CREATE INDEX idx_user_sessions_gin ON public.user_sessions USING GIN (sessions);
```

#### 4. Row Level Security

```sql
-- Enable RLS
ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;

-- Users can only access their own sessions
CREATE POLICY "Users can manage their own sessions"
  ON public.user_sessions
  FOR ALL
  USING (auth.uid() = user_id);
```

### Usage Guidelines

#### 1. User Authentication

-   Google Sign-In data stored in auth.users
-   Automatic user creation/update by Supabase
-   Profile information stored in raw_user_meta_data

#### 2. Session Management

-   Each user has one row in user_sessions
-   Sessions stored as array of objects in JSONB column
-   Easy to add/remove sessions from array
-   Flexible structure for session data

#### 3. Session Operations

-   Add new session:

    ```sql
    UPDATE public.user_sessions
    SET sessions = sessions || jsonb_build_array(
      jsonb_build_object(
        'session_id', 'new_session_id',
        'jwt_token', 'new_jwt_token',
        'created_at', now()
      )
    )
    WHERE user_id = auth.uid();
    ```

-   Query by session_id:
    ```sql
    SELECT * FROM public.user_sessions
    WHERE sessions @> '[{"session_id": "target_session_id"}]';
    ```

#### 4. Security Considerations

-   JWT tokens stored in JSONB array
-   Row Level Security ensures data isolation
-   GIN index for efficient session searches
-   Each user manages their own session array

This structure allows:

-   Multiple sessions per user
-   Efficient session lookups
-   Easy session management
-   Secure data isolation
-   Flexible session data storage

## Local Storage Management

### 1. Storage Structure

```dart
// Using shared_preferences for persistent storage
class StorageKeys {
  static const String JWT_TOKEN = 'jwt_token';
  static const String USER_DATA = 'user_data';
  static const String SESSION_DATA = 'session_data';
  static const String LAST_LOGIN = 'last_login';
}

// Storage data structure
{
  "jwt_token": "string",          // Google JWT token
  "user_data": {                  // User information
    "id": "string",
    "email": "string",
    "name": "string",
    "photo_url": "string"
  },
  "session_data": {               // Current session info
    "session_id": "string",
    "created_at": "timestamp"
  },
  "last_login": "timestamp"       // For expiration check
}
```

### 2. Storage Service (storage_service.dart)

```dart
// Add to services directory
class StorageService {
  // Save auth data
  Future<void> saveAuthData(GoogleSignInAuthentication auth, UserData user);

  // Save session data
  Future<void> saveSessionData(String sessionId);

  // Get stored auth data
  Future<Map<String, dynamic>> getAuthData();

  // Check and handle token expiration
  Future<bool> isTokenValid();

  // Clear stored data
  Future<void> clearAuthData();
}
```

### 3. Token Lifecycle

-   **Storage Duration**: 7 days from last login
-   **Auto Refresh**: Update last_login on each app launch
-   **Expiration Check**: On app launch and API calls
-   **Cleanup**: Auto clear expired data

### 4. Implementation in Auth Service

```dart
class AuthService {
  final StorageService _storage;

  // On successful login
  Future<void> handleSignIn() async {
    // Get Google Sign-In data
    final googleAuth = await handleGoogleSignIn();

    // Save to local storage
    await _storage.saveAuthData(googleAuth, userData);

    // Save to Supabase
    final sessionId = await createSupabaseSession(googleAuth.idToken);
    await _storage.saveSessionData(sessionId);
  }

  // Check auth state on app launch
  Future<bool> checkAuthState() async {
    if (!await _storage.isTokenValid()) {
      await _storage.clearAuthData();
      return false;
    }

    final authData = await _storage.getAuthData();
    // Verify and refresh if needed
    return true;
  }
}
```

### 5. Auto-Login Implementation

```dart
class AuthController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkStoredAuth();
  }

  Future<void> checkStoredAuth() async {
    final isValid = await _authService.checkAuthState();
    if (isValid) {
      // Restore user session
      final authData = await _storage.getAuthData();
      // Update auth state
      // Navigate to home
    }
  }
}
```

### 6. Security Considerations

-   Encrypt sensitive data before storage
-   Clear data on logout
-   Auto-clear expired data
-   Handle token refresh
-   Secure storage access

### 7. Storage Utilities (storage_utils.dart)

```dart
// Add to utils directory
class StorageUtils {
  // Encrypt data before storage
  static String encryptData(String data);

  // Decrypt stored data
  static String decryptData(String encrypted);

  // Check expiration
  static bool isExpired(String timestamp);

  // Format data for storage
  static Map<String, dynamic> formatAuthData(GoogleSignInAuthentication auth);
}
```
