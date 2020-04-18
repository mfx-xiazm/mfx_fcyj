//
//  FCContractManageVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCContractManageVC.h"
#import "FCContractManageCell.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "HXSearchBar.h"
#import <WMZDropDownMenu.h>
#import "FCDropMenuCollectionHeader.h"
#import "FCDropMenuCollectionCell.h"
#import "FCAddOutContractVC.h"
#import "FCAddInContractVC.h"
#import "FCOutContractDetailVC.h"
#import "FCInContractDetailVC.h"

static NSString *const ContractManageCell = @"ContractManageCell";
@interface FCContractManageVC ()<UITableViewDelegate,UITableViewDataSource,JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,WMZDropMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (nonatomic, strong) WMZDropDownMenu *menu;

@end

@implementation FCContractManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(WMZDropDownMenu *)menu
{
    if (_menu == nil) {
        WMZDropMenuParam *param =
        MenuParam()
        .wMainRadiusSet(5)
        .wMenuTitleEqualCountSet(1)
        .wPopOraignYSet(self.HXNavBarHeight)
        .wCollectionViewCellSelectTitleColorSet(HXControlBg)
        .wCollectionViewCellTitleColorSet([UIColor blackColor])
        .wCollectionViewSectionRecycleCountSet(8)
        .wMaxHeightScaleSet(0.5)
        //注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填否则会崩溃
        .wReginerCollectionHeadViewsSet(@[@"FCDropMenuCollectionHeader"])
        //注册自定义collectionViewCell 类名 如果使用了自定义collectionView 必填否则会崩溃
        .wReginerCollectionCellsSet(@[@"FCDropMenuCollectionCell"]);
        
        _menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, 44.f) withParam:param];
        _menu.delegate = self;
    }
    return _menu;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    UIBarButtonItem *addItem = [UIBarButtonItem itemWithTarget:self action:@selector(addContractClicked) nomalImage:HXGetImage(@"房源添加") higeLightedImage:HXGetImage(@"房源添加") imageEdgeInsets:UIEdgeInsetsZero];
    
    UIBarButtonItem *filterItem = [UIBarButtonItem itemWithTarget:self action:@selector(filterHouseClicked) nomalImage:HXGetImage(@"筛选") higeLightedImage:HXGetImage(@"筛选") imageEdgeInsets:UIEdgeInsetsZero];
    
    self.navigationItem.rightBarButtonItems = @[addItem,filterItem];
    
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = HXGlobalBg;
    search.frame = CGRectMake(50.f, 7.f, HX_SCREEN_WIDTH-50.f*2, 30.f);
    search.layer.cornerRadius = 15.f;
    search.layer.masksToBounds = YES;
    search.placeholder = @"请输入小区、商圈、地铁";
    search.searchIcon = @"地图搜索";
    search.delegate = self;
    [self.navigationItem setTitleView:search];
}
-(void)setUpTableView
{
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCContractManageCell class]) bundle:nil] forCellReuseIdentifier:ContractManageCell];
}
/** 添加刷新控件 */
-(void)setUpRefresh
{
    hx_weakify(self);
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        hx_strongify(weakSelf);
        [strongSelf.tableView.mj_footer resetNoMoreData];
    }];
    //追加尾部刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //hx_strongify(weakSelf);
    }];
}
-(void)setUpEmptyView
{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"no_data" titleStr:nil detailStr:@"暂无内容"];
    emptyView.contentViewOffset = -(self.HXNavBarHeight);
    emptyView.subViewMargin = 20.f;
    emptyView.detailLabTextColor = UIColorFromRGB(0x909090);
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFangSC-Semibold" size: 16];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.contentEdgeInsetLeft = 25;
    _categoryView.contentEdgeInsetRight = 25;
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"全部", @"未审核", @"审核中",@"已审核"];
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
}
#pragma mark -- JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    [self.tableView reloadData];
}
#pragma mark -- 点击事件
-(void)addContractClicked
{
    if (arc4random_uniform(2)%2) {
        FCAddOutContractVC *avc = [FCAddOutContractVC new];
        [self.navigationController pushViewController:avc animated:YES];
    }else{
        FCAddInContractVC *hvc = [FCAddInContractVC new];
        [self.navigationController pushViewController:hvc animated:YES];
    }
}
-(void)filterHouseClicked
{
    // 判断一个view是否为另一个view的子视图
    BOOL isSubView = [self.menu isDescendantOfView:self.view];
    if (isSubView) {
        [self.menu removeFromSuperview];
    }else{
        [self.view addSubview:self.menu];
    }
    [self.menu selectDefaltExpand];
}
#pragma mark -- WMZDropMenuDelegate必须实现的代理
/*
*标题数组
 1 传字符串数组 其余属性为默认 如 @[@"标题1"],@"标题2",@"标题3",@"标题4"]
 2 可传带字典的数组
 字典参数@{
 @"name":@"标题",
 @"font":@(15)(字体大小)
 @"normalColor":[UIColor blackClor](普通状态下的字体颜色)
 @"selectColor":[UIColor redColor](选中状态下的字体颜色)
 @"normalImage":@"1"(普通状态下的图片)
 @"selectImage":@"2"(选中状态下的图片)
 @"reSelectImage":@"3"(选中状态下再点击的图片~>用于点击两次才回到原来的场景)
 @"lastFix":@(YES) (最后一个固定在在右边,仅最后一个有效)
 }
*/
- (NSArray*)titleArrInMenu:(WMZDropDownMenu *)menu{
    
    return @[
         @{@"name":@"更多",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"}
    ];
}
/*
*返回WMZDropIndexPath每行 每列的数据
*/
- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 0){
         if (dropIndexPath.row == 0) return @[@"合同类型1",@"合同类型2",@"合同类型3",@"合同类型4"];
          if (dropIndexPath.row == 1) return @[@"待签约",@"已签约",@"期满退租",@"结算重签"];
          if (dropIndexPath.row == 2) return @[@"不限",@"最近一周",@"最近一个月",@"最近三个月"];
      }
      return @[];
}
/*
*返回setion行标题有多少列 默认1列
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    return 3;
}
/*
*返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
     return 30;
}
#pragma mark -- WMZDropDownMenu交互自定义代理
/*
* WMZDropIndexPath上的内容点击 是否关闭视图 default YES
*/
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}
/*
*是否关联 其他标题 即选中其他标题 此标题会不会取消选中状态 default YES 取消，互不关联
*/
-(BOOL)menu:(WMZDropDownMenu *)menu dropIndexPathConnectInSection:(NSInteger)section
{
    return NO;
}
/*
*返回WMZDropIndexPath每行 每列的UI样式  默认MenuUITableView
  注:设置了dropIndexPath.section 设置了 MenuUITableView 那么row则全部为MenuUITableView 保持统一风格
*/
- (MenuUIStyle)menu:(WMZDropDownMenu *)menu uiStyleForRowIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return MenuUICollectionView;
}
/*
*返回WMZDropIndexPath每行 每列 显示的个数
 注:
    样式MenuUICollectionView         默认4个
    样式MenuUITableView    默认1个 传值无效
*/
//- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//    return 4;
//}
/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
 注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
