default: release

# Create a Universal binary (iOS + Simulator)
release:
	xcodebuild -target SimpleGeo -configuration Release -sdk iphoneos build
	xcodebuild -target SimpleGeo -configuration Release -sdk iphonesimulator build
	-lipo -create Build/Release-iphoneos/SimpleGeo.framework/SimpleGeo Build/Release-iphonesimulator/SimpleGeo.framework/SimpleGeo -output Build/Release-iphoneos/SimpleGeo.framework/SimpleGeo
	-strip -S Build/Release-iphoneos/SimpleGeo.framework/SimpleGeo

dist: clean release
	cd Build/Release-iphoneos/ && tar zcf ../../SimpleGeo-iOS.tgz SimpleGeo.framework/

clean:
	-rm -rf Build
	-rm SimpleGeo-iOS.tgz
