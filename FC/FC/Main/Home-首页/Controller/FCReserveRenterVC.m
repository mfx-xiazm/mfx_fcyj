//
//  FCReserveRenterVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCReserveRenterVC.h"
#import "HXPlaceholderTextView.h"

@interface FCReserveRenterVC ()
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

@end

@implementation FCReserveRenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"租客签订"];
    self.remark.placeholder = @"请输入备注";
}

@end
