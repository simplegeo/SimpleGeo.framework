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

## Building

To generate a usable `SimpleGeo.framework` from the command-line:

    $ make

The resulting Framework will be in `build/Release`.

## Docs

To generate docs, make sure you've got `doxygen` installed (`brew install
doxygen`, for example), then:

    $ make docs

If you'd like a handy-dandy Xcode docset:

    $ cd docs/html/
    $ make

You can either run `make install` in `docs/html/` to install the docset into
your home directory, or you can do whatever you wish with the
`SimpleGeo.docset` that was created there.
