//
//  DetailPatientViewController.m
//  ACV-19
//
//  Created by Võ Huy on 11/14/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "DetailPatientViewController.h"
#import "Constains.h"
#import "NavigationTop.h"
#import "DetailPatientTableViewCell.h"
#import "APIClients.h"
#import "Utils.h"

@interface DetailPatientViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation DetailPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [[NSArray alloc] init];
    [NavigationTop orangeTopColor];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _textDataEmpty.hidden = YES;
    [self getPatientDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [NavigationTop initNavigationItemsTopWithTitle:@"Detail Patient Statistic" leftImageName:@"icons-back.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NavigationTop clearTopColor];
}

- (void)initTableView{
    float positionOfY = self.navigationController.navigationBar.frame.size.height;
    float fullCell_height = SCREEN_HEIGHT;
    
    CGRect tableFrame = CGRectMake(0, positionOfY, SCREEN_WIDTH, fullCell_height);
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
    static NSString *simpleTableIdentifier = @"DetailPatientTableViewCell";
    
    DetailPatientTableViewCell *cell = (DetailPatientTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailPatientTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.NameLb.text = [data[indexPath.row] objectForKey:@"id_patient"];
    cell.ageLb.text = [NSString stringWithFormat:@"%@", [data[indexPath.row] objectForKey:@"age"]];
    cell.addressLb.text = [data[indexPath.row] objectForKey:@"address"];
    cell.nationalLb.text = [data[indexPath.row] objectForKey:@"national"];
    cell.datLb.text = [data[indexPath.row] objectForKey:@"address"];
    cell.statusLb.text = [data[indexPath.row] objectForKey:@"status"];
    cell.descriptionLb.text = [data[indexPath.row] objectForKey:@"description"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260;
}

- (void)navigationActionLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPatientDetail {
    [Utils startSpinnerLoading];
    [APIClients getPatientDetail:_city success:^(id  _Nullable responseObject) {
        self->_textDataEmpty.hidden = YES;
        [Utils stopSpinnerLoading];
        self->data = responseObject;
        [self initTableView];
    } failure:^(NSError * _Nullable error) {
        _textDataEmpty.hidden = NO;
        [Utils stopSpinnerLoading];
    }];
}


@end
