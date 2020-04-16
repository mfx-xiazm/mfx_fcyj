//
//  FCContractTemplateVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/16.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCContractTemplateVC.h"
#import "FCContractTemplateCell.h"
#import "HXSearchBar.h"

static NSString *const ContractTemplateCell = @"ContractTemplateCell";
@interface FCContractTemplateVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCContractTemplateVC

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
}
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
    search.placeholder = @"请输入合同名称";
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCContractTemplateCell class]) bundle:nil] forCellReuseIdentifier:ContractTemplateCell];
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
-(void)cancelClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCContractTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:ContractTemplateCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
