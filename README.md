# GPX Capture Tool for iOS
This is a simple iOS App written in Objective-C that allows you to record your location and movement into a GPX file compatible with XCode. You can then use this GPX file to debug location-based applications, such as navigation and fitness apps.

This app is also a simple example of an iOS location-based application, and it can be used for teaching purposes.

### Example

```xml
<gpx>
<wpt lat="-23.562163" lon="-46.663258"><ele>794.211792</ele><time>2015-08-24T15:36:17Z</time></wpt>
<wpt lat="-23.562040" lon="-46.663267"><ele>790.816040</ele><time>2015-08-24T15:36:18Z</time></wpt>
<wpt lat="-23.562434" lon="-46.663912"><ele>794.616211</ele><time>2015-08-24T15:36:19Z</time></wpt>
</gpx>
```

### Requirements
* XCode 6+
* iOS 8+

### Uses
* [Nick Lockwood's XMLDictionary](https://github.com/nicklockwood/XMLDictionary)

### Useful links
[Using Xcode to Test Location Services by Nick Arnott](https://possiblemobile.com/2013/04/using-xcode-to-test-location-services/)
