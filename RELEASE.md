# Release Checklist

## Prep

* update version numbers (`Global.xcconfig`, `Doxyfile`)
* run tests
* update `CHANGELOG.md` and add release date
* commit w/ "x.x.x release" message
* tag release version (`git tag x.x.x`)

## Build

* build the OS X framework:

    $ make
    $ cd build/Release
    $ tar zcf /tmp/SimpleGeo-x.x.x.tgz SimpleGeo.framework
    $ cd -

* build the iOS framework:

    $ cd iOS
    $ make dist
    $ mv SimpleGeo-iOS.tgz /tmp/SimpleGeo-iOS-x.x.x.tgz
    $ cd -

## Docs

* `make docs`
* copy docs into `{VERSION}/` in `gh-pages` branch:

    $ git checkout gh-pages
    $ mkdir x.x.x
    $ cp -R docs/html/* x.x.x/
    $ git commit -m "Docs for x.x.x"

* build and upload docset to GitHub:

    $ cd docs/html
    $ make
    $ tar zcf /tmp/SimpleGeo-x.x.x-docset.tgz
    $ cd -

## Framework branches

* copy framework build into `framework` branch:

    $ git checkout framework
    $ rm -rf *
    $ tar zxf /tmp/SimpleGeo-x.x.x.tgz
    $ mv SimpleGeo.framework/* .
    $ rmdir SimpleGeo.framework

* sanity check it:

    $ git status

* commit and tag framework branch w/ version:

    $ git commit -am "Version x.x.x"
    $ git tag x.x.x-framework

* copy iOS framework build into `framework-ios` branch:

    $ git checkout framework-ios
    $ rm -rf *
    $ tar zxf /tmp/SimpleGeo-iOS-x.x.x.tgz
    $ mv SimpleGeo.framework/* .
    $ rmdir SimpleGeo.framework

* sanity check it:

    $ git status

* commit and tag iOS framework branch w/ version:

    $ git commit -am "Version x.x.x"
    $ git tag x.x.x-framework-ios

## Push branches to GitHub

* reset your repository:

    $ git checkout master

* push to GitHub (make sure that all 4 branches get sent):

    $ git push
    $ git push --tags

## Upload tarballs to GitHub

* Upload `/tmp/SimpleGeo*.tgz` to https://github.com/simplegeo/SimpleGeo.framework/downloads