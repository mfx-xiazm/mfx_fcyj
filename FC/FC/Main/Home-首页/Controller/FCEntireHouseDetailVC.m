//
//  FCEntireHouseDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/22.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCEntireHouseDetailVC.h"
#import "FCHouseMoreView.h"
#import "FCHouseMoreObject.h"
#import <zhPopupController.h>
#import "FCEcontractVC.h"
#import "FCHouseRentVC.h"
#import "FCFinanceNoteVC.h"
#import "FCOutRentNoteVC.h"
#import "FCSubletRentNoteVC.h"
#import "FCCashCouponVC.h"
#import "FCFollowNoteVC.h"
#import "FCFitNoteVC.h"
#import "FCVisitNoteVC.h"
#import "FCGoodsNoteVC.h"
#import "FCMemoNoteVC.h"

@interface FCEntireHouseDetailVC ()<FCHouseMoreViewDelegate,FCHouseMoreViewDataSource>
@property (nonatomic, strong) FCHouseMoreView *moreView;
@property (nonatomic, strong) NSMutableArray *moreObjects;
@property (nonatomic, strong) zhPopupController *popupController;

@end

@implementation FCEntireHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
}
#pragma mark -- 懒加载
-(FCHouseMoreView *)moreView
{
    if (_moreView == nil) {
        _moreView = [FCHouseMoreView loadXibView];
        _moreView.frame = CGRectMake(0,0,HX_SCREEN_WIDTH, 40.f*2 + 90.f*3 + self.HXButtomHeight);
        _moreView.dataSource = self;
        _moreView.delegate = self;
    }
    return _moreView;;
}
-(NSMutableArray *)moreObjects
{
    if (_moreObjects == nil) {
        _moreObjects = [NSMutableArray array];
        NSArray *names = @[@"电子合同",@"应收房租",@"应支房租",@"财务记录",@"退房记录",@"转租记录",@"代金券",@"跟进记录",@"装修管理",@"带看记录",@"物品增减",@"备忘录"];
        NSArray *images = @[@"房源电子合同",@"房源应收房租",@"房源应支房租",@"房源财务记录",@"房源退房记录",@"房源转租记录",@"房源代金券",@"房源跟进记录",@"房源装修管理",@"房源带看记录",@"房源物品增减",@"房源备忘录"];
        for (int i=0;i<12;i++) {
            FCHouseMoreObject *object1 = [[FCHouseMoreObject alloc] init];
            object1.cateName = names[i];
            object1.imageName = images[i];
            [_moreObjects addObject:object1];
        }
    }
    return _moreObjects;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"房源详情"];

    UIBarButtonItem *moreItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreClicked) nomalImage:HXGetImage(@"客源更多") higeLightedImage:HXGetImage(@"客源更多") imageEdgeInsets:UIEdgeInsetsZero];
    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) nomalImage:HXGetImage(@"分享") higeLightedImage:HXGetImage(@"分享") imageEdgeInsets:UIEdgeInsetsZero];

    self.navigationItem.rightBarButtonItems = @[moreItem,shareItem];
}
#pragma mark -- 点击事件
-(void)moreClicked
{
    _popupController = [[zhPopupController alloc] initWithView:self.moreView size:self.moreView.bounds.size];
    _popupController.layoutType = zhPopupLayoutTypeBottom;
    _popupController.dismissOnMaskTouched = YES;
    [_popupController show];
}
-(void)shareClicked
{
    
}
#pragma mark -- FCHouseMoreViewDelegate
// 返回元素个数
- (NSInteger)houseMoreView:(FCHouseMoreView *)houseMoreView numberOfItemsInSection:(NSInteger)section
{
    return self.moreObjects.count;
}
// 返回每行排列几个元素
- (NSInteger)houseMoreView:(FCHouseMoreView *)houseMoreView columnCountOfSection:(NSInteger)section
{
   return 4;
}
// 返回数据实例
- (FCHouseMoreObject *)houseMoreView:(FCHouseMoreView *)houseMoreView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FCHouseMoreObject *object = self.moreObjects[indexPath.row];
    return object;
}
- (void)houseMoreView:(FCHouseMoreView *)houseMoreView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_popupController dismiss];
    if (indexPath.row == 0) {
        FCEcontractVC *evc = [FCEcontractVC new];
        [self.navigationController pushViewController:evc animated:YES];
    }else if (indexPath.row == 1) {
        FCHouseRentVC *rvc = [FCHouseRentVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (indexPath.row == 2){
        FCHouseRentVC *rvc = [FCHouseRentVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (indexPath.row == 3){
        FCFinanceNoteVC *nvc = [FCFinanceNoteVC new];
        [self.navigationController pushViewController:nvc animated:YES];
    }else if (indexPath.row == 4){
        FCOutRentNoteVC *rvc = [FCOutRentNoteVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }else if (indexPath.row == 5){
        FCSubletRentNoteVC *nvc = [FCSubletRentNoteVC new];
        [self.navigationController pushViewController:nvc animated:YES];
    }else if (indexPath.row == 6){
        FCCashCouponVC *cvc = [FCCashCouponVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (indexPath.row == 7){
        FCFollowNoteVC *fvc = [FCFollowNoteVC new];
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (indexPath.row == 8){
        FCFitNoteVC *fvc = [FCFitNoteVC new];
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (indexPath.row == 9){
        FCVisitNoteVC *vvc = [FCVisitNoteVC new];
        [self.navigationController pushViewController:vvc animated:YES];
    }else if (indexPath.row == 10){
        FCGoodsNoteVC *gvc = [FCGoodsNoteVC new];
        [self.navigationController pushViewController:gvc animated:YES];
    }else{
        FCMemoNoteVC *nvc = [FCMemoNoteVC new];
        [self.navigationController pushViewController:nvc animated:YES];
    }
}
@end
