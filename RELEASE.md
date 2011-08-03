# Release Checklist

## Prep

* update version numbers (`Global.xcconfig`, `Doxyfile`)
* run tests
* update `CHANGELOG.md` and add release date
* tag release version (`git tag x.x.x`)
* commit w/ "x.x.x release" message

## Build

Build the OS X framework:

    $ make
    $ cd build/Release
    $ tar zcf /tmp/SimpleGeo-x.x.x.tgz SimpleGeo.framework
    $ cd -

Build the iOS framework:

    $ cd iOS
    $ make dist
    $ mv SimpleGeo-iOS.tgz /tmp/SimpleGeo-iOS-x.x.x.tgz
    $ cd -

## Docs

Build the docs and the docset:

    $ make docs
    $ cd docs/html
    $ make
    $ tar zcf /tmp/SimpleGeo-x.x.x-docset.tgz
    $ cd -

Copy docs into `{VERSION}/` in `gh-pages` branch:

    $ git checkout gh-pages
    $ mkdir x.x.x
    $ cp -R docs/html/* x.x.x/
    $ git commit -m "Docs for x.x.x"

## Framework branches

Copy the framework build into `framework` branch:

    $ git checkout framework
    $ rm -rf *
    $ tar zxf /tmp/SimpleGeo-x.x.x.tgz
    $ mv SimpleGeo.framework/* .
    $ rmdir SimpleGeo.framework

Sanity check it:

    $ git status

Commit and tag the framework branch w/ version:

    $ git commit -am "Version x.x.x"
    $ git tag x.x.x-framework

Copy the iOS framework build into `framework-ios` branch:

    $ git checkout framework-ios
    $ rm -rf *
    $ tar zxf /tmp/SimpleGeo-iOS-x.x.x.tgz
    $ mv SimpleGeo.framework/* .
    $ rmdir SimpleGeo.framework

Sanity check it:

    $ git status

Commit and tag the iOS framework branch w/ version:

    $ git commit -am "Version x.x.x"
    $ git tag x.x.x-framework-ios

## Push branches to GitHub

Reset your repository:

    $ git checkout master

Push to GitHub (make sure that all 4 branches get sent):

    $ git push
    $ git push --tags

## Upload tarballs to GitHub

* Upload `/tmp/SimpleGeo*.tgz` to https://github.com/simplegeo/SimpleGeo.framework/downloads
