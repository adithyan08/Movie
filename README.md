# MovieApp iOS

A modern iOS movie app built with SwiftUI featuring CRUD operations and TMDb API integration.

## Features
- Browse popular movies
- Search functionality  
- Favorites management
- Movie details with cast info
- Offline support
- iOS 14+ compatibility

## Setup
1. 1. Clone the repository: https://github.com/adithyan08/Movie.git

2. Navigate to the project folder:

3. Create your `Config.plist` by copying the sample and adding your TMDb API key:
Edit `Config.plist` and replace `YOUR_TMDB_API_KEY_HERE` with your actual key from [TMDb API](https://www.themoviedb.org/documentation/api).

4. Install CocoaPods dependencies (if using CocoaPods):

5. Open the workspace:

6. Build and run the app using Xcode on a simulator or device with iOS 14+.

## Architecture Overview

- **MVVM (Model-View-ViewModel) pattern:**  
Separates UI (SwiftUI Views) from business logic (ViewModels) and network/data layer (Models).
- **SwiftUI:**  
Declarative UI framework supporting a reactive and modular user interface.
- **Combine framework:**  
Handles asynchronous data streams between ViewModels and Views cleanly.
- **Network Layer:**  
Uses URLSession to interact with TMDb API endpoints.
- **Local Storage:**  
Favorites persistence using UserDefaults or Core Data for offline support.

This architecture allows for clean separation of concerns, easy testing, and scalable maintenance.

## Assumptions and Additional Features

- Requires iOS 14 or later.
- Assumes stable internet connection for API calls.
- Includes additional features such as:
- Movie search with debounce to limit unnecessary requests.
- Favorites tab with image prefetching for faster loading.
- Robust error handling UI with retry option.
- Shimmer effect animations during loading for better user experience.

---

Please ensure you create the `Config.plist` as described before building the project to avoid runtime errors due to missing API keys.


