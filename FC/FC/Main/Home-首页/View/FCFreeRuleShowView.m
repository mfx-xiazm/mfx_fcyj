//
//  FCFreeRuleShowView.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCFreeRuleShowView.h"
#import "FCFreeRuleCell.h"

static NSString *const FreeRuleCell = @"FreeRuleCell";
@interface FCFreeRuleShowView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation FCFreeRuleShowView

-(void)awakeFromNib{
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCFreeRuleCell class]) bundle:nil] forCellReuseIdentifier:FreeRuleCell];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCFreeRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:FreeRuleCell forIndexPath:indexPath];
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
