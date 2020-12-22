//
//  Utils.h
//  MapCao
//
//  Created by VoHuy on 2020/06/02.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
+ (void)shareFacebook;
+ (void)startSpinnerLoading;
+ (void)stopSpinnerLoading;
+ (void)showAlertWithContent:(NSString *)content;
+ (void)showAlertWithContentServerError:(NSString *)content;
+ (void)pushNotificationWithID:(NSString*)identifier title:(NSString*)titleText body:(NSString *)bodyText andTimeInterval:(int)timeInterval;
@end

NS_ASSUME_NONNULL_END
