BUILD_TARGET=SimpleGeo
TEST_TARGET=Tests
SDK=macosx10.6
COMMAND=xcodebuild

default:
	$(COMMAND) -target $(BUILD_TARGET) -configuration Release -sdk $(SDK) build

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf Build/

test::
	GHUNIT_AUTORUN=1 GHUNIT_AUTOEXIT=1 $(COMMAND) -target $(TEST_TARGET) -configuration Debug -sdk $(SDK) build
