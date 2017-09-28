<h2>Test Plan</h2>
How to test:
___________________

Testing Geo AlwaysUsage:
++++++++++++++++++++++++

1. Using an Ti SDK with this patch applied create a test app ( in classic mode )
2. Update the app.js with this sampel https://gist.github.com/benbahrenburg/c4c992c8c61d197510ea#how-to-test-this
4. Open the tiapp.xml in the ios / plist / dict section add the below:
~~~
<key>NSLocationAlwaysUsageDescription</key>
<string>Test NSLocationAlwaysUsageDescription</string>
~~~

5. Compile and push to your device or the simulator. Please note you must target iOS8.
6. Press the btnAuthorization button, you should see a message that says Ti.Geolocation.AUTHORIZATION_UNKNOWN
7. Press the btnGeoTest button, you should now see the permission box with the message Test NSLocationAlwaysUsageDescription
8. Press the approve button
9. You should now see the event below fire
~~~
Ti.Geolocation.addEventListener('authorization',function(e){
	Ti.API.info('authorization event:' + JSON.stringify(e));
});
~~~
10. Press the btnAuthorization button, you should now see an alert with Ti.Geolocation.AUTHORIZATION_ALWAYS or Ti.Geolocation.AUTHORIZATION_AUTHORIZED


Testing Geo In Usage Permission:
++++++++++++++++++++++++

1. Next reset your simulator or uninstall the app from your device
2. Remove the NSLocationAlwaysUsageDescription settings from your tiapp.xml
3. Open the tiapp.xml in the ios / plist / dict section add the below:
~~~
<key>NSLocationWhenInUseUsageDescription</key>
<string>Test NSLocationWhenInUseUsageDescription</string>
~~~
4. Compile and push to your device or the simulator. Please note you must target iOS8.
5. Press the btnAuthorization button, you should see a message that says Ti.Geolocation.AUTHORIZATION_UNKNOWN
6. Press the btnGeoTest button, you should now see the permission box with the message Test NSLocationWhenInUseUsageDescription
7. Press the approve button
8. You should now see the event below fire
~~~
Ti.Geolocation.addEventListener('authorization',function(e){
	Ti.API.info('authorization event:' + JSON.stringify(e));
});
~~~
9. Press the btnAuthorization button, you should now see an alert with Ti.Geolocation.AUTHORIZATION_WHEN_IN_USE
10. Next reset your simulator or uninstall the app from your device


Testing what happens if you have both NSLocationWhenInUseUsageDescription and NSLocationAlwaysUsageDescription
++++++++++++++++++++++++

1. Next reset your simulator or uninstall the app from your device
2. Open the tiapp.xml in the ios / plist / dict section add the below:
~~~
<key>NSLocationWhenInUseUsageDescription</key>
<string>Test NSLocationWhenInUseUsageDescription</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Test NSLocationAlwaysUsageDescription</string>
~~~
4. Compile and push to your device or the simulator. Please note you must target iOS8.
5. Press the btnAuthorization button, you should see a message that says Ti.Geolocation.AUTHORIZATION_UNKNOWN
6. Press the btnGeoTest button, you should now see the permission box with the message Test NSLocationAlwaysUsageDescription
7. Press the approve button
8. You should now see the event below fire
~~~
Ti.Geolocation.addEventListener('authorization',function(e){
	Ti.API.info('authorization event:' + JSON.stringify(e));
});
~~~
9. Press the btnAuthorization button, you should now see an alert with Ti.Geolocation.AUTHORIZATION_ALWAYS or Ti.Geolocation.AUTHORIZATION_AUTHORIZED
10. Next reset your simulator or uninstall the app from your device

Testing iOS7 Support
++++++++++++++++++++++++

1. Next reset your simulator or uninstall the app from your device
2. Open the tiapp.xml in the ios / plist / dict section add the below:
~~~
<key>NSLocationWhenInUseUsageDescription</key>
<string>Test NSLocationWhenInUseUsageDescription</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Test NSLocationAlwaysUsageDescription</string>
~~~
4. Compile and push to your device or the simulator. Please note you must target iOS7.
5. Press the btnAuthorization button, you should see a message that says Ti.Geolocation.AUTHORIZATION_UNKNOWN
6. Press the btnGeoTest button, you should now see the permission box with the text provided as part of the purpose
7. Press the approve button
8. You should now see the event below fire
~~~
Ti.Geolocation.addEventListener('authorization',function(e){
	Ti.API.info('authorization event:' + JSON.stringify(e));
});
~~~
9. Press the btnAuthorization button, you should now see an alert with Ti.Geolocation.AUTHORIZATION_ALWAYS or Ti.Geolocation.AUTHORIZATION_AUTHORIZED
