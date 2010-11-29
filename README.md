# SimpleGeo.framework

This is an Objective-C client library for the SimpleGeo API, suitable for use
in both Mac OS X and iOS applications.

## Getting Started

In order to run the framework tests, you'll need to install `GHUnit.framework`
into `/Library/Frameworks` (or somewhere similar). Look for the most recent
version of `GHUnit-*.zip` on the [gh-unit](https://github.com/gabriel/gh-unit)
[Downloads page](https://github.com/gabriel/gh-unit/downloads).

You'll also need to install `YAJL.framework`. Same deal, but this time, grab
the latest `YAJL-*.zip` from the
[yajl-objc](https://github.com/gabriel/yajl-objc) [Downloads
page](https://github.com/gabriel/yajl-objc/downloads).

For network tests to succeed, you'll want to start the mock SimpleGeo server:

    $ ruby -rubygems server/server.rb

If it worked, it should say something like:

    == Sinatra/1.1.0 has taken the stage on 4567 for development with backup from Mongrel

If it failed, install the dependencies and try again:

    $ sudo gem install oauth json sinatra

To actually run the tests, choose "Tests" as the *Active Target* (via the
*Project* menu) and click "Build and Run".
