
# MyPlaces 📸📍 
*🚧 Work in Progress 🚧*

## Project Description

**MyPlaces** is an app designed to let users capture photos and log the exact location of the places they visit. With this tool, you can create a personalized list of your favorite spots, ensuring you never forget those special moments!

## Features

- Photo Capture 📷: Take photos directly from the app to document your visits.
- Location Tracking 📍: Save the GPS location of each place you visit for easy access.

## Technologies Used

- Frontend: Flutter 📱

## Installation

1.Clone the repository:

```bash
git clone https://github.com/pablopoder/myplaces.git
```

2.Navigate to the project folder:

```bash
cd myplaces
```

3.Install the dependencies:

```bash
flutter pub get
```

4.Add your own API key:

To visualize a snapshot of the selected location, you need to include your own Google API key. Follow these steps:

1. **Create a file named `.env` in the root of your project.**
2. **Add your **API** key to the `.env` file like this:**

```bash
GOOGLE_MAPS_API_KEY=YOUR_API_KEY
```

Make sure to replace ***YOUR_API_KEY*** with your actual Google API key.

### Android Configuration

1. Open `android/local_properties`
2. Add your API key:

    ```dart
    API_KEY=YOUR_API_KEY`
    ```

### iOS Configuration

1. Open `IOS/Runner/AppDelegate.swift`
2. Add the following imports at the top:

    ```dart
    import GoogleMaps
    ```

3. Add this line inside `didFinishLaunchingWithOptions`:

    ```dart
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    ```

### Selected APIs

Google APIs used with the API Key:

- Maps SDK for Android
- Maps SDK for iOS
- Geocoding API
- Maps Static API

5.Run the app:

```bash
flutter run
```

## Contributions

Contributions are welcome! If you want to improve the app, please open an "issue" or submit a "pull request".

Enjoy exploring and saving your favorite places with MyPlaces! 🌍✨
