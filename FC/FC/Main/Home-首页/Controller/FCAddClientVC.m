//
//  FCAddClientVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/21.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCAddClientVC.h"
#import "HXPlaceholderTextView.h"

@interface FCAddClientVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;
@end

@implementation FCAddClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"录入客源"];
    self.remark.placeholder = @"请输入备注内容";
}

@end
