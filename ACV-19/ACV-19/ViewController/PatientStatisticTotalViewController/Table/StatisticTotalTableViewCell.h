//
//  StatisticTotalTableViewCell.h
//  ACV-19
//
//  Created by Võ Huy on 11/29/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticTotalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *benhNhanLb;
@property (weak, nonatomic) IBOutlet UILabel *tuoiLb;
@property (weak, nonatomic) IBOutlet UILabel *diaDiemLb;
@property (weak, nonatomic) IBOutlet UILabel *tinhTrangLb;
@property (weak, nonatomic) IBOutlet UILabel *quocTichLb;

@end

NS_ASSUME_NONNULL_END
