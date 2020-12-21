//
//  MapTotalViewController.h
//  MapCao
//
//  Created by VoHuy on 2020/01/13.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@import UserNotifications;

NS_ASSUME_NONNULL_BEGIN

@interface MapTotalViewController : UIViewController <UIApplicationDelegate, CLLocationManagerDelegate ,UNUserNotificationCenterDelegate>
- (void)logoutBtn;
- (void)hideBottom;
- (IBAction)getCurrentLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTotal;
- (IBAction)zoomOut:(id)sender;
- (IBAction)zoomIn:(id)sender;

@end

NS_ASSUME_NONNULL_END
