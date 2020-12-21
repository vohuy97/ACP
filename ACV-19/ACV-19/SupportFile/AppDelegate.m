//
//  AppDelegate.m
//  MapCao
//
//  Created by VoHuy on 2020/01/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "AppDelegate.h"
#import "Constains.h"
#import "Utils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyD1hetNrqSJSqW__fLzcxf3RHXHzFDuU_k"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.MapTotalVC = [[MapTotalViewController alloc] init];
//    self.daNangMapVC.latitude = 16.030419;
//    self.daNangMapVC.longtitude = 108.223344;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.MapTotalVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -location-

+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        AppDelegate *instance = sharedInstance;
        instance->locationManager = [CLLocationManager new];
        instance->locationManager.delegate = instance;
        instance->locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        instance->locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        instance->locationManager.pausesLocationUpdatesAutomatically = true;
    });
    return sharedInstance;
}

- (void)startUpdatingLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied){
        NSLog(@"Location services are disabled in settings.");
    } else{
        // for iOS 8
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
        // for iOS 9
        if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]){
        }
        [locationManager startUpdatingLocation];
        [locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
}

- (float)getLatitude {
    return locationManager.location.coordinate.latitude;
}

- (float)getLongitude {
    return locationManager.location.coordinate.longitude;

}

- (CLLocation *)getLocation {
    return locationManager.location;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        static id sharedInstance = nil;
        sharedInstance = [AppDelegate sharedInstance];
        AppDelegate *instance = sharedInstance;
        instance->locationManager.allowsBackgroundLocationUpdates = NO;
        [[AppDelegate sharedInstance]startUpdatingLocation];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        static id sharedInstance = nil;
        sharedInstance = [AppDelegate sharedInstance];
        AppDelegate *instance = sharedInstance;
        instance->locationManager.allowsBackgroundLocationUpdates = YES;
        [[AppDelegate sharedInstance]startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"heheehehehehehehe");
    CLLocation *mostRecentLocation = locations.lastObject; // current location
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PATIENT_INFO];
    NSArray *patientInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    float distant = 100;
    NSMutableArray *positionArr = [[NSMutableArray alloc] init];
    BOOL showedPopup = YES;
    if (patientInfo.count > 0) {
        for (int i = 0; i < patientInfo.count; i++) {
            NSString *lat = [patientInfo[i] objectForKey:@"lat"];
            NSString *lng = [patientInfo[i] objectForKey:@"lng"];
            CLLocation *patientLocation = [self locationWithlat:lat lng:lng];
            CLLocationDistance distanceBetweenCurrentAndPatient = [mostRecentLocation distanceFromLocation:patientLocation];
            if (distanceBetweenCurrentAndPatient <= distant) {
                [positionArr addObject:[NSString stringWithFormat:@"%i",i]];
                showedPopup = NO;
            }
        }
    }
    
    if (positionArr.count > 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:SHOWED_POPUP]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SHOWED_POPUP];
        NSString *patientName;
        for (int i = 0; i < positionArr.count; i ++) {
            int position = [positionArr[i] intValue];
            patientName = [NSString stringWithFormat:@"%@ ",[patientInfo[position] objectForKey:@"name"]];
        }
        NSString *content = [NSString stringWithFormat:@"Bạn đang ở gần bệnh nhân %@",patientName];
        [Utils showAlertWithContent:content];
    }
    
    if (showedPopup) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHOWED_POPUP];
    }
  NSLog(@"Do some work");
}

- (CLLocation *)locationWithlat:(NSString *)lat lng:(NSString *)lng {
    CLLocation *deskLocation = [[CLLocation alloc]initWithLatitude:[lat floatValue] longitude:[lng floatValue]];
    return deskLocation;
}

@end
