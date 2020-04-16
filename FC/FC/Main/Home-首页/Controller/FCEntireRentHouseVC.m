//
//  FCEntireRentHouseVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/15.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCEntireRentHouseVC.h"
#import "FCEntireRentHouseCell.h"
#import "HXSearchBar.h"
#import <WMZDropDownMenu.h>
#import "FCDropMenuCollectionHeader.h"
#import "FCDropMenuCollectionCell.h"

static NSString *const EntireRentHouseCell = @"EntireRentHouseCell";
@interface FCEntireRentHouseVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WMZDropMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, strong) WMZDropDownMenu *menu;
@end

@implementation FCEntireRentHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpMenuView];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 懒加载

#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClicked) title:@"取消" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium ] titleColor:[UIColor colorWithHexString:@"#1A1A1A"] highlightedColor:[UIColor colorWithHexString:@"#1A1A1A"] titleEdgeInsets:UIEdgeInsetsZero];
    
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
-(void)setUpMenuView
{
    WMZDropMenuParam *param =
    MenuParam()
    .wMainRadiusSet(5)
    .wPopOraignYSet(self.HXNavBarHeight+44.f)
    .wCollectionViewCellSelectTitleColorSet(HXControlBg)
    .wCollectionViewCellTitleColorSet([UIColor blackColor])
    .wCollectionViewSectionRecycleCountSet(8)
    .wMaxHeightScaleSet(0.5)
    //注册自定义的collectionViewHeadView  如果使用了自定义collectionViewHeadView 必填否则会崩溃
    .wReginerCollectionHeadViewsSet(@[@"FCDropMenuCollectionHeader"])
    //注册自定义collectionViewCell 类名 如果使用了自定义collectionView 必填否则会崩溃
    .wReginerCollectionCellsSet(@[@"FCDropMenuCollectionCell"]);
    
    WMZDropDownMenu *menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, 44.f) withParam:param];
    menu.delegate = self;
    self.menu = menu;
    [self.menuView addSubview:menu];
}
-(void)setUpTableView
{
    self.tableView.rowHeight = 0;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCEntireRentHouseCell class]) bundle:nil] forCellReuseIdentifier:EntireRentHouseCell];
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
#pragma mark -- 点击事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField hasText]) {
        [MBProgressHUD showOnlyTextToView:self.view title:@"请输入关键字"];
        return NO;
    }
    [textField resignFirstResponder];//放弃响应
    // 发起搜索
    return YES;
}
#pragma mark -- 业务逻辑
-(void)cancelClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
        @{@"name":@"位置",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"},
         @{@"name":@"店面",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"},
         @{@"name":@"状态",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"},
         @{@"name":@"更多",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"},
    ];
}
/*
*返回WMZDropIndexPath每行 每列的数据
*/
- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 0){
          if (dropIndexPath.row == 0) {
              return @[@{@"name":@"不限",@"ID":@"1001"},@{@"name":@"地铁",@"ID":@"1001"},@{@"name":@"区域",@"ID":@"1001"}];
          }
          return @[];
      }else if (dropIndexPath.section == 1){
          if (dropIndexPath.row == 0) return @[@"不限",@"东一店",@"东二店",@"东三店",
                                               @"西一店",@"西二店",@"西三店"];
          if (dropIndexPath.row == 1) return @[];
      }else if (dropIndexPath.section == 2){
           return @[@"未租",@"已定",@"已租",@"租户退租中",@"租户续租中",@"租户转租中",@"租户换房中",@"房东退租中",@"房东续租中",@"房东已冻结",@"房间已冻结"];
      }else if (dropIndexPath.section == 3){
           if (dropIndexPath.row == 0) return @[@"1室",@"2室",@"3室",@"4室",@"5室",@"6室",@"7室",@"7室以上"];
           if (dropIndexPath.row == 1) return @[@"毛胚房",@"简装房",@"改装房",@"精装房"];
           if (dropIndexPath.row == 2) return @[@"3天内到期",@"5天内到期"];
           if (dropIndexPath.row == 3) return @[@"0~20天",@"21~40天",@"41~60天",@"60天以上"];
      }
      return @[];
}
/*
*返回setion行标题有多少列 默认1列
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }
    return 4;
}
/*
*返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 0) {
        return 40;
    }else if (dropIndexPath.section == 1) {
        return 40;
    }else if (dropIndexPath.section == 2) {
        return 40;
    }
    return 30;
}
#pragma mark -- WMZDropDownMenu交互自定义代理
/*
* cell点击方法
*/
- (void)menu:(WMZDropDownMenu *)menu didSelectRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath dataIndexPath:(NSIndexPath *)indexpath data:(WMZDropTree*)data{
    //手动更新二级联动数据
    if (dropIndexPath.section == 0) {
        if (dropIndexPath.row == 0) {
            [menu updateData:@[@"不限",@"江汉区",@"汉阳区",@"黄陂区",@"青山区",@"静安区",@"洪山区"] ForRowAtDropIndexPath:dropIndexPath];
        }else if (dropIndexPath.row == 1) {
            [menu updateData:@[@"不限",@"光谷广场",@"卓刀泉",@"工业四路",@"广埠屯",@"虎泉",@"五里墩",@"七里庙",@"十里铺"] ForRowAtDropIndexPath:dropIndexPath];
        }else{
         
        }
    }else if (dropIndexPath.section == 1) {
        if (dropIndexPath.row == 0) {
            [menu updateData:@[@"不限",@"洪山一组",@"洪山二组",@"洪山三组",@"武昌一组",@"武昌二组",@"武昌三组"] ForRowAtDropIndexPath:dropIndexPath];
        }
    }
}
#pragma mark -- WMZDropDownMenu样式动画代理
/*
* WMZDropIndexPath上的内容点击 是否关闭视图 default YES
*/
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0){
        if (dropIndexPath.row == 2) {
            return YES;
        }else{
            return NO;
        }
    }else if (dropIndexPath.section == 1) {
        if (dropIndexPath.row == 1) {
            return YES;
        }else{
            return NO;
        }
    }else if (dropIndexPath.section == 2) {
        return YES;
    }
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
    if (dropIndexPath.section == 3) {
        return MenuUICollectionView;
    }
    return MenuUITableView;
}
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
*headView标题
*/
//- (NSString *)menu:(WMZDropDownMenu *)menu titleForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
//    if (dropIndexPath.section == 3){
//        return @[@"户型选择",@"装修类型",@"即将到期",@"空置时间"][dropIndexPath.row];
//    }
//    return nil;
//}
/*
*自定义headView高度 collectionView默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightForHeadViewAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 3) {
        return 40;
    }
    return 0;
}
/*
*自定义collectionView headView
*/
- (UICollectionReusableView*)menu:(WMZDropDownMenu *)menu headViewForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath
{
    FCDropMenuCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FCDropMenuCollectionHeader" forIndexPath:indexpath];
    
    header.textLa.text = @[@"户型选择",@"装修类型",@"即将到期",@"空置时间"][dropIndexPath.row];
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
    if (section == 3) {
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
    return nil;
}
/*
*获取所有选中的数据
*/
-(void)menu:(WMZDropDownMenu *)menu getAllSelectData:(NSArray *)selectData
{
    NSLog(@"%@",selectData);
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCEntireRentHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:EntireRentHouseCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 110.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
