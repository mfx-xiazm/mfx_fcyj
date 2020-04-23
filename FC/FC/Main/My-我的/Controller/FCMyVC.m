//
//  FCMyVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMyVC.h"
#import "FCSignCodeVC.h"
#import "FCMyMsgVC.h"
#import "FCMyRecommendVC.h"
#import "FCMyChannelVC.h"
#import "zhAlertView.h"
#import <zhPopupController.h>
#import "FCChangePwdVC.h"
#import "FCChangePhoneVC.h"
#import "HXMallTabBarController.h"

@interface FCMyVC ()
@property (nonatomic, strong) zhPopupController *popupController;
@end

@implementation FCMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark -- 点击事件
- (IBAction)myCodeClicked:(UIButton *)sender {
    FCSignCodeVC *cdv = [FCSignCodeVC new];
    [self.navigationController pushViewController:cdv animated:YES];
}
- (IBAction)mallClicked:(UIButton *)sender {
    HXMallTabBarController *mallTabBarController = [[HXMallTabBarController alloc] init];
    mallTabBarController.backSelectedIndex = 3;
    [UIApplication sharedApplication].keyWindow.rootViewController = mallTabBarController;
}
- (IBAction)myMsgClicked:(SPButton *)sender {
    FCMyMsgVC *mvc = [FCMyMsgVC new];
    [self.navigationController pushViewController:mvc animated:YES];
}
- (IBAction)myChannelClicked:(SPButton *)sender {
    FCMyChannelVC *cvc = [FCMyChannelVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (IBAction)myRecommendClicked:(SPButton *)sender {
    FCMyRecommendVC *rvc = [FCMyRecommendVC new];
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)changePhoneClicked:(SPButton *)sender {
    FCChangePhoneVC *pvc = [FCChangePhoneVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)changePwdClicked:(SPButton *)sender {
    FCChangePwdVC *pvc = [FCChangePwdVC new];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)signOutClicked:(SPButton *)sender {
    hx_weakify(self);
    zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
    zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
        [weakSelf.popupController dismiss];
    }];
    cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"退出" handler:^(zhAlertButton * _Nonnull button) {
        [weakSelf.popupController dismiss];
    }];
    okButton.lineColor = UIColorFromRGB(0xDDDDDD);
    [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
    [alert adjoinWithLeftAction:cancelButton rightAction:okButton];

    _popupController = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
    _popupController.layoutType = zhPopupLayoutTypeCenter;
    _popupController.dismissOnMaskTouched = NO;
    [_popupController show];
}

@end
