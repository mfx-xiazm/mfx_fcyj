//
//  FCMallHomeVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/22.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMallHomeVC.h"
#import "HXTabBarController.h"
#import "FCMallHomeCell.h"
#import "HXSearchBar.h"
#import "FCMallHomeHeader.h"
#import "FCUnlockDetailVC.h"
#import "FCHousekeepDetailVC.h"
#import "FCHotelDetailVC.h"
#import "HXMallTabBarController.h"

static NSString *const MallHomeCell = @"MallHomeCell";
@interface FCMallHomeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCMallHomeHeader *header;
@end

@implementation FCMallHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,(HX_SCREEN_WIDTH-12.f*2)*15.f/35.f + 55.f + 10.f);
}
-(FCMallHomeHeader *)header
{
    if (!_header) {
        _header = [FCMallHomeHeader loadXibView];
        _header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH,(HX_SCREEN_WIDTH-12.f*2)*15.f/35.f + 55.f + 10.f);
    }
    return _header;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    button.hxn_size = CGSizeMake(30, 44);
    // 让按钮内部的所有内容左对齐
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) title:@"取消" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium ] titleColor:[UIColor colorWithHexString:@"#1A1A1A"] highlightedColor:[UIColor colorWithHexString:@"#1A1A1A"] titleEdgeInsets:UIEdgeInsetsZero];
    
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = HXGlobalBg;
    search.frame = CGRectMake(50.f, 7.f, HX_SCREEN_WIDTH-50.f*2, 30.f);
    search.layer.cornerRadius = 15.f;
    search.layer.masksToBounds = YES;
    search.placeholder = @"请输入名宿名称/服务名称";
    search.searchIcon = @"地图搜索";
    search.delegate = self;
    [self.navigationItem setTitleView:search];
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
    self.tableView.backgroundColor = HXGlobalBg;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCMallHomeCell class]) bundle:nil] forCellReuseIdentifier:MallHomeCell];
    
    self.tableView.tableHeaderView = self.header;
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
-(void)back
{
    HXTabBarController *tabBarController = [[HXTabBarController alloc] init];
    tabBarController.selectedIndex = ((HXMallTabBarController *)self.navigationController.tabBarController).backSelectedIndex;
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCMallHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:MallHomeCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger type = indexPath.row%3;
    if (type == 0) {
        cell.jiaZhengView.hidden = NO;
        cell.minSuView.hidden = YES;
        cell.kaiSuoView.hidden = YES;
    }else if (type == 1) {
        cell.jiaZhengView.hidden = YES;
        cell.minSuView.hidden = NO;
        cell.kaiSuoView.hidden = YES;
    }else {
        cell.jiaZhengView.hidden = YES;
        cell.minSuView.hidden = YES;
        cell.kaiSuoView.hidden = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = indexPath.row%3;
    if (type == 0) {
        FCHousekeepDetailVC *dvc = [FCHousekeepDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (type == 1) {
        FCHotelDetailVC *dvc = [FCHotelDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else {
        FCUnlockDetailVC *dvc = [FCUnlockDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}
@end
