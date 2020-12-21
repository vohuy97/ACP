//
//  NewsTableViewCell.h
//  ACV-19
//
//  Created by Võ Huy on 11/7/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *datePost;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLB;
@property (weak, nonatomic) IBOutlet UIImageView *imgNews;
@property (weak, nonatomic) IBOutlet UIView *viewTotal;

@end

NS_ASSUME_NONNULL_END
