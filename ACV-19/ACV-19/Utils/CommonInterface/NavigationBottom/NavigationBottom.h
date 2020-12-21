//
//  NavigationBottom.h
//  MapCao
//
//  Created by VoHuy on 2020/01/31.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationBottom : UIView
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *discoverBtn;
@property (weak, nonatomic) IBOutlet UIButton *myCardBtn;
+ (id)customView;
+ (void)initNavigationBottom:(NavigationBottom *)navCustom
                    positonY:(float)positonY
                  actionHome:(SEL)actionHome
              actionDiscover:(SEL)actionDiscover
                actionMyCard:(SEL)actionMyCard
                        view:(UIViewController* )view;
@end

NS_ASSUME_NONNULL_END
