//
//  GovernmentDirectiveViewController.h
//  ACV-19
//
//  Created by Võ Huy on 11/17/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GovernmentDirectiveViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContent;
@property (weak, nonatomic) IBOutlet UILabel *textDataEmpty;

@end

NS_ASSUME_NONNULL_END
