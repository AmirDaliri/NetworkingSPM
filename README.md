# Networking

A Swift package for networking using Alamofire.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Features

- Provide a brief description of the key features of your networking package.

## Requirements

- Swift 5.9
- iOS 13 or later

## Installation

You can integrate this package into your project using Swift Package Manager (SPM).

### Swift Package Manager (SPM)

To add `Networking` to your project, open your `Package.swift` file and add the following dependency:

```swift
dependencies: [
    .package(url: "https://bitbucket.org/wiyuw-dev/networking/src/master/.git", .upToNextMajor(from: "1.0.0"))
],
targets: [
    .target(
        name: "YourTargetName",
        dependencies: ["Networking"]
    ),
]
