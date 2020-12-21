//
//  PatientStatíticViewController.h
//  ACV-19
//
//  Created by Võ Huy on 11/8/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientStatisticViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *textDataEmpty;
@property (weak, nonatomic) IBOutlet UIView *columName;
@property (weak, nonatomic) IBOutlet UILabel *soCaNhiem;
@property (weak, nonatomic) IBOutlet UILabel *dangDieuTri;
@property (weak, nonatomic) IBOutlet UILabel *khoi;
@property (weak, nonatomic) IBOutlet UILabel *tuVong;
@property (weak, nonatomic) IBOutlet UIView *statisticTotal;

@end

NS_ASSUME_NONNULL_END
