# Release Checklist

* update version numbers (`src/SimpleGeo+Internal.m`, `Info.plist`)
* run tests
* update `CHANGELOG.md` and add release date
* tag release version
* copy docs into `{VERSION}/` in `gh-pages` branch
* upload docset to GitHub
* copy framework build into `framework` branch
* tag framework branch w/ version
* upload framework to GitHub
* copy iOS framework built into `framework-iOS` branch
* tag iOS framework branch w/ version
* upload iOS framework to GitHub
