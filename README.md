# AirView

A simple SwiftUI wrapper to display SwiftUI content on external AirPlay display such as Apple TV or any Mac

![example](https://github.com/AcrylicMadness/AirView/assets/5305147/32e17683-a5a8-49e6-90d4-3ea1572cac50)

## Installation

AirView can be installed using Swift Package Manager:
```swift
dependencies: [
    .package(url: "https://github.com/AcrylicMadness/AirView.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

Use `.airView(isScreenConnected:content:)`. For example:

```swift
import AirView
import SwiftUI

struct ContentView: View {
    
    @State var isScreenConnected: Bool = false
    
    var body: some View {
        VStack {
            Text("External screen status: \(isScreenConnected ? "✅" : "❌")")
        }
        .airView(isScreenConnected: $isScreenConnected) {
            Text("Hello, screen!")
                .font(.system(size: 60))
        }
    }
}
```
