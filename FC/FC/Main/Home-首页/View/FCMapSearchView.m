//
//  FCMapSearchView.m
//  FC
//
//  Created by huaxin-01 on 2020/4/26.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCMapSearchView.h"
#import "FCMapSearchCell.h"

static NSString *const MapSearchCell = @"MapSearchCell";
@interface FCMapSearchView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation FCMapSearchView

-(void)awakeFromNib
{
    [super awakeFromNib];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCMapSearchCell class]) bundle:nil] forCellReuseIdentifier:MapSearchCell];
}
- (IBAction)clearClicked:(UIButton *)sender {
    
}
- (IBAction)cancelClicked:(UIButton *)sender {
    if (self.searchClickedCall) {
        self.searchClickedCall(0,nil);
    }
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCMapSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:MapSearchCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
