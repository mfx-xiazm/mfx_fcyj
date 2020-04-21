//
//  FCReserveClientVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/21.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCReserveClientVC.h"
#import "FCHouseMoreView.h"
#import "FCHouseMoreObject.h"
#import <zhPopupController.h>
#import "zhAlertView.h"
#import "FCHouseFollowCell.h"
#import "FCHouseFollow.h"
#import "FCHouseFollowLayout.h"
#import "FCClientFollowVC.h"
#import "FCAddFollowVC.h"
#import "FCAddVisitVC.h"
#import "FCPerfectClientVC.h"
#import "YBPopupMenu.h"
#import "FCReserveRefundVC.h"
#import "FCReserveBreakVC.h"
#import "FCReserveRefundDetailVC.h"
#import "FCReserveBreakDetailVC.h"

@interface FCReserveClientVC ()<UITableViewDelegate,UITableViewDataSource,FCHouseMoreViewDelegate,FCHouseMoreViewDataSource,FCHouseFollowCellDelegate,YBPopupMenuDelegate>
@property (nonatomic, strong) FCHouseMoreView *moreView;
@property (nonatomic, strong) NSMutableArray *moreObjects;
@property (nonatomic, strong) FCHouseMoreView *addFollowView;
@property (nonatomic, strong) NSMutableArray *followObjects;
@property (nonatomic, strong) zhPopupController *popupController;
@property (nonatomic, strong) zhPopupController *popupController1;
@property (nonatomic, strong) zhPopupController *popupController2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;

@end

