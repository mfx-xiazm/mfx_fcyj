//
//  FCMallOrderListVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMallOrderListVC.h"
#import "FCMallOrderCell2.h"
#import "FCMallOrderCell.h"
#import "FCUnlockOrderDetailVC.h"
#import "FCHousekeepOrderDetailVC.h"
#import "FCHotelOrderDetailVC.h"

static NSString *const MallOrderCell2 = @"MallOrderCell2";
static NSString *const MallOrderCell = @"MallOrderCell";
@interface FCMallOrderListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCMallOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 视图
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCMallOrderCell2 class]) bundle:nil] forCellReuseIdentifier:MallOrderCell2];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCMallOrderCell class]) bundle:nil] forCellReuseIdentifier:MallOrderCell];
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
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger type = indexPath.row%2;
    if (type == 0) {
        FCMallOrderCell2 *cell = [tableView dequeueReusableCellWithIdentifier:MallOrderCell2 forIndexPath:indexPath];
        NSInteger subType = arc4random_uniform(3)%2;
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (subType == 0) {
            cell.jiaZhengView.hidden = NO;
            cell.minSuView.hidden = YES;
            cell.kaiSuoView.hidden = YES;
        }else if (subType == 1) {
            cell.jiaZhengView.hidden = YES;
            cell.minSuView.hidden = NO;
            cell.kaiSuoView.hidden = YES;
        }else {
            cell.jiaZhengView.hidden = YES;
            cell.minSuView.hidden = YES;
            cell.kaiSuoView.hidden = NO;
        }
        return cell;
    }else{
        FCMallOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:MallOrderCell forIndexPath:indexPath];
        NSInteger subType = arc4random_uniform(3)%2;
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (subType == 0) {
            cell.jiaZhengView.hidden = NO;
            cell.minSuView.hidden = YES;
            cell.kaiSuoView.hidden = YES;
        }else if (subType == 1) {
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
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = indexPath.row%2;
    if (type == 0) {
        return 180.f;
    }else{
        return 220.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = indexPath.row%3;
    if (type == 0) {
        FCHousekeepOrderDetailVC *dvc = [FCHousekeepOrderDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else if (type == 1) {
        FCHotelOrderDetailVC *dvc = [FCHotelOrderDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else {
        FCUnlockOrderDetailVC *dvc = [FCUnlockOrderDetailVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

@end
