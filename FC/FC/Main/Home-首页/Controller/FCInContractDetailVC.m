//
//  FCInContractDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/17.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCInContractDetailVC.h"
#import "FCFreeRuleCell.h"
#import "FCRaiseRuleCell.h"
#import "FCSignCodeVC.h"

static NSString *const FreeRuleCell = @"FreeRuleCell";
static NSString *const RaiseRuleCell = @"RaiseRuleCell";

@interface FCInContractDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *diZengTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dizengHeight;

@property (weak, nonatomic) IBOutlet UITableView *mianZuTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianZuHeight;

@end

@implementation FCInContractDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"合同详情"];
    [self setUpTableView];
}
#pragma mark -- 视图
-(void)setUpTableView
{
    self.diZengTableView.estimatedRowHeight = 0;//预估高度
    self.diZengTableView.estimatedSectionHeaderHeight = 0;
    self.diZengTableView.estimatedSectionFooterHeight = 0;
    
    self.diZengTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.diZengTableView.dataSource = self;
    self.diZengTableView.delegate = self;
    
    self.diZengTableView.showsVerticalScrollIndicator = NO;
    
    self.diZengTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.diZengTableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.diZengTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCRaiseRuleCell class]) bundle:nil] forCellReuseIdentifier:RaiseRuleCell];
    
    
    self.mianZuTableView.estimatedRowHeight = 0;//预估高度
    self.mianZuTableView.estimatedSectionHeaderHeight = 0;
    self.mianZuTableView.estimatedSectionFooterHeight = 0;
    
    self.mianZuTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.mianZuTableView.dataSource = self;
    self.mianZuTableView.delegate = self;
    
    self.mianZuTableView.showsVerticalScrollIndicator = NO;
    
    self.mianZuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.mianZuTableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.mianZuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCFreeRuleCell class]) bundle:nil] forCellReuseIdentifier:FreeRuleCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.dizengHeight.constant = 40.f*2 + weakSelf.diZengTableView.contentSize.height + 12.f;
        weakSelf.mianZuHeight.constant = 40.f*2 + 30.f + 5.f + weakSelf.mianZuTableView.contentSize.height + 12.f;
    });
}
#pragma mark -- 点击事件

- (IBAction)signCodeClicked:(UIButton *)sender {
    FCSignCodeVC *cvc = [FCSignCodeVC new];
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.diZengTableView) {
        FCRaiseRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:RaiseRuleCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgView1.hidden = NO;
        cell.bgView.hidden = YES;
        if (indexPath.row%2) {
            cell.bgView1.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        }else{
            cell.bgView1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        return cell;
    }else{
        FCFreeRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:FreeRuleCell forIndexPath:indexPath];
        //无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bgView1.hidden = NO;
        cell.bgView.hidden = YES;
        if (indexPath.row%2) {
            cell.bgView1.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        }else{
            cell.bgView1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
