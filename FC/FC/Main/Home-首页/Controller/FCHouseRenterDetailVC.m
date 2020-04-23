//
//  FCHouseRenterDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseRenterDetailVC.h"
#import "FCFitNoteCell.h"

static NSString *const FitNoteCell = @"FitNoteCell";

@interface FCHouseRenterDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 是否滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
@end

@implementation FCHouseRenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpRefresh];
    [self setUpEmptyView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"MainTableScroll" object:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
#pragma mark -- 通知处理
-(void)childScrollHandle:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollCan"]){
        self.isCanScroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.isCanScroll = NO;
        [self.tableView setContentOffset:CGPointZero];
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
-(void)setUpTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.f;
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCFitNoteCell class]) bundle:nil] forCellReuseIdentifier:FitNoteCell];
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
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCFitNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:FitNoteCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
