//
//  Utils.m
//  MapCao
//
//  Created by VoHuy on 2020/06/02.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "Utils.h"
#import "SpinnerView.h"

SpinnerView *spinnerLodingView;
UIView *coverView;

@implementation Utils

+ (void)startSpinnerLoading {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    coverView = [[UIView alloc] initWithFrame:window.frame];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    spinnerLodingView = [[SpinnerView alloc]initWithFrame:CGRectMake(screenWidth / 2 - 20, screenHeight / 2 - 20, 40, 40)];
    coverView = [[UIView alloc] initWithFrame:window.frame];
    coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [coverView addSubview:spinnerLodingView];
    [window addSubview: coverView];
}

+ (void)stopSpinnerLoading {
    [spinnerLodingView removeFromSuperview];
    [coverView removeFromSuperview];
}

+ (void)showAlertWithContent:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cảnh báo"
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showAlertWithContentServerError:(NSString *)content {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