@implementation FCReserveClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
#pragma mark -- 懒加载
-(FCHouseMoreView *)moreView
{
    if (_moreView == nil) {
        _moreView = [FCHouseMoreView loadXibView];
        _moreView.frame = CGRectMake(0,0,HX_SCREEN_WIDTH, 40.f*2 + 90.f + self.HXButtomHeight);
        _moreView.dataSource = self;
        _moreView.delegate = self;
    }
    return _moreView;;
}
-(FCHouseMoreView *)addFollowView
{
    if (_addFollowView == nil) {
        _addFollowView = [FCHouseMoreView loadXibView];
        _addFollowView.frame = CGRectMake(0,0,HX_SCREEN_WIDTH, 40.f*2 + 90.f + self.HXButtomHeight);
        _addFollowView.dataSource = self;
        _addFollowView.delegate = self;
    }
    return _addFollowView;
}
-(NSMutableArray *)moreObjects
{
    if (_moreObjects == nil) {
        _moreObjects = [NSMutableArray array];
        FCHouseMoreObject *object1 = [[FCHouseMoreObject alloc] init];
        object1.cateName = @"修改客源";
        object1.imageName = @"修改客源";
        [_moreObjects addObject:object1];
        
        FCHouseMoreObject *object2 = [[FCHouseMoreObject alloc] init];
        object2.cateName = @"完善客源";
        object2.imageName = @"完善客源";
        [_moreObjects addObject:object2];
        
        FCHouseMoreObject *object3 = [[FCHouseMoreObject alloc] init];
        object3.cateName = @"删除客源";
        object3.imageName = @"删除客源";
        [_moreObjects addObject:object3];
    }
    return _moreObjects;
}
-(NSMutableArray *)followObjects
{
    if (_followObjects == nil) {
        _followObjects = [NSMutableArray array];
        FCHouseMoreObject *object1 = [[FCHouseMoreObject alloc] init];
        object1.cateName = @"普通跟进";
        object1.imageName = @"普通跟进";
        [_followObjects addObject:object1];
        
        FCHouseMoreObject *object2 = [[FCHouseMoreObject alloc] init];
        object2.cateName = @"带看记录";
        object2.imageName = @"带看记录";
        [_followObjects addObject:object2];
    }
    return _followObjects;
}
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment2" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            FCHouseFollow *model = [FCHouseFollow yy_modelWithDictionary:dict];
            FCHouseFollowLayout *layout = [[FCHouseFollowLayout alloc] initWithModel:model];
            [_layoutsArr addObject:layout];
        }
    }
    return _layoutsArr;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"客源详情"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreClicked) nomalImage:HXGetImage(@"客源更多") higeLightedImage:HXGetImage(@"客源更多") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = HXGlobalBg;
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.tableViewHeight.constant = strongSelf.tableView.contentSize.height;
    });
}
#pragma mark -- 点击事件
-(void)moreClicked
{
    _popupController = [[zhPopupController alloc] initWithView:self.moreView size:self.moreView.bounds.size];
    _popupController.layoutType = zhPopupLayoutTypeBottom;
    _popupController.dismissOnMaskTouched = YES;
    [_popupController show];
}
- (IBAction)lookAllRecordClicked:(SPButton *)sender {
    FCClientFollowVC *fvc = [FCClientFollowVC new];
    [self.navigationController pushViewController:fvc animated:YES];
}
- (IBAction)addFollowClicked:(SPButton *)sender {
    _popupController2 = [[zhPopupController alloc] initWithView:self.addFollowView size:self.addFollowView.bounds.size];
    _popupController2.layoutType = zhPopupLayoutTypeBottom;
    _popupController2.dismissOnMaskTouched = YES;
    [_popupController2 show];
}
- (IBAction)breakContractClicked:(SPButton *)sender {
    [YBPopupMenu showRelyOnView:sender titles:@[@"定金退订",@"定金违约"] icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = self;
        popupMenu.showMaskView = NO;
        popupMenu.fontSize = 13;
        popupMenu.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    }];
}
#pragma mark -- YBPopupMenuDelegate
/** 点击事件回调 */
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        if (arc4random_uniform(2)%2) {
            FCReserveRefundDetailVC *dvc = [FCReserveRefundDetailVC new];
            [self.navigationController pushViewController:dvc animated:YES];
        }else{
            FCReserveRefundVC *rvc = [FCReserveRefundVC new];
            [self.navigationController pushViewController:rvc animated:YES];
        }
    }else{
        if (arc4random_uniform(2)%2) {
            FCReserveBreakDetailVC *dvc = [FCReserveBreakDetailVC new];
            [self.navigationController pushViewController:dvc animated:YES];
        }else{
            FCReserveBreakVC *bvc = [FCReserveBreakVC new];
            [self.navigationController pushViewController:bvc animated:YES];
        }      
    }
}
#pragma mark -- FCHouseMoreViewDelegate
// 返回元素个数
- (NSInteger)houseMoreView:(FCHouseMoreView *)houseMoreView numberOfItemsInSection:(NSInteger)section
{
    if (houseMoreView == self.moreView) {
        return self.moreObjects.count;
    }else{
        return self.followObjects.count;
    }
}
// 返回每行排列几个元素
- (NSInteger)houseMoreView:(FCHouseMoreView *)houseMoreView columnCountOfSection:(NSInteger)section
{
    if (houseMoreView == self.moreView) {
        return 3;
    }else{
        return 2;
    }
}
// 返回数据实例
- (FCHouseMoreObject *)houseMoreView:(FCHouseMoreView *)houseMoreView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (houseMoreView == self.moreView) {
        FCHouseMoreObject *object = self.moreObjects[indexPath.row];
        return object;
    }else{
        FCHouseMoreObject *object = self.followObjects[indexPath.row];
        return object;
    }
}
- (void)houseMoreView:(FCHouseMoreView *)houseMoreView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (houseMoreView == self.moreView) {
        [_popupController dismiss];
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            FCPerfectClientVC *pvc = [FCPerfectClientVC new];
            [self.navigationController pushViewController:pvc animated:YES];
        }else {
            hx_weakify(self);
            zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除客源吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
            zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
                [weakSelf.popupController1 dismiss];
            }];
            cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [cancelButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"删除" handler:^(zhAlertButton * _Nonnull button) {
                [weakSelf.popupController1 dismiss];
            }];
            okButton.lineColor = UIColorFromRGB(0xDDDDDD);
            [okButton setTitleColor:HXControlBg forState:UIControlStateNormal];
            [alert adjoinWithLeftAction:cancelButton rightAction:okButton];

            _popupController1 = [[zhPopupController alloc] initWithView:alert size:alert.bounds.size];
            _popupController1.layoutType = zhPopupLayoutTypeCenter;
            _popupController1.dismissOnMaskTouched = NO;
            [_popupController1 show];
        }
    }else{
        [_popupController2 dismiss];
        if (indexPath.row == 0) {
            FCAddFollowVC *avc = [FCAddFollowVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }else {
            FCAddVisitVC *avc = [FCAddVisitVC new];
            [self.navigationController pushViewController:avc animated:YES];
        }
    }
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCHouseFollowLayout *layout = self.layoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCHouseFollowCell * cell = [FCHouseFollowCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FCHouseFollowLayout *layout = self.layoutsArr[indexPath.row];
    cell.followLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark --  FCHouseFollowCell代理
-(void)didClickExpandInCell:(FCHouseFollowCell *)Cell
{
    FCHouseFollowLayout *layout = Cell.followLayout;
    layout.follow.isOpening = !layout.follow.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.tableViewHeight.constant = strongSelf.tableView.contentSize.height;
    });
}
@end
