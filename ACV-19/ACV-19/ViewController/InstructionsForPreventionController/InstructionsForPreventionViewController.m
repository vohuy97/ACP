//
//  InstructionsForPreventionViewController.m
//  ACV-19
//
//  Created by Võ Huy on 10/22/20.
//  Copyright © 2020 VoHuy. All rights reserved.
//

#import "InstructionsForPreventionViewController.h"
#import "NavigationTop.h"

@interface InstructionsForPreventionViewController ()

@end

@implementation InstructionsForPreventionViewController

- (void)viewDidLoad {
    NSString *videoURL = @"https://www.youtube.com/embed/W8gL1JXATIc";
    NSString *videoEmbedcode = [NSString stringWithFormat:@"\
                                <html>\
                                <head>\
                                <style type=\"text/css\">\
                                iframe {position:absolute; top:50%%; margin-top:-130px;}\
                                body {background-color:#000; margin:0;}\
                                </style>\
                                </head>\
                                <body>\
                                <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                                </body>\
                                </html>", videoURL];
    [[self webView] loadHTMLString:videoEmbedcode baseURL:nil];
    [super viewDidLoad];
    [NavigationTop initNavigationItemsTopWithTitle:@"Instructions For Prevention" leftImageName:@"icons-back.png" leftAction:@selector(navigationActionLeft) rightImageName:@"" rightAction:nil atView:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NavigationTop clearTopColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationActionLeft {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
