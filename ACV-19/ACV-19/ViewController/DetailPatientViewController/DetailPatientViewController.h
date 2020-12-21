//
//  DetailPatientViewController.h
//  ACV-19
//
//  Created by Võ Huy on 11/14/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailPatientViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *textDataEmpty;
@property (nonatomic) NSString *city;
@end

NS_ASSUME_NONNULL_END
