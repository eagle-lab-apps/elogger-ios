# ELogger

**ELogger** is a logging library for mobile applications, designed to provide a simple and effective way to log messages, errors, and other information for debugging purposes. It supports both iOS 11.0+ and Android 7.0 (API 24)+ platforms, offering a unified interface for logging across different devices.

Each message is logged by specifying its `String` content & urgency level. There are 5 urgency levels supported:
- `low`: low urgency level is typically used for debugging purposes
- `info`: info urgency level is typically used for general information
- `medium`: medium urgency level is typically used for more significant information
- `high`: high urgency level is typically used for serious information indicating something is wrong and should be investigated
- `blocker`: blocker urgency level is typically used for unrecoverable errors that require immediate attention

An overview of logged messages that were sent to the backend is available at https://elogger.eaglelab.com/ (VPN protected).
    

    
______________________________



## iOS 

### Overview

This library supports: besides remote logging to a backend server, console logging, and file logging for persistent storage of logs. It also relies on request retrying & network connection monitoring, ensuring that important information is captured and can be analyzed later.

> [!TIP]
> Simple version of this library is available as `ELog.RemoteELogger` - a simple singleton remote logger implementation that supports just immediate sending of logs to the backend server, *without any advanced features like retry mechanism, network connection monitoring or batching*. It can be easily implemented in other projects by importing `eLogger.ELog` directory, as it can be used without any additional dependencies outside of that directory.

### Features

- Three types of logging outputs can be configured separately:
    - **Remote Logging**: Send logs to the backend server for centralized logging and analysis.
    - **Console Logging**: Log messages to the Xcode & MacOS console for debugging purposes.
    - **File Logging**: Save logs to a file for later analysis or to allow client sharing of logs with support teams.
    
- **Customizable min log level**: Filter out logs based on minimum severity level to reduce noise and focus on important messages.

- **Customizable logging mode**: 
    - Choose between immediate log sending or manual log sending (via flush) for remote logging.
    - Choose between immediate log sending, manual log sending (via flush) or batch sending based on max elapsed time / min batch items for file logging.
    
- **Toggleable retry mechanism**: Automatically retry remote log sending in case of network failures.

- **Customizable batching**: Group logs into batches for more efficient transmission with customizable max elapsed time & min batch items count.

- **Manual log flushing**: Send all logged messages manually using a flush mechanism (available for remote & file logging).

- **Network connection monitoring**: Automatically re-send logs when the network connection is restored, ensuring no logs are lost during connectivity issues.

- **Togglable verbose logging**: Enable verbose logging for the `ELogger` itself to debug its internal operations.

### Installation

To use the `eLogger` library in your iOS project, you can import it via Swift Package Manager: Xcode File > Add Packages and enter repository URL: https://github.com/eagle-lab-apps/elogger-ios. For manual integration, copy into your project:
  - `eLogger` directory for fully featured `eLogger`
  - `eLogger.ELog` directory for simple `ELog.RemoteELogger` remote logger implementation

> [!NOTE]
> To expose the generated log files to the end-user in the Files app, add the following keys to your app's Info.plist:
>
> ```xml
> <key>UIFileSharingEnabled</key>
> <true/>
>
> <key>LSSupportsOpeningDocumentsInPlace</key>
> <true/>
> ```

### Usage

#### Importing the Framework

To use `eLogger` framework, first import it into your project:

```swift
import eLogger
```

#### Initializing `ELogger`

You don't need to initialize `ELogger` explicitly, as you can access the shared singleton instance directly via:

```swift
let logger = ELogger.shared
```

The shared instance is initialized with default configuration and can be used immediately for logging. Default configuration specifies `.low` minimum logging level (all log messages are sent) and includes console output and remote output with immediate logging & retry mechanism.

If you want to use `ELogger` with custom configuration, you can create a custom instance of `ELogger` by passing an `ELoggerConfiguration` instance to `ELogger.init(config:)` method. method. This allows you to set the minimum logging level, turn on verbose logging of the `ELogger` itself, enable or disable specific outputs (remote, console, file), and configure batching and retry settings.

```swift
let configuration = ELoggerConfiguration(verboseLogging: true)
let eLogger = ELogger.init(config: configuration)
```

which will initialize the `ELogger` instance with only console output, turn on its verboseLogging & return it.

#### Initializing `RemoteELogger`

Before using `ELog.RemoteELogger`, you need to initialize it. You can do this in your:
- `App`'s `init()` for SwiftUI:
```swift
init() {
    ELog.RemoteELogger.`init`()
}
```
- `AppDelegate`'s `application(_:didFinishLaunchingWithOptions:)` for UIKit:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ELog.RemoteELogger.`init`()
    return true
}
```

At a minimum, you need to call that, which will initialize the `RemoteELogger` instance with default configuration & return it.

In case you want to turn on verbose logging of the `RemoteELogger` itself, you can chain `verboseLogging()` method to the `init()` call:

```swift
init() {
    ELog.RemoteELogger.`init`().verboseLogging()
}
```

making the `RemoteELogger` print out debug & info logs to the Xcode & MacOS console.

You can access the initalized `RemoteELogger` instance, either by saving the initializer return value to a variable or by calling:

```kotlin
val logger = ELog.RemoteELogger.shared
```

#### Using `ELogger`

Once you have the `ELogger` instance, you can start logging messages immediately by calling:

```swift
logger.log(message, level)
```
 
method on it with the message content and urgency level, or by specifying the level directly via
some of its: 
  
```swift
logger.<level>(message)
```
  
methods.

#### Using `RemoteELogger`

Once you have the `RemoteELogger` instance, you can start logging messages immediately by calling:

```swift
logger.log(message, level)
```
 
method on it with the message content and urgency level, or by specifying the level directly via
some of its:
  
```swift
logger.<level>(message)
```
  
methods.
    
    
Both types of logging methods also accept an optional callback function that will be called with the `Result` of the log sending operation.
