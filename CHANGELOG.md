# Change Log

## 2.0.2 - 8/23/11

* armv6 was missing from the compiled iOS static library

## 2.0.1 - 8/22/11

* Fixed a bug in the bounding box query for nearby records
* Wrapped all memory management methods within a pre-processor macro
* No longer required to set `all_load` or `ObjC` as other linking flags

## 2.0 - 8/3/11

* Complete rewrite. SGQuery object, new SGObject model, streamlined request methods, SGCallbacks with block support, and much more.

## 1.3.0 - 6/8/11

* SSL support (this will be automatically enabled unless you specify `NO` in
  the `clientWithDelegate:consumerKey:consumerSecret:useSSL:` convenience
  constructor)
* Deprecated `SIMPLEGEO_URL_PREFIX` in favor of `SIMPLEGEO_HOSTNAME`
* Added the following Mapkit convenience methods for iOS:
    * `- (CLLocationCoordinate2D)coordinate` (`SGPoint`)
    * `- (NSArray *)overlays` (`SGGeometry`)
    * `- (MKPolygon *)asMKPolygon` (`SGPolygon`)
    * `- (NSArray *)asMKPolygons` (`SGMultiPolygon`)
* Improved `SGFeature` `isEqual:` to match on feature ids.
* Added `containsPoint:` to `SGPolygon` and `SGMultiPolygon`
* Added `isInsidePolygon:` to `SGPoint`

## 1.2.3 - 4/30/11

* Tracked down some Zombies that were causing crashes under mysterious
  conditions (connection failures, mostly)
* Mild spring cleaning
* Stripped debug symbols from library to avoid warnings when linking

## 1.2.2 - 4/8/11

* Exposed missing headers
* Support for `num` parameter in Places (as `count`)

## 1.2.1 - 3/11/11

* Support for layer manipulation

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
