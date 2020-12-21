//
//  NewsOfGovernmentViewController.m
//  ACV-19
//
//  Created by Võ Huy on 11/28/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "NewsOfGovernmentViewController.h"
#import "NewsTableViewCell.h"
#import "Constains.h"
#import "NavigationTop.h"
#import "APIClients.h"
#import "Utils.h"

@interface NewsOfGovernmentViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation NewsOfGovernmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [[NSArray alloc] init];
    [NavigationTop initNavigationItemsTopWithTitle:@"News Of Government" leftImageName:@"icons-back.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _textDataEmpty.hidden = YES;
    [self getNews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NavigationTop clearTopColor];
}

- (void)initTableView {
    float positionOfY = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    float fullCell_height = SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y;
    if (@available(iOS 11.0, *)) {
        fullCell_height = SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height;
    }
    
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
    static NSString *simpleTableIdentifier = @"NewsTableViewCell";
    
    NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.datePost.text = [data[indexPath.row] objectForKey:@"date"];
    cell.title.text = [data[indexPath.row] objectForKey:@"title"];
    cell.descriptionLB.text = [data[indexPath.row] objectForKey:@"content"];
    cell.imgNews.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[data[indexPath.row] objectForKey:@"image"]]]];
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSingleTap:)];
    cell.viewTotal.tag = indexPath.row;
    [cell.viewTotal addGestureRecognizer:singleFingerTap];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)navigationActionLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[data[(int)recognizer.view.tag] objectForKey:@"link"]]];
}

- (void)getNews {
    [Utils startSpinnerLoading];
    [APIClients getNewsGovernment:^(id  _Nullable responseObject) {
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
