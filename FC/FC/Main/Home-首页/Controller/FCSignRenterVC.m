//
//  FCSignRenterVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCSignRenterVC.h"
#import "HXPlaceholderTextView.h"

@interface FCSignRenterVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end

@implementation FCSignRenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"租客签约"];
    self.remark.placeholder = @"请输入电子合同补充字段";
}

@end
