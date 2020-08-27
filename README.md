# flutter_video_cast

A Flutter plugin for iOS and Android for connecting to cast devices like Chromecast and Apple TV.

## Installation

First, add `flutter_video_cast` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### iOS

Set the minimum os target to iOS 11.0.

Initialize the Cast context in the application delegate `ios/Runner/AppDelegate.m`:

```swift
import UIKit
import Flutter
import GoogleCast

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, GCKLoggerDelegate {
    let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
    let kDebugLoggingEnabled = true

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        GCKLogger.sharedInstance().delegate = self
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

Opt-in to the embedded views preview by adding a boolean property to the app's `Info.plist` file
with the key `io.flutter.embedded_views_preview` and the value `YES`.

### Android

Add dependencies in your module (app-level) Gradle file (usually `android/app/build.gradle`):

```groovy
implementation 'com.google.android.gms:play-services-cast-framework:19.0.0'
implementation 'com.google.android.exoplayer:extension-cast:2.11.5'
```

Set the theme of the MainActivity to `@style/Theme.AppCompat.NoActionBar` in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.gms.cast.framework.OPTIONS_PROVIDER_CLASS_NAME"
               android:value="com.google.android.exoplayer2.ext.cast.DefaultCastOptionsProvider"/>
    ...
    <activity android:theme="@style/Theme.AppCompat.NoActionBar" ...
```

Make `MainActivity` extends `FlutterFragmentActivity` and initialize the Cast context:

```kotlin
CastContext.getSharedInstance(applicationContext)
```

### Both

You can now add a `ChromeCastButton` widget to your widget tree.

The button can be controlled with the `ChromeCastController` that is passed to
the `ChromeCastButton`'s `onButtonCreated` callback.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_video_cast/flutter_video_cast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CastSample(),
    );
  }
}


class CastSample extends StatefulWidget {
  @override
  _CastSampleState createState() => _CastSampleState();
}

class _CastSampleState extends State<CastSample> {
  ChromeCastController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cast Sample'),
        actions: [
          ChromeCastButton(
            onButtonCreated: (controller) {
              setState(() => _controller = controller);
              _controller?.addSessionListener();
            },
            onSessionStarted: () {
              _controller?.loadMedia('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
            },
          ),
        ],
      ),
    );
  }
}
```

See the `example` directory for a complete sample app.
