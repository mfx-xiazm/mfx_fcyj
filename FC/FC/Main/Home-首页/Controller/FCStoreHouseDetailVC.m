//
//  FCStoreHouseDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/18.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCStoreHouseDetailVC.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "FCBannerCell.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "FCHouseNearbyCell.h"
#import "FCPerfectHouseVC.h"
#import "FCHouseMoreView.h"
#import "FCHouseMoreObject.h"
#import <zhPopupController.h>
#import "zhAlertView.h"
#import "FCStoreFollowVC.h"
#import "FCEndAgencyVC.h"
#import "FCEndAgencyDetailVC.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";
@interface FCStoreHouseDetailVC ()<UITableViewDelegate,UITableViewDataSource,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate,JXCategoryViewDelegate,FCHouseMoreViewDelegate,FCHouseMoreViewDataSource>
/* 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCHouseMoreView *moreView;
@property (nonatomic, strong) NSMutableArray *moreObjects;
@property (nonatomic, strong) zhPopupController *popupController;
@property (nonatomic, strong) zhPopupController *popupController1;

@end

@implementation FCStoreHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCycleView];
    [self setUpCategoryView];
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
-(NSMutableArray *)moreObjects
{
    if (_moreObjects == nil) {
        _moreObjects = [NSMutableArray array];
        FCHouseMoreObject *object1 = [[FCHouseMoreObject alloc] init];
        object1.cateName = @"修改房源";
        object1.imageName = @"修改客源";
        [_moreObjects addObject:object1];
        
        FCHouseMoreObject *object2 = [[FCHouseMoreObject alloc] init];
        object2.cateName = @"完善房源";
        object2.imageName = @"完善客源";
        [_moreObjects addObject:object2];
        
        FCHouseMoreObject *object3 = [[FCHouseMoreObject alloc] init];
        object3.cateName = @"删除房源";
        object3.imageName = @"删除客源";
        [_moreObjects addObject:object3];
    }
    return _moreObjects;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"房源详情"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(moreClicked) nomalImage:HXGetImage(@"客源更多") higeLightedImage:HXGetImage(@"客源更多") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCycleView
{
    [self.cycleView bringSubviewToFront:self.currentPage];
    
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([FCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];

    [self.cycleView reloadData];
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"地铁", @"公交", @"商圈"];
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
}
-(void)setUpTableView
{
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
}
#pragma mark -- 点击事件
-(void)moreClicked
{
    _popupController = [[zhPopupController alloc] initWithView:self.moreView size:self.moreView.bounds.size];
    _popupController.layoutType = zhPopupLayoutTypeBottom;
    _popupController.dismissOnMaskTouched = YES;
    [_popupController show];
}
- (IBAction)followRecordBtnClicked:(SPButton *)sender {
    FCStoreFollowVC *fvc = [FCStoreFollowVC new];
    [self.navigationController pushViewController:fvc animated:YES];
}
- (IBAction)signOrEndAgencyClicked:(UIButton *)sender {
    if (arc4random_uniform(2)%2) {
        FCEndAgencyDetailVC *dvc = [FCEndAgencyDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        FCEndAgencyVC *avc = [FCEndAgencyVC new];
        [self.navigationController pushViewController:avc animated:YES];
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
    return 3;
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
        
    }else if (indexPath.row == 1) {
        FCPerfectHouseVC *pvc = [FCPerfectHouseVC new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else{
        hx_weakify(self);
        zhAlertView *alert = [[zhAlertView alloc] initWithTitle:@"提示" message:@"确定要删除房源吗？" constantWidth:HX_SCREEN_WIDTH - 50*2];
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
}
#pragma mark -- JXCategoryViewDelegate
// 点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index;
{
    HXLog(@"选中");
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0.f;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.currentPage.text = [NSString stringWithFormat:@"%zd/3",toIndex+1];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCHouseNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseNearbyCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
