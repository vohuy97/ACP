//
//  PatientStatisticTotalViewController.m
//  ACV-19
//
//  Created by Võ Huy on 11/29/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "PatientStatisticTotalViewController.h"
#import "StatisticTotalTableViewCell.h"
#import "Constains.h"
#import "NavigationTop.h"
#import "DetailPatientViewController.h"
#import "APIClients.h"
#import "Utils.h"

@interface PatientStatisticTotalViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
    NSArray *dataOverView;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PatientStatisticTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [[NSArray alloc] init];
    [NavigationTop orangeTopColor];
    dataOverView = [[NSArray alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getStatisticTotal];
}

- (void)viewWillAppear:(BOOL)animated {
    [NavigationTop initNavigationItemsTopWithTitle:@"Patient Statistic total" leftImageName:@"icons-back.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NavigationTop clearTopColor];
}

- (void)initTableView {
    float positionOfY = _columName.frame.origin.y + _columName.frame.size.height;
    float fullCell_height = SCREEN_HEIGHT - (_columName.frame.origin.y + _columName.frame.size.height);
    
    CGRect tableFrame = CGRectMake(5, positionOfY, SCREEN_WIDTH - 10, fullCell_height);
    _tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self->_tableView];
    // hide scroll bar
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _textDataEmpty.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"StatisticTotalTableViewCell";
    
    StatisticTotalTableViewCell *cell = (StatisticTotalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatisticTotalTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.benhNhanLb.text = [data[indexPath.row] objectForKey:@"id_patient"];
    cell.tuoiLb.text = [NSString stringWithFormat:@"%@", [data[indexPath.row] objectForKey:@"age"]];
    cell.diaDiemLb.text = [data[indexPath.row] objectForKey:@"address"];
    cell.tinhTrangLb.text = [data[indexPath.row] objectForKey:@"status"];
    if ([[data[indexPath.row] objectForKey:@"status"] isEqualToString:@"Khỏi"]) {
        cell.tinhTrangLb.textColor = [UIColor greenColor];
    } else if ([[data[indexPath.row] objectForKey:@"status"] isEqualToString:@"Đang điều trị"]) {
        cell.tinhTrangLb.textColor = [UIColor orangeColor];
    } else if ([[data[indexPath.row] objectForKey:@"status"] isEqualToString:@"Tử vong"]) {
        cell.tinhTrangLb.textColor = [UIColor redColor];
    }
    
    cell.quocTichLb.text = [data[indexPath.row] objectForKey:@"national"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)navigationActionLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getStatisticTotal {
    [Utils startSpinnerLoading];
    [APIClients getPatientStatisticTotal:^(id  _Nullable responseObject) {
        _textDataEmpty.hidden = YES;
        [Utils stopSpinnerLoading];
        self->data = responseObject;
        [self initTableView];
    } failure:^(NSError * _Nullable error) {
        _textDataEmpty.hidden = NO;
        [Utils stopSpinnerLoading];
    }];
}

@end
