//
//  NavigationTop.h
//  MapCao
//
//  Created by VoHuy on 2020/02/06.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationTop : UIView
+ (void)initNavigationItemsTopWithTitle:(NSString *)title leftImageName:(NSString *)leftImageName leftAction:(SEL)leftAction rightImageName:(NSString *)rightImageName rightAction:(SEL)rightAction atView:(UIViewController *)view;
+ (void)clearTopColor;
+ (void)orangeTopColor;
@end

NS_ASSUME_NONNULL_END
