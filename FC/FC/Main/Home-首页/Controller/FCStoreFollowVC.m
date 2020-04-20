//
//  FCStoreFollowVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCStoreFollowVC.h"
#import "FCAddFollowVC.h"
#import "FCHouseFollowCell.h"
#import "FCHouseFollow.h"
#import "FCHouseFollowLayout.h"

@interface FCStoreFollowVC ()<UITableViewDelegate,UITableViewDataSource,FCHouseFollowCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 布局数组 */
@property (nonatomic,strong) NSMutableArray *layoutsArr;

@end

@implementation FCStoreFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpTableView];
}
#pragma mark -- 懒加载
-(NSMutableArray *)layoutsArr
{
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment2" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            FCHouseFollow *model = [FCHouseFollow yy_modelWithDictionary:dict];
            FCHouseFollowLayout *layout = [[FCHouseFollowLayout alloc] initWithModel:model];
            [_layoutsArr addObject:layout];
        }
    }
    return _layoutsArr;
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"跟进记录"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(addClicked) nomalImage:HXGetImage(@"房源添加") higeLightedImage:HXGetImage(@"房源添加") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = HXGlobalBg;
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark -- 点击事件
-(void)addClicked
{
    FCAddFollowVC *avc = [FCAddFollowVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCHouseFollowLayout *layout = self.layoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCHouseFollowCell * cell = [FCHouseFollowCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FCHouseFollowLayout *layout = self.layoutsArr[indexPath.row];
    cell.followLayout = layout;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark --  FCHouseFollowCell代理
-(void)didClickExpandInCell:(FCHouseFollowCell *)Cell
{
    FCHouseFollowLayout *layout = Cell.followLayout;
    layout.follow.isOpening = !layout.follow.isOpening;
    
    [layout resetLayout];
    [self.tableView reloadData];
}
@end
