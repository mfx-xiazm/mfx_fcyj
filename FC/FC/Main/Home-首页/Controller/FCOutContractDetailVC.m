//
//  FCOutContractDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/17.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCOutContractDetailVC.h"
#import "FCSignCodeVC.h"

@interface FCOutContractDetailVC ()

@end

@implementation FCOutContractDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"合同详情"];
}
- (IBAction)signCodeClicked:(UIButton *)sender {
    FCSignCodeVC *cvc = [FCSignCodeVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
