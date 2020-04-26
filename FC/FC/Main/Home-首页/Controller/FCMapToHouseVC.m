//
//  FCMapToHouseVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/26.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMapToHouseVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "FCCustomAnnotation.h"
#import "FCMapCallOutView.h"
#import <zhPopupController.h>
#import <WMZDropDownMenu.h>
#import "FCDropMenuCollectionHeader.h"
#import "FCDropMenuCollectionCell.h"
#import "FCMapSearchView.h"

@interface FCMapToHouseVC ()<MAMapViewDelegate,WMZDropMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapSuperView;
/** 地图 */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) zhPopupController *popupController;
@property (nonatomic, strong) WMZDropDownMenu *menu;
@property (nonatomic, strong) FCMapSearchView *searchView;
@end

@implementation FCMapToHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    // 地图
    [self.mapSuperView addSubview:self.mapView];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    FCCustomAnnotation *a1 = [[FCCustomAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake(30.538385, 114.365005);
    a1.title      = @"房源标题";
    a1.subtitle = @"房源副标题";
    FCMapCallOutView *outView = [FCMapCallOutView loadXibView];
    outView.hxn_size = CGSizeMake(100, 55);
    a1.outImage = [outView imageWithUIView];
    // 复制数据生成图片；
    [tempArr addObject:a1];
    
    FCCustomAnnotation *a2 = [[FCCustomAnnotation alloc] init];
    a2.coordinate = CLLocationCoordinate2DMake(30.528478, 114.359855);
    a2.title      = @"房源标题";
    a2.subtitle = @"房源副标题";
    FCMapCallOutView *outView2 = [FCMapCallOutView loadXibView];
    outView2.hxn_size = CGSizeMake(100, 55);
    a2.outImage = [outView2 imageWithUIView];
    // 复制数据生成图片；
    [tempArr addObject:a2];
    
    FCCustomAnnotation *a3 = [[FCCustomAnnotation alloc] init];
    a3.coordinate = CLLocationCoordinate2DMake(30.517831, 114.361057);
    a3.title      = @"房源标题";
    a3.subtitle = @"房源副标题";
    FCMapCallOutView *outView3 = [FCMapCallOutView loadXibView];
    outView3.hxn_size = CGSizeMake(100, 55);
    a3.outImage = [outView3 imageWithUIView];
    // 复制数据生成图片；
    [tempArr addObject:a3];
    
    FCCustomAnnotation *a4 = [[FCCustomAnnotation alloc] init];
    a4.coordinate = CLLocationCoordinate2DMake(30.520641, 114.379253);
    a4.title      = @"房源标题";
    a4.subtitle = @"房源副标题";
    FCMapCallOutView *outView4 = [FCMapCallOutView loadXibView];
    outView4.hxn_size = CGSizeMake(100, 55);
    a4.outImage = [outView4 imageWithUIView];
    // 复制数据生成图片；
    [tempArr addObject:a4];
    
    [self.mapView addAnnotations:tempArr];// 打标记
    [self.mapView showAnnotations:tempArr edgePadding:UIEdgeInsetsMake(100, 80, 100, 80) animated:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapSuperView.bounds;
}
-(WMZDropDownMenu *)menu
{
    if (_menu == nil) {
        WMZDropMenuParam *param =
        MenuParam()
        .wMainRadiusSet(5)
        .wMenuTitleEqualCountSet(2)
        .wPopOraignYSet(self.HXNavBarHeight+44.f)
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
-(FCMapSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [FCMapSearchView loadXibView];
        _searchView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, self.view.hxn_height);
        hx_weakify(self);
        _searchView.searchClickedCall = ^(NSInteger type, NSString *txt) {
            hx_strongify(weakSelf);
            [strongSelf.popupController dismissWithDuration:0.25 completion:nil];
            if (type == 0) {
                // 取消
            }else{
                // 发起搜索
            }
        };
    }
    return _searchView;
}
-(zhPopupController *)popupController
{
    if (!_popupController) {
        _popupController = [[zhPopupController alloc] initWithView:self.searchView size:self.searchView.bounds.size];
        _popupController.layoutType = zhPopupLayoutTypeBottom;
        _popupController.maskType = zhPopupMaskTypeClear;
    }
    return _popupController;
}
-(MAMapView *)mapView
{
    if (_mapView == nil) {
        [AMapServices sharedServices].enableHTTPS = YES;
        ///初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:self.mapSuperView.bounds];
        _mapView.showsCompass = NO;
        _mapView.delegate = self;
    }
    return _mapView;
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"地图找房"];
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClicked) image:HXGetImage(@"地图顶部搜索")];
    UIBarButtonItem *filterItem = [UIBarButtonItem itemWithTarget:self action:@selector(filterClicked) image:HXGetImage(@"地图筛选")];
    self.navigationItem.rightBarButtonItems = @[filterItem,searchItem];
}
-(void)searchClicked
{
    // 判断一个view是否为另一个view的子视图
    BOOL isSubView = [self.menu isDescendantOfView:self.view];
    if (isSubView) {
        [self.menu removeFromSuperview];
    }
    [self.popupController showInView:self.view duration:0.25 completion:nil];
}
-(void)filterClicked
{
    if (self.popupController.isPresenting) {
        [self.popupController dismissWithDuration:0.25 completion:nil];
    }
    
    // 判断一个view是否为另一个view的子视图
    BOOL isSubView = [self.menu isDescendantOfView:self.view];
    if (isSubView) {
        [self.menu removeFromSuperview];
    }else{
        [self.view addSubview:self.menu];
        [self.menu selectDefaltExpand];
    }
}
#pragma mark -- MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[FCCustomAnnotation class]]) {
        static NSString *reuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
        if (annotationView == nil){
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
        }
        annotationView.image = ((FCCustomAnnotation *)annotation).outImage;
        annotationView.canShowCallout = NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    HXLog(@"选中");
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
         @{@"name":@"地铁",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"},
         @{@"name":@"更多",@"font":@(13),@"normalColor":[UIColor blackColor],@"selectColor":HXControlBg,@"normalImage":@"筛选下拉",@"selectImage":@"筛选上拉"},
    ];
}
/*
*返回WMZDropIndexPath每行 每列的数据
*/
- (NSArray *)menu:(WMZDropDownMenu *)menu dataForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
      if (dropIndexPath.section == 0){
          if (dropIndexPath.row == 0) return @[@"不限",@"1号线",@"2号线",@"4号线",
                                               @"6号线",@"8号线",@"11号线"];
          if (dropIndexPath.row == 1) return @[];
      }else if (dropIndexPath.section == 1){
          if (dropIndexPath.row == 0) return @[@"1室",@"2室",@"3室",@"4室",@"5室",@"6室",@"7室",@"7室以上"];
          if (dropIndexPath.row == 1) return @[@"1000以下",@"1000~5000",@"5000~10000",@"10000以上"];
      }
      return @[];
}
/*
*返回setion行标题有多少列 默认1列
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 2;
    }
    return 2;
}
/*
*返回WMZDropIndexPath每行 每列 indexpath的cell的高度 默认35
*/
- (CGFloat)menu:(WMZDropDownMenu *)menu heightAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath AtIndexPath:(NSIndexPath *)indexpath{
    if (dropIndexPath.section == 0) {
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
            [menu updateData:@[@"不限",@"光谷广场",@"虎泉",@"街道口",@"中南路",@"岳家嘴",@"五里墩"] ForRowAtDropIndexPath:dropIndexPath];
        }
    }
}
#pragma mark -- WMZDropDownMenu样式动画代理
/*
* WMZDropIndexPath上的内容点击 是否关闭视图 default YES
*/
- (BOOL)menu:(WMZDropDownMenu *)menu closeWithTapAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.section == 0) {
        if (dropIndexPath.row == 1) {
            return YES;
        }else{
            return NO;
        }
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
    if (dropIndexPath.section == 1) {
        return MenuUICollectionView;
    }
    return MenuUITableView;
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
    return MenuHideAnimalNone;
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
    if (dropIndexPath.section == 1) {
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
    
    header.textLa.text = @[@"户型选择",@"价格（元/月）"][dropIndexPath.row];
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
    if (section == 1) {
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
    [self.menu removeFromSuperview];
}
@end
