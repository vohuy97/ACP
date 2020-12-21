//
//  DetailPatientTableViewCell.h
//  ACV-19
//
//  Created by Võ Huy on 11/14/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailPatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *datLb;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *nationalLb;
@property (weak, nonatomic) IBOutlet UILabel *ageLb;

@end

NS_ASSUME_NONNULL_END
