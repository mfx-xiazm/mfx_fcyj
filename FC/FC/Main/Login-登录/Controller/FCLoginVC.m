//
//  FCLoginVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCLoginVC.h"
#import "HXTabBarController.h"

@interface FCLoginVC ()

@end

@implementation FCLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hbd_barHidden = YES;
}

- (IBAction)loginClicked:(UIButton *)sender {
    HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    
    //推出主界面出来
    CATransition *ca = [CATransition animation];
    ca.type = @"movein";
    ca.duration = 0.25;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:ca forKey:nil];
}


@end
