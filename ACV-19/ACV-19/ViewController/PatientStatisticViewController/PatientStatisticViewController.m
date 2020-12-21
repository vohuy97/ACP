//
//  PatientStatíticViewController.m
//  ACV-19
//
//  Created by Võ Huy on 11/8/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "PatientStatisticViewController.h"
#import "StatisticTableTableViewCell.h"
#import "Constains.h"
#import "NavigationTop.h"
#import "DetailPatientViewController.h"
#import "APIClients.h"
#import "PatientStatisticTotalViewController.h"
#import "Utils.h"

@interface PatientStatisticViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *data;
    NSArray *dataOverView;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PatientStatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [[NSMutableArray alloc] init];
    dataOverView = [[NSArray alloc] init];
    [NavigationTop initNavigationItemsTopWithTitle:@"Patient Statistic" leftImageName:@"icons-back.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(statisViewTap)];
    [_statisticTotal addGestureRecognizer:singleFingerTap];
    _textDataEmpty.hidden = YES;
    [self getPatientStatistic];
    [self getPatientStatisticOverView];
}

- (void)viewWillAppear:(BOOL)animated {
    [NavigationTop orangeTopColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NavigationTop clearTopColor];
}

- (void)initTableView{
    float positionOfY = _columName.frame.origin.y + _columName.frame.size.height;
    float fullCell_height = SCREEN_HEIGHT - (_columName.frame.origin.y);
    
    CGRect tableFrame = CGRectMake(5, positionOfY, SCREEN_WIDTH - 10, fullCell_height);
    _tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self->_tableView];
    // hide scroll bar
    [_tableView setShowsHorizontalScrollIndicator:NO];
    [_tableView setShowsVerticalScrollIndicator:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"StatisticTableTableViewCell";
    
    StatisticTableTableViewCell *cell = (StatisticTableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatisticTableTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.cellBtn addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.cellBtn.tag = (int)indexPath.row;
    cell.stt.text = [NSString stringWithFormat:@"%li", indexPath.row + 1];
    cell.city.text = [data [indexPath.row] objectForKey:@"address"];
    cell.nhiemBenh.text = [NSString stringWithFormat:@"%@", [data [indexPath.row] objectForKey:@"socanhiem"]];
    cell.dangNhiem.text = [NSString stringWithFormat:@"%@", [data [indexPath.row] objectForKey:@"dangdieutri"]];
    cell.hoiPhuc.text = [NSString stringWithFormat:@"%@", [data [indexPath.row] objectForKey:@"khoi"]];
    cell.tuVong.text = [NSString stringWithFormat:@"%@", [data [indexPath.row] objectForKey:@"tuvong"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)navigationActionLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)statisViewTap {
    PatientStatisticTotalViewController *tap = [[PatientStatisticTotalViewController alloc]init];
    [self.navigationController pushViewController:tap animated:NO];
}

- (void)didTapButton:(UIButton *)sender {
    DetailPatientViewController *detailUpVC = [[DetailPatientViewController alloc]init];
    detailUpVC.city = [data[sender.tag] objectForKey:@"address"];
    [self.navigationController pushViewController:detailUpVC animated:NO];
}

- (void)getPatientStatistic {
    [Utils startSpinnerLoading];
    [APIClients getPatientStatistic:^(id  _Nullable responseObject) {
        _textDataEmpty.hidden = YES;
        [Utils stopSpinnerLoading];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr = responseObject;
        if (arr.count > 0 && arr) {
            for (int i = 1; i < arr.count; i ++) {
                [self->data addObject:arr[i]];
            }
        }
        
        [self initTableView];
    } failure:^(NSError * _Nullable error) {
        _textDataEmpty.hidden = NO;
        [Utils stopSpinnerLoading];
    }];
}

- (void)getPatientStatisticOverView {
    [APIClients getPatientStatisticOverView:^(id  _Nullable responseObject) {
        self->dataOverView = responseObject;
        self->_soCaNhiem.text = [NSString stringWithFormat:@"%@",[responseObject[0] objectForKey:@"So ca Nhiem"]];
        self->_dangDieuTri.text = [NSString stringWithFormat:@"%@",[responseObject[0] objectForKey:@"Dang dieu tri"]];
        self->_khoi.text = [NSString stringWithFormat:@"%@",[responseObject[0] objectForKey:@"Khoi"]];
        self->_tuVong.text = [NSString stringWithFormat:@"%@",[responseObject[0] objectForKey:@"Tu Vong"]];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
