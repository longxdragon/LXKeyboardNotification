//
//  LXTableViewController.m
//  LXKeyboardNotification
//
//  Created by gkoudai_xl on 15/10/6.
//  Copyright © 2015年 longxdragon. All rights reserved.
//

#import "LXTableViewController.h"
#import "LXKeyboardNotification.h"

@interface LXTableViewController ()

@end

@implementation LXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[LXKeyboardNotification defaultNotification] addKeyboardNotificationForSuperView:self.view
                                                                   superViewTopMargin:0];
    
    // Tap cancel edit
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%.2f", scrollView.contentOffset.y);
}

@end
