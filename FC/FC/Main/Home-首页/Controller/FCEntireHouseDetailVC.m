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
#import "FCPageMainTableView.h"
#import <JXCategoryView.h>
#import <JXCategoryIndicatorLineView.h>
#import "FCHouseLandlordDetailVC.h"
#import "FCHouseRenterDetailVC.h"
#import "FCEntireHouseDetailHeader.h"
#import "FCGoodsJointVC.h"
#import "FCReserveRenterVC.h"
#import "FCSignRenterVC.h"
#import "zhAlertView.h"
#import "FCGoodsJointShowVC.h"

@interface FCEntireHouseDetailVC ()<FCHouseMoreViewDelegate,FCHouseMoreViewDataSource,UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet FCPageMainTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *landlordToolView;
@property (weak, nonatomic) IBOutlet UIView *renterToolView;

@property (nonatomic, strong) FCHouseMoreView *moreView;
@property (nonatomic, strong) NSMutableArray *moreObjects;
@property (nonatomic, strong) zhPopupController *popupController;
@property (nonatomic, strong) zhPopupController *popupController1;
/* 头视图 */
@property(nonatomic,strong) FCEntireHouseDetailHeader *header;
/** 子控制器承载scr */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/** 是否可以滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
/** 切换控制器 */
@property (strong, nonatomic) JXCategoryTitleView *categoryView;
@end

@implementation FCEntireHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    self.isCanScroll = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainTableScroll:) name:@"MainTableScroll" object:nil];
    [self setUpMainTable];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, -(HX_SCREEN_WIDTH*280.f/375.f), HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*280.f/375.f);
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
-(FCEntireHouseDetailHeader *)header
{
    if (_header == nil) {
        _header = [FCEntireHouseDetailHeader loadXibView];
        _header.backgroundColor = [UIColor whiteColor];
        _header.frame = CGRectMake(0, -(HX_SCREEN_WIDTH*280.f/375.f), HX_SCREEN_WIDTH, HX_SCREEN_WIDTH*280.f/375.f);
    }
    return _header;
}
-(JXCategoryTitleView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 44);
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titles = @[@"房东信息", @"租客信息"];
        _categoryView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _categoryView.titleColor = UIColorFromRGB(0x666666);
        _categoryView.titleSelectedColor = HXControlBg;
        _categoryView.delegate = self;
        _categoryView.contentScrollView = self.scrollView;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.verticalMargin = 5.f;
        lineView.indicatorColor = HXControlBg;
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        
        FCHouseLandlordDetailVC *cvc = [FCHouseLandlordDetailVC new];
        [self addChildViewController:cvc];
        [vcs addObject:cvc];
        
        FCHouseRenterDetailVC *cvc0 = [FCHouseRenterDetailVC new];
        [self addChildViewController:cvc0];
        [vcs addObject:cvc0];
        _childVCs = vcs;
    }
    return _childVCs;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 44, HX_SCREEN_WIDTH, HX_SCREEN_HEIGHT-self.HXNavBarHeight-self.HXButtomHeight - 44);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
        // 加第一个视图
        UIViewController *targetViewController = self.childVCs.firstObject;
        targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
        [_scrollView addSubview:targetViewController.view];
    }
    return  _scrollView;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"房源详情"];

    UIBarButtonItem *moreItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreClicked) nomalImage:HXGetImage(@"客源更多") higeLightedImage:HXGetImage(@"客源更多") imageEdgeInsets:UIEdgeInsetsZero];
    UIBarButtonItem *shareItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareClicked) nomalImage:HXGetImage(@"分享") higeLightedImage:HXGetImage(@"分享") imageEdgeInsets:UIEdgeInsetsZero];

    self.navigationItem.rightBarButtonItems = @[moreItem,shareItem];
}
-(void)setUpMainTable
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(HX_SCREEN_WIDTH*280.f/375.f,0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = HXGlobalBg;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView addSubview:self.header];
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
- (IBAction)renterToolClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        FCGoodsJointVC *jvc = [FCGoodsJointVC new];
        [self.navigationController pushViewController:jvc animated:YES];
    }else if (sender.tag == 2){
        FCVisitNoteVC *vvc = [FCVisitNoteVC new];
        [self.navigationController pushViewController:vvc animated:YES];
    }else if (sender.tag == 3){
        FCSignRenterVC *svc = [FCSignRenterVC new];
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        FCReserveRenterVC *rvc = [FCReserveRenterVC new];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}
- (IBAction)landlordToolClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        FCGoodsJointShowVC *jvc = [FCGoodsJointShowVC new];
        [self.navigationController pushViewController:jvc animated:YES];
    }else{
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"联系房东" message:@"13878728367" constantWidth:HX_SCREEN_WIDTH - 50*2];
        zhAlertButton *cancelButton = [zhAlertButton buttonWithTitle:@"取消" handler:^(zhAlertButton * _Nonnull button) {
            [weakSelf.popupController1 dismiss];
        }];
        cancelButton.lineColor = UIColorFromRGB(0xDDDDDD);
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        zhAlertButton *okButton = [zhAlertButton buttonWithTitle:@"呼叫" handler:^(zhAlertButton * _Nonnull button) {
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
#pragma mark -- 主视图滑动通知处理
-(void)MainTableScroll:(NSNotification *)user{
    self.isCanScroll = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY>=tabOffsetY) {
            self.isCanScroll = NO;
            scrollView.contentOffset = CGPointMake(0, 0);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"childScrollCan" object:nil];
        }else{
            if (!self.isCanScroll) {
                [scrollView setContentOffset:CGPointZero];
            }
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    if (self.childVCs.count <= index) {return;}
    
    if (index == 0) {
        self.landlordToolView.hidden = NO;
        self.renterToolView.hidden = YES;
    }else{
        self.landlordToolView.hidden = YES;
        self.renterToolView.hidden = NO;
    }
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.hxn_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 添加pageView
    [cell.contentView addSubview:self.scrollView];
    [cell.contentView addSubview:self.categoryView];
    
    return cell;
}

@end
