//
//  FCChangeMyMsgVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/22.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCChangeMyMsgVC.h"
#import "FCUrgencyContactCell.h"
#import "FCAddContactVC.h"

static NSString *const UrgencyContactCell = @"UrgencyContactCell";
@interface FCChangeMyMsgVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactViewHeight;

@end

@implementation FCChangeMyMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"完善信息"];
    [self setUpTableView];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCUrgencyContactCell class]) bundle:nil] forCellReuseIdentifier:UrgencyContactCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.contactViewHeight.constant = strongSelf.tableView.contentSize.height + 12.f*2 + 44.f;
    });
}
#pragma mark -- 点击事件
- (IBAction)addContactClicked:(UIButton *)sender {
    FCAddContactVC *avc = [FCAddContactVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCUrgencyContactCell *cell = [tableView dequeueReusableCellWithIdentifier:UrgencyContactCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contactView1.hidden = NO;
    cell.contactView2.hidden = YES;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
