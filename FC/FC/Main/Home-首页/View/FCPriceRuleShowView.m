//
//  FCPriceRuleShowView.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCPriceRuleShowView.h"
#import "FCRaiseRuleCell.h"

static NSString *const RaiseRuleCell = @"RaiseRuleCell";
@interface FCPriceRuleShowView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FCPriceRuleShowView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.estimatedRowHeight = 0;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCRaiseRuleCell class]) bundle:nil] forCellReuseIdentifier:RaiseRuleCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCRaiseRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:RaiseRuleCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bgView.hidden = YES;
    cell.bgView1.hidden = YES;
    cell.bgView2.hidden = NO;
    if (indexPath.row%2) {
        cell.bgView2.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }else{
        cell.bgView2.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
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
