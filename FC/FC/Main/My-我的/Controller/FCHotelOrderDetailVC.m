//
//  FCHotelOrderDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHotelOrderDetailVC.h"
#import "FCHotelOrderEvaVC.h"

@interface FCHotelOrderDetailVC ()

@end

@implementation FCHotelOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"民宿订单详情"];
}
- (IBAction)orderHandleClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        FCHotelOrderEvaVC *evc = [FCHotelOrderEvaVC new];
        [self.navigationController pushViewController:evc animated:YES];
    }else{
        
    }
}

@end