*/
- (MenuShowAnimalStyle)menu:(WMZDropDownMenu *)menu showAnimalStyleForRowInSection:(NSInteger)section{
    return MenuShowAnimalBottom;
}
/*
*返回section行标题数据视图消失的动画样式   默认 MenuHideAnimalTop
 注:最后一个默认是筛选 消失动画为 MenuHideAnimalLeft
*/
- (MenuHideAnimalStyle)menu:(WMZDropDownMenu *)menu hideAnimalStyleForRowInSection:(NSInteger)section{
    return MenuHideAnimalTop;
}
/*
*返回WMZDropIndexPath每行 每列的编辑类型 单选|多选  默认单选
*/
- (MenuEditStyle)menu:(WMZDropDownMenu *)menu editStyleForRowAtDropIndexPath:(WMZDropIndexPath*)dropIndexPath
{
    return MenuEditOneCheck;
}
/*
*WMZDropIndexPath是否显示收缩功能 default >参数wCollectionViewSectionShowExpandCount 显示；会有展开按钮的显示
*/
- (BOOL)menu:(WMZDropDownMenu *)menu showExpandAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return NO;
}
/*
*自定义headView高度 collectionView默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    return 40;
}
/*
*自定义collectionView headView
*/
- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath
{
    FCDropMenuCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FCDropMenuCollectionHeader" forIndexPath:indexpath];
    
    header.textLa.text = @[@"合同类型",@"租约状态",@"签署日期"][dropIndexPath.row];
    return header;
}
/*
 *自定义collectionViewCell内容
 */
- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    FCDropMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FCDropMenuCollectionCell class]) forIndexPath:indexpath];
    cell.textLa.text = model.name;
    cell.textLa.textColor = model.isSelected?[UIColor whiteColor]:[UIColor blackColor];
    cell.textLa.backgroundColor = model.isSelected?HXControlBg:HXGlobalBg;
    return cell;
}
/*
*自定义每行全局尾部视图 多用于交互事件
*/
- (UIView*)menu:(WMZDropDownMenu *)menu userInteractionFootViewInSection:(NSInteger)section{
        UIView *userInteractionFootView = [UIView new];
    userInteractionFootView.backgroundColor = [UIColor whiteColor];
    userInteractionFootView.frame = CGRectMake(0, 0, menu.dataView.frame.size.width, 50);
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(HX_SCREEN_WIDTH/2.0-110.f, 10.f,100.f,30.f);
    btn.layer.borderColor = [UIColor colorWithHexString:@"#1A1A1A"].CGColor;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 2;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitle:@"重置" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
    [btn addTarget:menu action:@selector(reSetAction) forControlEvents:UIControlEventTouchUpInside];
    [userInteractionFootView addSubview:btn];
    
    UIButton *btn1 = [UIButton new];
    btn1.frame = CGRectMake(HX_SCREEN_WIDTH/2.0+10.f, 10.f,100.f,30.f);
    btn1.layer.borderColor = [UIColor colorWithHexString:@"#845D32"].CGColor;
    btn1.layer.borderWidth = 1;
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    btn1.clipsToBounds = YES;
    btn1.layer.cornerRadius = 2;
    [btn1 setBackgroundColor:[UIColor colorWithHexString:@"#845D32"]];
    [btn1 setTitle:@"确定" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:menu action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [userInteractionFootView addSubview:btn1];
    
    return userInteractionFootView;
}
/*
*获取所有选中的数据
*/
-(void)menu:(WMZDropDownMenu *)menu getAllSelectData:(NSArray *)selectData
{
    NSLog(@"%@",selectData);
    [menu removeFromSuperview];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCContractManageCell *cell = [tableView dequeueReusableCellWithIdentifier:ContractManageCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arc4random_uniform(2)%2) {
        FCOutContractDetailVC *dvc = [FCOutContractDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        FCInContractDetailVC *dvc = [FCInContractDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

@end
