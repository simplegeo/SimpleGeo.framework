# Change Log

## 1.2.0 - 3/2/11

* Storage support

## 1.1.6 - 1/27/11

* Categories support
* Fixed some documented memory leaks

## 1.1.5 - 1/12/11

* Don't call delegate methods when they're not implemented; warn instead
* Moved potentially conflicting symbols in `NSString`
* Refactored OAuth implementation to no longer conflict with Basic Auth
* Fixed some potential memory leaks

## 1.1.4 - 1/7/11

* Add a missing retain that was causing invalid pointers in `SGFeature`

## 1.1.3 - 1/4/11

* Properly URL-encode strings
* Always pass radius through when it's provided

## 1.1.2 - 1/1/11

* More complete namespacing of `Base64Transcoder`

## 1.1.1 - 1/1/11

* Support for `zoom` in SimpleGeo Features
* Unicode characters are encoded properly 
* `Base64Transcoder` has been namespaced to avoid conflicts (usually with other
  libraries that use OAuth) 
* No need to `#import <SimpleGeo/SimpleGeo+Context.h>`, etc. any longer
* iOS framework build

## 1.1 - 12/22/10

* Support for `radius` in SimpleGeo Places
* Support for address queries against SimpleGeo Context + SimpleGeo Places
* Changed `didLoadContext:(NSDictionary *)for:(SGPoint *)` to
  `didLoadContext:(NSDictionary *)forQuery:(NSDictionary *)` in
  `SimpleGeoContextDelegate`
* Changed `didLoadPlaces:(SGFeatureCollection *)near:(SGPoint *):matching:(NSString *):inCategory:(NSString *)`
  to `didLoadPlaces:(SGFeatureCollection *)forQuery:(NSDictionary *)` in
  `SimpleGeoPlacesDelegate`
* Changed `didUpdatePlace:(NSString *)token:(NSString *)` to
  `didUpdatePlace:(SGFeature *)handle:(NSString *)token:(NSString *)` in
  `SimpleGeoPlacesDelegate`
* Changed `getContext:(SGPoint *)` to `getContextForPoint:(SGPoint *)` in
  `SimpleGeo+Context`
* `SimpleGeo` `delegate` property is now read/write

## 1.0 - 12/8/10

* Initial release
