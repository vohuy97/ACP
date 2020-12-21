//
//  GovernmentDirectiveViewController.m
//  ACV-19
//
//  Created by Võ Huy on 11/17/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "GovernmentDirectiveViewController.h"
#import "Constains.h"
#import "NavigationTop.h"
#import "GovernmentTableViewCell.h"
#import "APIClients.h"
#import "Utils.h"

@interface GovernmentDirectiveViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GovernmentDirectiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NavigationTop initNavigationItemsTopWithTitle:@"Government Directive" leftImageName:@"icons-back.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat bottomPadding = 10;
    if (@available(iOS 11.0, *)) {
       UIWindow *window = UIApplication.sharedApplication.keyWindow;
       bottomPadding = window.safeAreaInsets.bottom;
    }
    
    _textDataEmpty.hidden = YES;
    [self getDirectings];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NavigationTop clearTopColor];
}

- (void)initTableView {
    float positionOfY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    float fullCell_height = SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height;
    
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
    static NSString *simpleTableIdentifier = @"GovernmentTableViewCell";
    
    GovernmentTableViewCell *cell = (GovernmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GovernmentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.dateLb.text = [data[indexPath.row] objectForKey:@"date"];
    cell.cityLb.text = [data[indexPath.row] objectForKey:@"address"];
    cell.titleLb.text = [data[indexPath.row] objectForKey:@"title"];
    cell.contentLb.text = [data[indexPath.row] objectForKey:@"content"];
    cell.effectLb.text = [data[indexPath.row] objectForKey:@"effect"];
    cell.linkLb.tag = (int)indexPath.row;
    [cell.linkLb addTarget:self
                    action:@selector(openLink:)
       forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)openLink:(UIButton *)button {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[data[(int)button.tag] objectForKey:@"link"]]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (void)navigationActionLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDirectings {
    [Utils startSpinnerLoading];
    [APIClients getDirectings:^(id  _Nullable responseObject) {
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
