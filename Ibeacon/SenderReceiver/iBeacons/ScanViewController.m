//
//  ScanViewController.m
//  iBeacons
//
//  Created by Christopher Constable on 3/19/14.
//  Copyright (c) 2014 The Analog School. All rights reserved.
//

#import "ScanViewController.h"

@import CoreLocation;

@interface ScanViewController () <CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *uuidTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyIdTextField;

- (IBAction)rescanButtonPressed:(id)sender;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.uuidTextField.text = kBeaconDefaultUUID;
    self.companyIdTextField.text = kBeaconDefaultCompanyIdentifier;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
	
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self rescanButtonPressed:self];
    
    
    
    
    
    
    
    
    
    
    
    //**********
    [CLLocationManager locationServicesEnabled];
    
    /*if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [CLLocationManager requestAlwaysAuthorization];
        }else if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]){
            [CLLocationManager  requestWhenInUseAuthorization];
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
    }*/
    
    //**********

}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    self.statusLabel.text = @"Error :(";
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"Did enter region: %@", region);
    self.statusLabel.text = @"Entered Region";
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    NSLog(@"Did exit region: %@", region);
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.statusLabel.text = @"Exited Region";
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    if (beacons.count) {
        NSLog(@"Did range beacons: %@ in region: %@", beacons, region);
        CLBeacon *foundBeacon = [beacons firstObject];
        NSString *displayString = @"Beacon found: ";
        if (foundBeacon.proximity == CLProximityUnknown) {
            displayString = [displayString stringByAppendingString:@"Unknown"];
        }
        else if (foundBeacon.proximity == CLProximityFar) {
            displayString = [displayString stringByAppendingString:@"Far"];
        }
        else if (foundBeacon.proximity == CLProximityNear) {
            displayString = [displayString stringByAppendingString:@"Near"];
        }
        else if (foundBeacon.proximity == CLProximityImmediate) {
            displayString = [displayString stringByAppendingString:@"Immediate"];
        }
        self.statusLabel.text = displayString;
    }
    else {
        NSLog(@"No beacons found.");
        self.statusLabel.text = @"Scanning...";
    }
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}

#pragma mark - Actions

- (void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)rescanButtonPressed:(id)sender {
    self.statusLabel.text = @"Scanning...";
    
    // Stop ranging any beacons we previously were...
    if (self.beaconRegion) {
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
    
    // Start ranging new beacon...
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.uuidTextField.text];
      self.beaconRegion=[[CLBeaconRegion alloc]initWithProximityUUID:uuid major:1000 minor:1000 identifier:@"com.persistentsys.beacon" ];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"Started ranging beacons.");
  
    }




- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
    }
    
    // If Location Services are disabled, restricted or denied.
    if ((![CLLocationManager locationServicesEnabled])
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
        || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        // Send the user to the location settings preferences
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
    }
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];
        NSLog(@"Couldn't turn on monitoring: Location services not authorised.");
    }
    
    
    
    if (![CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        //Get user's current location
            NSLog(@"Couldn't turn on monitoring: Location services not authorised.");
        
    }
    
    
    
    
 /*
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                           NUMINT([CLLocationManager authorizationStatus]),@"authorizationStatus",nil];
    
    if ([self _hasListeners:@"authorization"])
    {
        [self fireEvent:@"authorization" withObject:event];
    }*/

}



/*

-(NSNumber*)AUTHORIZATION_ALWAYS
{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
        return NUMINT(kCLAuthorizationStatusAuthorizedAlways);
    }
    return NUMINT(0);
}

-(NSNumber*)AUTHORIZATION_WHEN_IN_USE
{
    if ([([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
        return NUMINT(kCLAuthorizationStatusAuthorizedWhenInUse);
    }
    return NUMINT(0);
}
*/

@end
