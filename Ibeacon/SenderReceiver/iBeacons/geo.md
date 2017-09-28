<h2>Fixing Geo Location Permissions in iOS8</h2>

In iOS8, Apple has changed how geo location permissions work.  This gist outlines an approach to fix this so Geo will continue to work in iOS8.

Before getting started with the code change, we need to update the tiapp.xml with a few keys.

If you wish to have Geo always run, you need to add the below key.  The key NSLocationAlwaysUsageDescription is used when requesting permission to use location services whenever the app is running.  To enable this, add the below to the tiapp.xml:

<key>NSLocationAlwaysUsageDescription</key>
<string>Reason that appears in the authorization prompt</string>

If you wish to use Geo when your app is in the foreground, you need to add the below key.  The key NSLocationWhenInUseUsageDescription is used when requesting permission to use location services while the app is in the foreground. To enable this, add teh below to the tiapp.xml

<key>NSLocationWhenInUseUsageDescription</key>
<string>Reason that appears in the authorization prompt</string>

What happens if I add both NSLocationAlwaysUsageDescription and NSLocationWhenInUseUsageDescription keys to my tiapp.xml? In this case we assume you want the highest level access right and use the NSLocationAlwaysUsageDescription key.

Now to the code changes, first... we need to open GeolocationModule.m

Next we need to add some default behavior to the -(CLLocationManager*)locationManager method.

To do this scroll down to where you see the purpose logic in your method, and replace that block with the one below.  This will kill two birds with one stone and remove the purpse section if you are running iOS8. You will notice we will automatically add the correct permission based on their tiapp.xml entries.  This makes it easy for backwards compatability.

~~~
         if ([TiUtils isIOS8OrGreater]) {
             if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                 [locationManager requestAlwaysAuthorization];
             }else if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]){
                [locationManager  requestWhenInUseAuthorization];
             }else{
                  NSLog(@"[ERROR] The keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription are not defined in your tiapp.xml.  Starting with iOS8 this are required.");
             }
         }else{
             if (purpose==nil)
             {
                 DebugLog(@"[WARN] The Ti.Geolocation.purpose property must be set.");
             }
             else
             {
                 [locationManager setPurpose:purpose];
             }
         }
~~~

Next we need to add some properties.  The developer will be able to use this when checking their permission status. In the GeolocationModule.m file scroll to the property section and add the below.
~~~
-(NSNumber*)AUTHORIZATION_ALWAYS
{
    if ([TiUtils isIOS8OrGreater]) {
        return NUMINT(kCLAuthorizationStatusAuthorizedAlways);
    }
    return NUMINT(0);
}

-(NSNumber*)AUTHORIZATION_WHEN_IN_USE
{
    if ([TiUtils isIOS8OrGreater]) {
        return NUMINT(kCLAuthorizationStatusAuthorizedWhenInUse);
    }
    return NUMINT(0);
}
~~~

Finally, we need to listen for the authorization change event. Scroll towards the end of the file and you will see all of the delegate methods.  Add the below to this section of your code.  This will fire an event off the Ti.Geolocation namespace called authorization.

~~~
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                           NUMINT([CLLocationManager authorizationStatus]),@"authorizationStatus",nil];

    if ([self _hasListeners:@"authorization"])
    {
        [self fireEvent:@"authorization" withObject:event];
    }
}
~~~