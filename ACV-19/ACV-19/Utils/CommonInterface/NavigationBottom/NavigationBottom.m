
#import "NavigationBottom.h"
#import "Constains.h"
#import "DiscoverViewController.h"

@implementation NavigationBottom

+ (id)customView {
    NavigationBottom *customView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationBottom" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([customView isKindOfClass:[NavigationBottom class]])
        return customView;
    else
        return nil;
}

+ (void)initNavigationBottom:(NavigationBottom *)navCustom
                    positonY:(float)positonY
                  actionHome:(SEL)actionHome
              actionDiscover:(SEL)actionDiscover
                actionMyCard:(SEL)actionMyCard
                        view:(UIViewController* )view {
    navCustom.layer.borderColor = [UIColor blackColor].CGColor;
    CGRect frameCustomView = navCustom.frame;
    frameCustomView.origin.y = positonY;
    frameCustomView.origin.x = 0;
    frameCustomView.size.width = SCREEN_WIDTH;
    frameCustomView.size.height = 55;
    navCustom.frame = frameCustomView;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:navCustom];
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:navCustom.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                              cornerRadii:CGSizeMake(30, 30)
                              ];
    maskPath.lineWidth = 10;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = navCustom.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    navCustom.layer.mask = maskLayer;
    
    if (!actionHome) {
        UIImage *btnImage = [UIImage imageNamed:@"home1.png"];
        [navCustom.homeBtn setImage:btnImage forState:UIControlStateNormal];
        [navCustom.homeBtn setBackgroundColor:[UIColor colorWithRed:1.00 green:0.28 blue:0.28 alpha:0.1]];
        navCustom.homeBtn.tintColor = [UIColor colorWithRed:1.00 green:0.28 blue:0.28 alpha:0.1];
    } else if (!actionDiscover) {
        [navCustom.discoverBtn setBackgroundColor:[UIColor colorWithRed:1.00 green:0.28 blue:0.28 alpha:0.1]];
        navCustom.discoverBtn.tintColor = [UIColor colorWithRed:1.00 green:0.28 blue:0.28 alpha:0.1];
    } else {
        [navCustom.myCardBtn setBackgroundColor:[UIColor colorWithRed:1.00 green:0.28 blue:0.28 alpha:0.1]];
        navCustom.myCardBtn.tintColor = [UIColor colorWithRed:1.00 green:0.28 blue:0.28 alpha:0.1];
    }

    
    UIView *backgroundBottom = [[UIView alloc]initWithFrame:CGRectMake(0, navCustom.frame.origin.y + navCustom.frame.size.height , SCREEN_WIDTH, 55)];
    [backgroundBottom setBackgroundColor:[UIColor whiteColor]];
    backgroundBottom.tag = TAG_VIEW_BACKGROUND_BOTTOM;
    [window addSubview:backgroundBottom];
    
    [navCustom.homeBtn addTarget:view
                              action:actionHome
                    forControlEvents:UIControlEventTouchUpInside];
    
    [navCustom.discoverBtn addTarget:view
                              action:actionDiscover
                    forControlEvents:UIControlEventTouchUpInside];
    
    [navCustom.myCardBtn addTarget:view
                              action:actionMyCard
                    forControlEvents:UIControlEventTouchUpInside];
}
 
@end
