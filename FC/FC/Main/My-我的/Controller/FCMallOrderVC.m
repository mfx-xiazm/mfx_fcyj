//
//  FCMallOrderVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/22.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMallOrderVC.h"
#import "HXTabBarController.h"

@interface FCMallOrderVC ()

@end

@implementation FCMallOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    button.hxn_size = CGSizeMake(30, 44);
    // 让按钮内部的所有内容左对齐
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
#pragma mark -- 点击事件
-(void)back
{
    HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
    tabBarController.selectedIndex = 3;
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}

@end
