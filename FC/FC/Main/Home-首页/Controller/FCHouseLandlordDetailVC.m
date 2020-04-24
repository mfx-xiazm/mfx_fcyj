//
//  FCHouseLandlordDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseLandlordDetailVC.h"
#import "FCHouseNearbyCell.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "FCFreeRuleShowView.h"
#import <zhPopupController.h>
#import "FCRaiseRuleShowView.h"

static NSString *const HouseNearbyCell = @"HouseNearbyCell";
@interface FCHouseLandlordDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,JXCategoryViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UILabel *houseTitle;
@property (weak, nonatomic) IBOutlet UILabel *freeRaseLabel;
@property(nonatomic,strong) YYLabel *freeRaseLb;
/** 是否滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
@end

@implementation FCHouseLandlordDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.houseTitle addFlagLabelWithName:@"二次出租" lineSpace:5.f titleString:@"三湘花园5栋1单元1002" withFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    [self.freeRaseLabel addSubview:self.freeRaseLb];
    NSString *freeRaseStr = @"按百分比【递增展示】\n按百分比【分摊每年】";
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:freeRaseStr];
    
    //设置文本size
    [attri yy_setTextHighlightRange:[freeRaseStr rangeOfString:@"【递增展示】"] color:HXControlBg backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        FCRaiseRuleShowView *show = [FCRaiseRuleShowView loadXibView];
        show.hxn_size = CGSizeMake(HX_SCREEN_WIDTH - 15.f*2, 40.f*5 + 40.f);
        zhPopupController *popupController = [[zhPopupController alloc] initWithView:show size:show.hxn_size];
        popupController.layoutType = zhPopupLayoutTypeCenter;
        popupController.dismissOnMaskTouched = YES;
        [popupController show];
    }];
    
    [attri yy_setTextHighlightRange:[freeRaseStr rangeOfString:@"【分摊每年】"] color:HXControlBg backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        FCFreeRuleShowView *show = [FCFreeRuleShowView loadXibView];
        show.hxn_size = CGSizeMake(HX_SCREEN_WIDTH - 15.f*2, 40.f*5 + 120.f);
        zhPopupController *popupController = [[zhPopupController alloc] initWithView:show size:show.hxn_size];
        popupController.layoutType = zhPopupLayoutTypeCenter;
        popupController.dismissOnMaskTouched = YES;
        [popupController show];
    }];
    
    //为文本设置属性
    attri.yy_font = [UIFont fontWithName:@"PingFang SC Regular" size:12];
    attri.yy_color = [UIColor colorWithHexString:@"#1A1A1A"];
    attri.yy_lineSpacing = 8.f;
    [attri yy_setColor:HXControlBg range:[freeRaseStr rangeOfString:@"【递增展示】"]];
    [attri yy_setColor:HXControlBg range:[freeRaseStr rangeOfString:@"【分摊每年】"]];
    self.freeRaseLb.attributedText = attri;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60.f, 0);
    self.scrollView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"MainTableScroll" object:nil];
    [self setUpCategoryView];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.freeRaseLb.frame = self.freeRaseLabel.bounds;
}
-(YYLabel*)freeRaseLb
{
    if (!_freeRaseLb) {
        _freeRaseLb = [YYLabel new];
        _freeRaseLb.backgroundColor = [UIColor whiteColor];
        _freeRaseLb.frame = self.freeRaseLabel.bounds;
        _freeRaseLb.userInteractionEnabled = YES;
        _freeRaseLb.numberOfLines = 0;
        _freeRaseLb.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _freeRaseLb;
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
    self.tableView.estimatedRowHeight = 0.f;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCHouseNearbyCell class]) bundle:nil] forCellReuseIdentifier:HouseNearbyCell];
}
#pragma mark -- 通知处理
-(void)childScrollHandle:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollCan"]){
        self.isCanScroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.isCanScroll = NO;
        [self.scrollView setContentOffset:CGPointZero];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isCanScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- JXCategoryViewDelegate
// 点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index;
{
    HXLog(@"选中");
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
