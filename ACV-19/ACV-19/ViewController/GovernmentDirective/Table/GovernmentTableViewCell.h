//
//  GovernmentTableViewCell.h
//  ACV-19
//
//  Created by Võ Huy on 12/2/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GovernmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *effectLb;
@property (weak, nonatomic) IBOutlet UIButton *linkLb;

@end

NS_ASSUME_NONNULL_END
