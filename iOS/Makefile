default: release

# Create a Universal binary (iOS + Simulator)
release:
	xcodebuild -target SimpleGeo -configuration Release -sdk iphoneos build
	xcodebuild -target SimpleGeo -configuration Release -sdk iphonesimulator build
	-lipo -create build/Release-iphoneos/SimpleGeo.framework/SimpleGeo build/Release-iphonesimulator/SimpleGeo.framework/SimpleGeo -output build/Release-iphoneos/SimpleGeo.framework/SimpleGeo
	-strip -S build/Release-iphoneos/SimpleGeo.framework/SimpleGeo

dist: clean release
	cd build/Release-iphoneos/ && tar zcf ../../SimpleGeo-iOS.tgz SimpleGeo.framework/

clean:
	-rm -rf build
	-rm SimpleGeo-iOS.tgz
