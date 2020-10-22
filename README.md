# AFQYApp
## Running the project
To run the project the following needs to be complete:
- Clone this repository
- Install flutter from here: https://flutter.dev/docs/get-started/install
- Install Android studio and an Android emulator
- Install the Dart and Flutter plugins for Android Studio
- Ensure either an emulator er device is connected
- Run `flutter run` in a terminal from the project directory. OR click the green play button in Android Studio.

## Deploying to App Stores
1. Increment the version and build number in the pubspec.yml file
**IOS**
2. Follow this guide here (read from "Create a build archive") : https://flutter.dev/docs/deployment/ios#create-a-build-archive
**Android**
2. Ensure the keystore is installed correctly from here: https://github.com/AFQY/app-keys
3. Run the command `flutter build appbundle`
4. Upload the app bundle from build\app\outputs\bundle\release to the google play console as an internal release
