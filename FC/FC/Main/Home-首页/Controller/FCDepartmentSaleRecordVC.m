//
//  FCDepartmentSaleRecordVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/18.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCDepartmentSaleRecordVC.h"
#import "FCSaleRecordCell.h"

static NSString *const SaleRecordCell = @"SaleRecordCell";
@interface FCDepartmentSaleRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation FCDepartmentSaleRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"统计报表"];
    [self setUpTableView];
}
#pragma mark -- 视图
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
    self.tableView.scrollEnabled = NO;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSaleRecordCell class]) bundle:nil] forCellReuseIdentifier:SaleRecordCell];

    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.tableViewHeight.constant = weakSelf.tableView.contentSize.height;
    });
}
#pragma mark -- 点击事件

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCSaleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:SaleRecordCell forIndexPath:indexPath];
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
    return 34.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
