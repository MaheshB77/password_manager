# password_manager

---

## Android emulator commands

-   List the emulators
    -   `emulator -list-avds`
-   Run the emulator
    -   `emulator -avd Pixel_5_API_30`

## Testing related commands

-   Run tests locally
    -   `flutter test`
-   Build mocks
    -   `dart run build_runner build`

## Database

-   Location on device
    -   `/data/user/0/com.mahesh.password_manager/databases`
-   Connect to database using adb
    -   `cd /data/user/0/com.mahesh.password_manager/databases`
    -   `sqlite3 password_manager.db`
-   To see the database visually go to android studio -> View -> Tools Windows -> App Inspection

## ADB

-   Connect to emulator through adb
    -   ADB is located at `C:\Users\mbans\AppData\Local\Android\Sdk\platform-tools`
    -   Add it to the path
    -   Execute `adb devices` to see the running emulators
    -   Connect to emulator using `adb -s emulator-5554 shell`
    -   If root access is needed then hit `adb -s emulator-5554 root` and then `adb -s emulator-5554 shell`

## Riverpod

- Generate the utility files using below command
    - `dart run build_runner watch`