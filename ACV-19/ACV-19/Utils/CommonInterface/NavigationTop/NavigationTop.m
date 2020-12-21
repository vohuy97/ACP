//
//  NavigationTop.m
//  MapCao
//
//  Created by VoHuy on 2020/02/06.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "NavigationTop.h"
UIView *statusBarView;

@implementation NavigationTop

+ (void)initNavigationItemsTopWithTitle:(NSString *)title leftImageName:(NSString *)leftImageName leftAction:(SEL)leftAction rightImageName:(NSString *)rightImageName rightAction:(SEL)rightAction atView:(UIViewController *)view {
    view.navigationItem.title = title;
    UIImage *leftImage = [UIImage imageNamed:leftImageName];
    UIImage *rightImage = [UIImage imageNamed:rightImageName];
    float iosFirmware = 11.0;
    if([[[UIDevice currentDevice] systemVersion] floatValue] < iosFirmware ){
        //leftBar
        UIBarButtonItem *closeViewBtn=[[UIBarButtonItem alloc]initWithImage:leftImage
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:view
                                                                     action:leftAction];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        negativeSpacer.width = -15;
        
        [view.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, closeViewBtn, nil]];
        
        //rightBar
        UIBarButtonItem *filterBtn=[[UIBarButtonItem alloc]initWithImage:rightImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:view
                                                                  action:rightAction];
        
        
        [view.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, filterBtn, nil]];
    } else {
        //leftBar
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setImage:leftImage forState:UIControlStateNormal];
        [leftBtn addTarget:view action:leftAction
               forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setShowsTouchWhenHighlighted:YES];
        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
        UIBarButtonItem *leftItem =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        view.navigationItem.leftBarButtonItem = leftItem;
        
        //rightBar
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        [rightBtn addTarget:view action:rightAction
            forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setShowsTouchWhenHighlighted:YES];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -20)];
        UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        view.navigationItem.rightBarButtonItem = rightItem;
    }
    
    if ([title isEqualToString:@"CPA"]) {
        view.navigationController.navigationBar.tintColor = [UIColor clearColor];
        view.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        view.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [view.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                 forBarMetrics:UIBarMetricsDefault];
        view.navigationController.navigationBar.shadowImage = [UIImage new];
    } else {
        view.navigationController.navigationBar.tintColor = [UIColor grayColor];
        view.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        view.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
        
        UIApplication *app = [UIApplication sharedApplication];
        CGFloat statusBarHeight = app.statusBarFrame.size.height;
        statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusBarHeight, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
        statusBarView.backgroundColor = [UIColor orangeColor];
        [view.navigationController.navigationBar addSubview:statusBarView];
    }
}

+ (void)clearTopColor {
    statusBarView.backgroundColor = [UIColor clearColor];
}

+ (void)orangeTopColor {
    statusBarView.backgroundColor = [UIColor orangeColor];
}

@end
