# SimpleGeo.framework

`SimpleGeo.framework` is an Objective-C client library for the SimpleGeo API, suitable for use in both Mac OS X and iOS applications.

## Downloading the Framework

`SimpleGeo.framework` is available as either a [downloadable ZIP
file](https://github.com/simplegeo/SimpleGeo.framework/downloads) or a branch suitable for use as a [git
submodule](http://book.git-scm.com/5_submodules.html). In either case, you'll want to place the framework in a subdirectory beneath your app.

Here's an example of adding `SimpleGeo.framework` as a submodule:

    $ git submodule add -b framework-ios \
      git://github.com/simplegeo/SimpleGeo.framework.git Resources/SimpleGeo.framework

## Embedding in an iOS Application

Once `SimpleGeo.framework` has been placed in a subdirectory beneath your app, drag it into your Xcode project; it will show up as a linked framework.

Add the following additional frameworks to your project by clicking on your Target, choosing the "Build Phases" tab, and using the `+` button at the bottom of the "Linked Libraries" section:

* Foundation
* UIKit
* CoreGraphics
* CFNetwork
* SystemConfiguration
* MobileCoreServices
* CoreLocation
* MapKit
* libz
* SimpleGeo (if it's not already present)

Non-system frameworks must be statically linked to your application (iOS does not allow embedded frameworks), so you'll need to add `-ObjC` and `-all_load` to "Other Linker Flags" (accessible via the "Linking" section under your Target's  "Build Settings" tab).

[SimpleGeo-iOS](https://github.com/simplegeo/SimpleGeo-iOS) is an example of an iOS application built using `SimpleGeo.framework`.

## Embedding in a Cocoa Application

Once `SimpleGeo.framework` has been placed in a subdirectory beneath your app, drag it into your Xcode project; it will show up as a linked framework.

Add the following additional frameworks to your project by clicking on your Target, choosing the "Build Phases" tab, and using the `+` button at the bottom of the "Linked Libraries" section:

* CoreServices
* SystemConfiguration
* libz
* SimpleGeo (if it's not already present)

[SimpleGeo-Mac](https://github.com/simplegeo/SimpleGeo-Mac) is an example of a Cocoa application built using `SimpleGeo.framework`.

## Getting Started

If you'd like help getting started with some basic tutorials, visit our [Objective-C tutorials](https://simplegeo.com/docs/tutorials/objective-c) page.

## Working from Source

You may download and modify the `SimpleGeo.framework` source code to meet custom needs. If you make edits that may be appreciated by others, please submit a GitHub pull request.

### Downloading Dependencies

`SimpleGeo.framework` depends on the following codebases:

* [`SGObjCHTTP`](https://github.com/simplegeo/SGObjCHTTP) (a git submodule)
* [`GHUnit.framework`](https://github.com/gabriel/gh-unit/downloads) (a testing framework)

An included script can get you up and running quickly. To download and update dependencies, simply run:

	./Scripts/update-dependencies

The script does the following:

* Downloads [`GHUnit.framework`](https://github.com/gabriel/gh-unit/downloads) into the framework's Project/Mac/Tests/Resources/ directory
* Runs `$ git submodule update --init` to download and update the [`SGObjCHTTP`](https://github.com/simplegeo/SGObjCHTTP) submodule.
* Runs `$ git submodule update --init` for [`SGObjCHTTP`](https://github.com/simplegeo/SGObjCHTTP) sub-dependencies.

### Building for iOS

To generate a usable `SimpleGeo.framework` for iOS from the command-line:

	$ cd Project/iOS
	$ make

The resulting framework will appear in `Project/iOS/Build/Release-iphoneos`.

Building from the command-line will create an über-Universal framework, built for `armv6` and `armv7` devices as well as the iOS Simulator.

### Building for OS X

To generate a usable `SimpleGeo.framework` for OS X from the command-line:

	$ cd Project/Mac
   $ make

The resulting framework will appear in `Project/Build/Release`.

### Docs

To generate html docs and install a handy Xcode docset:

	$ cd Documentation
   $ make

## Support

`SimpleGeo.framework` is fully supported by SimpleGeo. If you have any questions, comments, or bug reports, please contact us via our Google Groups [support page.](https://groups.google.com/forum/#!forum/simplegeo)
