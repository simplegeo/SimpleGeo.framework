BUILD_TARGET=SimpleGeo
TEST_TARGET=Tests
SDK=macosx10.5
COMMAND=xcodebuild

default:
	$(COMMAND) -target $(BUILD_TARGET) -configuration Release -sdk $(SDK) build

# If you need to clean a specific target/configuration: $(COMMAND) -target $(TARGET) -configuration DebugOrRelease -sdk $(SDK) clean
clean:
	-rm -rf build/*
	-rm -rf docs/

docs:
	doxygen

test::
	GHUNIT_AUTORUN=1 GHUNIT_AUTOEXIT=1 $(COMMAND) -target $(TEST_TARGET) -configuration Debug -sdk $(SDK) build

	
