# SimpleGeo.framework

This is an Objective-C client library for the SimpleGeo API, suitable for use
in both Mac OS X and iOS applications.

`Simplegeo.framework` uses [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) along
with [ASIHTTPRequest+OAuth](https://github.com/AlterTap/asi-http-request-oauth.git) to submit
requests to the SimpleGeo API. These github repositories are declared as
submodules in the codebase so we'll need to run:

    $ git submodule update --init

## Embedding in a Cocoa Application

In order to embed `SimpleGeo.framework` into a Cocoa application, you'll first
have to add [`YAJL.framework`](https://github.com/gabriel/yajl-objc/downloads)
to your project and follow Apple's instructions for [Embedding a Private
Framework in Your Application
Bundle](http://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/CreatingFrameworks.html#//apple_ref/doc/uid/20002258-106880).

`SimpleGeo.framework` is available as either a [downloadable ZIP
file](https://github.com/simplegeo/SimpleGeo.framework/downloads) or a branch
suitable for use as a [git
submodule](http://book.git-scm.com/5_submodules.html). In either case, you'll
want to put it in a subdirectory beneath your app. Here's an example of adding
it as a submodule:

    $ git submodule add -b framework \
      git://github.com/simplegeo/SimpleGeo.framework.git ext/SimpleGeo.framework

Once it's been added to `ext/`, drag it into your Xcode project and it will
show up as a linked Framework.

Add the following additional frameworks to your project by right-clicking on
the target, choosing the "General" tab, and using the `+` button at the bottom
of the window to add "Linked Libraries":

* CoreServices
* SystemConfiguration
* libz
* YAJL (if it's not already present)
* SimpleGeo (if it's not already present)

[SimpleApp](https://github.com/simplegeo/SimpleApp) is an example of a Cocoa
application built using this framework.

## Embedding in an iOS Application

In order to embed `SimpleGeo.framework` into an iOS application, you'll first
have to add [`YAJL.framework`](https://github.com/gabriel/yajl-objc/downloads)
(the iOS variant) to your project.

`SimpleGeo.framework` is available as either a [downloadable ZIP
file](https://github.com/simplegeo/SimpleGeo.framework/downloads) or a branch
suitable for use as a [git
submodule](http://book.git-scm.com/5_submodules.html). In either case, you'll
want to put it in a subdirectory beneath your app. Here's an example of adding
it as a submodule:

    $ git submodule add -b framework-ios \
      git://github.com/simplegeo/SimpleGeo.framework.git ext/SimpleGeo.framework

Once it's been added to `ext/`, drag it into your Xcode project and it will
show up as a linked Framework.

Add the following additional frameworks to your project by right-clicking on
the target, choosing the "General" tab, and using the `+` button at the bottom
of the window to add "Linked Libraries":

* Foundation
* UIKit
* CFNetwork
* SystemConfiguration
* MobileCoreServices
* CoreGraphics
* libz
* YAJL (if it's not already present)
* SimpleGeo (if it's not already present)

Non-system frameworks must be statically linked to your application (iOS does
not allow embedded frameworks), so you'll need to add `-ObjC` and `-all_load`
to your "Linker Flags" (accessible via the "Build" tab in the Target Info
window).

[SimpleGeo-iPhone](https://github.com/simplegeo/SimpleGeo-iPhone) is an example
of an iOS application built using this framework.

## Developing

### Getting Started

In order to run the framework tests, you'll need to install `GHUnit.framework`
into `/Library/Frameworks` (or somewhere similar). Look for the most recent
version of `GHUnit-*.zip` on the [gh-unit](https://github.com/gabriel/gh-unit)
[Downloads page](https://github.com/gabriel/gh-unit/downloads).

For network tests to succeed, you'll want to clone and start the mock SimpleGeo
server:

    $ git submodule update --init
    $ ruby -rubygems server/server.rb

If it worked, it should say something like:

    == Sinatra/1.1.0 has taken the stage on 4567 for development with backup from Mongrel

If it failed, install the dependencies and try again:

    $ sudo gem install oauth json sinatra

To actually run the tests, choose "Tests" as the *Active Target* (via the
*Project* menu) and click "Build and Run".

### Building for OS X

To generate a usable `SimpleGeo.framework` for OS X from the command-line:

    $ make

The resulting Framework will be in `build/Release`.

### Building for iOS

To generate a usable `SimpleGeo.framework` for iOS from the command-line:

    $ cd iOS
    $ make

The resulting Framework will be in `iOS/build/Release-iphoneos`.

Building from the command-line will create an über-Universal Framework, built
for `armv6`, `armv7` devices *as well as the Simulator*.

### Docs

To generate docs, make sure you've got `doxygen` installed (`brew install
doxygen`, for example), then:

    $ make docs

If you'd like a handy-dandy Xcode docset:

    $ cd docs/html/
    $ make

You can either run `make install` in `docs/html/` to install the docset into
your home directory, or you can do whatever you wish with the
`SimpleGeo.docset` that was created there.
