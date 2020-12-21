//
//  DrawerMenu.m
//  MapCao
//
//  Created by VoHuy on 2020/05/05.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "DrawerMenu.h"
#import "Constains.h"
#import "InstructionsForPreventionViewController.h"
#import "NewsViewController.h"
#import "PatientStatisticViewController.h"
#import "GovernmentDirectiveViewController.h"
#import "NewsOfGovernmentViewController.h"

@implementation DrawerMenu
UIView *drawerView;
UIView *infoView;
UIView *viewHide;
UISwipeGestureRecognizer *left;

+ (void)showDrawerMenu {
    [UIView animateWithDuration:0.4f
                     animations:^ {
                         [self setShowView];
                     }
                     completion:^(BOOL finished) {
                     }];
}

+ (void)setShowView {
    viewHide.hidden = NO;
    CGRect frame = drawerView.frame;
    frame.origin.x = 0;
    drawerView.frame = frame;
    drawerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
}

+ (void)animationHideDrawerMenu {
    [UIView animateWithDuration:0.4f
                     animations:^ {
                         CGRect frame = drawerView.frame;
                         frame.origin.x = -SCREEN_WIDTH * 4 / 5;
                         drawerView.frame = frame;
                         drawerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         viewHide.hidden = YES;
                     }];
}

+ (void)hideViewSetting {
    [self animationHideDrawerMenu];
}

+ (void)touchNav:(UISwipeGestureRecognizer *)sender {
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft){
        [self animationHideDrawerMenu];
    }
}

+ (void)initDrawerMenu {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    drawerView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH*4/5, 0 , SCREEN_WIDTH * 4 / 5, window.frame.size.height)];
    [drawerView setBackgroundColor:[UIColor whiteColor]];
    
    // view background
    window = [[UIApplication sharedApplication] keyWindow];
    viewHide = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, window.frame.size.height)];
    [viewHide setBackgroundColor:[UIColor blackColor]];
    viewHide.alpha = 0.2;
    [window addSubview:viewHide];
    viewHide.hidden = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideViewSetting)];
    [viewHide addGestureRecognizer:singleFingerTap];
    
    drawerView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH*4/5,0, SCREEN_WIDTH*4/5, window.frame.size.height)];
    [window bringSubviewToFront:drawerView];
    [drawerView setBackgroundColor:[UIColor whiteColor]];
    [window addSubview:drawerView];
    left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(touchNav:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [drawerView addGestureRecognizer:left];
    
//    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , drawerView.frame.size.width , SCREEN_HEIGHT / 3.5)];
//    [infoView setBackgroundColor:[UIColor blueColor]];
//    UIImage *image = [UIImage imageNamed:@"top.png"];
//    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, infoView.frame.size.height)];
//    background.image = [self imageWithImage:image scaledToSize:CGSizeMake(drawerView.frame.size.width, infoView.frame.size.height)];
//    [infoView addSubview:background];
    
//    image = [UIImage imageNamed:@"Group 860.png"];
//    float positionY = infoView.frame.size.height / 2 - infoView.frame.size.width / 10;
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, positionY - 10, infoView.frame.size.width / 5, infoView.frame.size.width / 5)];
//    imageView.image = image;
//    [infoView addSubview:imageView];
//
//    // init label
//    positionY = imageView.frame.origin.y + imageView.frame.size.height;
//    [self initUILabelWithName:@"Mr CC" positionY:positionY font:[UIFont boldSystemFontOfSize:17]];
//
//    positionY = positionY + 25;
//    [self initUILabelWithName:@"Mr CC" positionY:positionY font:[UIFont systemFontOfSize:15]];
    
    // init button
    float positionY = [[UIApplication sharedApplication] statusBarFrame].size.height * 2;
    [self initButtonWithName:@"News" nameIcon:@"newspaper.png" tag:1 positionY:positionY];
    
    positionY = positionY + 50;
    [self initButtonWithName:@"News Of Government" nameIcon:@"news.png" tag:5 positionY:positionY];
    
    positionY = positionY + 50;
    [self initButtonWithName:@"Patient statistics" nameIcon:@"bar-chart.png" tag:2 positionY:positionY];
    
    positionY = positionY + 50;
    [self initButtonWithName:@"Instructions for prevention" nameIcon:@"instruction.png" tag:3 positionY:positionY];
    
    positionY = positionY + 50;
    [self initButtonWithName:@"Government directive" nameIcon:@"government.png" tag:4 positionY:positionY];
    
    positionY = SCREEN_HEIGHT - 45;
    [self initButtonWithName:@"Hotline 19009095" nameIcon:@"phone-contact.png" tag:6 positionY:positionY];
    
    [drawerView addSubview:infoView];
    [window addSubview:drawerView];
    [drawerView bringSubviewToFront:window];
}

+ (void)initUILabelWithName:(NSString *)nameLb positionY:(float)positionY font:(UIFont *)font {
    UILabel *initLb = [[UILabel alloc]initWithFrame:CGRectMake(30, positionY, drawerView.frame.size.width - 25, 15)];
    initLb.text = nameLb;
    initLb.textAlignment = NSTextAlignmentLeft;
    initLb.font = font;
    [initLb setTextColor:[UIColor whiteColor]];
    [infoView addSubview:initLb];
}

+ (void)initButtonWithName:(NSString *)nameBtn nameIcon:(NSString *)nameIcon tag:(int)tag positionY:(float)positionY {
    float positionX = 25;
    UIImageView *imageViewHome = [[UIImageView alloc]initWithFrame:CGRectMake(positionX , positionY, 15, 15)];
    imageViewHome.image = [UIImage imageNamed:nameIcon];
    [drawerView addSubview:imageViewHome];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    switch (tag) {
        case 1:
            [button addTarget:self action:@selector(newsAc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            [button addTarget:self action:@selector(patientStatisticAc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 3:
            [button addTarget:self action:@selector(instructionsForPreventionAc) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 4:
            [button addTarget:self action:@selector(governmentDirective) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 5:
            [button addTarget:self action:@selector(newsOfGoverment) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 6:
            [button addTarget:self action:@selector(hotlineAc) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    [button setTitle:nameBtn forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.frame = CGRectMake(positionX + 30, positionY, drawerView.frame.size.width - (positionX + 30), 15);
    [drawerView addSubview:button];
}

+ (void)newsAc {
    [self hideViewSetting];
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [navController pushViewController:newsVC animated:YES];
}

+ (void)patientStatisticAc {
    [self hideViewSetting];
    PatientStatisticViewController *PSVC = [[PatientStatisticViewController alloc]init];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [navController pushViewController:PSVC animated:YES];
}

+ (void)instructionsForPreventionAc {
    [self hideViewSetting];
    InstructionsForPreventionViewController *instructionsForPreventionVC = [[InstructionsForPreventionViewController alloc]init];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [navController pushViewController:instructionsForPreventionVC animated:YES];
}

+ (void)governmentDirective {
    [self hideViewSetting];
    GovernmentDirectiveViewController *vc = [[GovernmentDirectiveViewController alloc]init];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [navController pushViewController:vc animated:YES];
}

+ (void)newsOfGoverment {
    [self hideViewSetting];
    NewsOfGovernmentViewController *vc = [[NewsOfGovernmentViewController alloc]init];
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [navController pushViewController:vc animated:YES];
}

+ (void)hotlineAc {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:19009095"]];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
