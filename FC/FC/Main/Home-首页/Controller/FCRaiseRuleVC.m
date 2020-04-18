//
//  FCRaiseRuleVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/17.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCRaiseRuleVC.h"
#import "FCRaiseRuleCell.h"
#import "FCRaiseRuleHeader.h"

static NSString *const RaiseRuleCell = @"RaiseRuleCell";
@interface FCRaiseRuleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FCRaiseRuleHeader *header;

@end

@implementation FCRaiseRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 65.f);
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"递增约定"];
}
-(void)setUpTableView
{
    self.tableView.estimatedRowHeight = 0;//预估高度
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCRaiseRuleCell class]) bundle:nil] forCellReuseIdentifier:RaiseRuleCell];
    
    FCRaiseRuleHeader *header = [FCRaiseRuleHeader loadXibView];
    header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 65.f);
    self.header = header;
    self.tableView.tableHeaderView = header;
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
    FCRaiseRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:RaiseRuleCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row%2) {
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }else{
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
