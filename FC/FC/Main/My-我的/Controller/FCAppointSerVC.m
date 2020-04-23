//
//  FCAppointSerVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCAppointSerVC.h"
#import "FCAppointPayVC.h"
#import "FCBillInfoView.h"
#import <zhPopupController.h>

@interface FCAppointSerVC ()
@property (nonatomic, strong) zhPopupController *popupController;
@end

@implementation FCAppointSerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"立即预定"];
}
- (IBAction)payClicked:(UIButton *)sender {
    FCAppointPayVC *pvc = [FCAppointPayVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)billClicked:(SPButton *)sender {
    FCBillInfoView *billView = [FCBillInfoView loadXibView];
    billView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 240.f+50.f+self.HXButtomHeight);
    hx_weakify(self);
    billView.dissmissCall = ^{
        hx_strongify(weakSelf);
        [strongSelf.popupController dismissWithDuration:0.25 completion:nil];
    };
    _popupController = [[zhPopupController alloc] initWithView:billView size:billView.bounds.size];
    _popupController.layoutType = zhPopupLayoutTypeBottom;
    _popupController.dismissOnMaskTouched = YES;
    [_popupController showInView:self.view completion:nil];
}


@end
