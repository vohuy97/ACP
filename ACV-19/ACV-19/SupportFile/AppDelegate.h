//
//  AppDelegate.h
//  MapCao
//
//  Created by VoHuy on 2020/01/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapTotalViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DiscoverViewController.h"
#import "MyCardViewController.h"
@import UserNotifications;
@import GoogleMaps;

@interface AppDelegate : UIResponder  <UIApplicationDelegate, CLLocationManagerDelegate ,UNUserNotificationCenterDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MapTotalViewController *MapTotalVC;
@property (strong, nonatomic) DiscoverViewController *discoverVC;
@property (strong, nonatomic) MyCardViewController *myCardVC;

+ (instancetype)sharedInstance;
- (void)startUpdatingLocation;
- (float)getLatitude;
- (float)getLongitude;
- (CLLocation *)getLocation;

@end

