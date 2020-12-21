//
//  StatisticTableTableViewCell.h
//  ACV-19
//
//  Created by Võ Huy on 11/8/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticTableTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cellBtn;
@property (weak, nonatomic) IBOutlet UILabel *stt;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *nhiemBenh;
@property (weak, nonatomic) IBOutlet UILabel *dangNhiem;
@property (weak, nonatomic) IBOutlet UILabel *hoiPhuc;
@property (weak, nonatomic) IBOutlet UILabel *tuVong;

@end

NS_ASSUME_NONNULL_END
