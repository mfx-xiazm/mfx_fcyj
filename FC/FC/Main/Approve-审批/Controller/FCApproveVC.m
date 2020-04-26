//
//  FCApproveVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/13.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCApproveVC.h"
#import "FCApproveChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import <WMZDropDownMenu.h>
#import "FCDropMenuCollectionHeader.h"
#import "FCDropMenuCollectionCell.h"
#import "FCDropMenuRangeCollectionCell.h"

@interface FCApproveVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,WMZDropMenuDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
@property (nonatomic, strong) WMZDropDownMenu *menu;

@end

@implementation FCApproveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCategoryView];
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
        .wReginerCollectionCellsSet(@[@"FCDropMenuCollectionCell",@"FCDropMenuRangeCollectionCell"]);
        
        _menu = [[WMZDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, HX_SCREEN_WIDTH, 44.f) withParam:param];
        _menu.delegate = self;
    }
    return _menu;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<self.categoryView.titles.count;i++) {
            FCApproveChildVC *cvc0 = [FCApproveChildVC new];
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
-(void)setUpNavBar
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(filterClicked) nomalImage:HXGetImage(@"筛选") higeLightedImage:HXGetImage(@"筛选") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titles = @[@"待办", @"我的"];
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
    _categoryView.delegate = self;
    _categoryView.contentScrollView = self.scrollView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*self.childVCs.count, 0);
    
    // 加第一个视图
    UIViewController *targetViewController = self.childVCs.firstObject;
    targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, _scrollView.hxn_height);
    [_scrollView addSubview:targetViewController.view];
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
#pragma mark - 点击
-(void)filterClicked
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
         if (dropIndexPath.row == 0) return @[@"审批中",@"审批通过",@"审批驳回"];
          if (dropIndexPath.row == 1) return @[@"房东退房",@"房东续租",@"房东交割单",@"收房合同",@"业主委托终止结算",@"银行卡更换"];
          if (dropIndexPath.row == 2) return @[@"租客退房",@"租客转租",@"租客换房",@"租客交割单",@"出房合同",@"定金退订",@"定金违约",@"代金券审批",@"延长定金有效期",@"多付款退款"];
          if (dropIndexPath.row == 3) return @[@{@"config":@{@"lowPlaceholder":@"起始",@"highPlaceholder":@"终止"}}];
      }
      return @[];
}
/*
*返回setion行标题有多少列 默认1列
*/
- (NSInteger)menu:(WMZDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section{
    return 4;
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
- (NSInteger)menu:(WMZDropDownMenu *)menu countForRowAtDropIndexPath:(WMZDropIndexPath *)dropIndexPath{
    if (dropIndexPath.row == 3) {
        return 1;
    }
    return 4;
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
    
    header.textLa.text = @[@"状态",@"收房审批",@"出房审批",@"时间"][dropIndexPath.row];
    return header;
}
/*
 *自定义collectionViewCell内容
 */
- (UICollectionViewCell*)menu:(WMZDropDownMenu *)menu cellForUICollectionView:(WMZDropCollectionView*)collectionView AtDropIndexPath:(WMZDropIndexPath*)dropIndexPath AtIndexPath:(NSIndexPath*)indexpath dataForIndexPath:(WMZDropTree*)model{
    if (dropIndexPath.row != 3) {
        FCDropMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FCDropMenuCollectionCell class]) forIndexPath:indexpath];
        if (model.name.length >= 6) {
            cell.textLa.font = [UIFont systemFontOfSize:11];
        }else{
            cell.textLa.font = [UIFont systemFontOfSize:13];
        }
        cell.textLa.text = model.name;
        cell.textLa.textColor = model.isSelected?[UIColor whiteColor]:[UIColor blackColor];
        cell.textLa.backgroundColor = model.isSelected?HXControlBg:HXGlobalBg;
        return cell;
    }else{
        FCDropMenuRangeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FCDropMenuRangeCollectionCell class]) forIndexPath:indexpath];
        if ([model isKindOfClass:[WMZDropTree class]]) {
            WMZDropTree *tree = model;
            tree.lowPlaceholder = tree.config[@"lowPlaceholder"]?:tree.lowPlaceholder;
            tree.highPlaceholder = tree.config[@"highPlaceholder"]?:tree.highPlaceholder;
            cell.lowText.placeholder =  tree.lowPlaceholder;
            cell.highText.placeholder = tree.highPlaceholder;
            
            cell.lowText.text = tree.rangeArr.count>1?tree.rangeArr[0]:@"";
            cell.highText.text = tree.rangeArr.count>1?tree.rangeArr[1]:@"";
            if (!tree.normalRangeArr||!tree.normalRangeArr.count) {
                if ([cell.lowText.text length]&&[cell.highText.text length]) {
                    tree.normalRangeArr = @[cell.lowText.text,cell.highText.text];
                }
            }
            MenuWeakSelf(cell)
            cell.fieldBlock = ^(UITextField * _Nonnull textField, NSString * _Nonnull string) {
                MenuStrongSelf(weakObject)
                if (textField == cell.lowText) {
                    strongObject.lowT = string;
                    if (strongObject.lowT) {
                        tree.rangeArr[0] = strongObject.lowT;
                    }
                }else{
                    strongObject.highT = string;
                    if (strongObject.highT) {
                        tree.rangeArr[1] = strongObject.highT;
                    }
                }
                tree.isSelected = YES;
            };
            tree.isSelected = ([cell.lowText.text length]>0||[cell.highText.text length]>0);
            cell.lowText.backgroundColor = menu.param.wCollectionViewCellBgColor;
            cell.highText.backgroundColor = menu.param.wCollectionViewCellBgColor;
        }
        return cell;
    }
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
@end
