# KickIt - iOS SDK

This project was created to integrate Apple apps with the [KickIt](https://www.kickit.dev) service.

Here's an example of how the SDK can be used:

```swift
@State private var shouldCloseApp = Optional(false)
// ...
func checkAppDeprecation() {
  var kickItResponse: KickItResponse?
  do {
    let sdk = try KickItSdk.init(bundle: .main, processInfo: .processInfo, parameters: ["dummy" : "app"], urlSession: .shared)
    sdk.checkApplicationDeprecation { result in
      kickItResponse = try! result.get()
      logger.log("Checking app deprecation")
      logger.log("Response \(kickItResponse.debugDescription)")

      showingAlert = kickItResponse!.matched
      alertMessage = kickItResponse!.message
      shouldCloseApp = kickItResponse?.hardDeprecation
      logger.log("Executed app deprecation check")
    }
  } catch {
    logger.log("Error")
  }
}
// ...
func alert() -> Alert {
  if shouldCloseApp != nil && shouldCloseApp! {
    return Alert(title: Text("Heads up!"), message: Text(alertMessage), dismissButton: .default(Text("Close"), action: {
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
      }
    }))
  } else {
    return Alert(title: Text("Heads up!"), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
  }
}
// ...
.onAppear(perform: checkAppDeprecation)
// ...
.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
  checkAppDeprecation()
  self.alert(isPresented: $showingAlert) {
    alert()
  }
}
```

With the code above the app will close always for forced upgrades blocking the user from using the app. And for soft upgrades it will only display a message and allow the user to continue.
