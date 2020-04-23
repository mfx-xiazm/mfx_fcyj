//
//  FCHotelCommentVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHotelCommentVC.h"
#import "FCHotelCommentCell.h"
#import "FCHotelCommentLayout.h"
#import "FCHotelCommentHeader.h"

@interface FCHotelCommentVC ()<UITableViewDelegate,UITableViewDataSource,FCHotelCommentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 评论布局数组 */
@property (nonatomic,strong) NSMutableArray *commentLayoutsArr;
@end

@implementation FCHotelCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"全部评论"];
    [self setUpTableView];
}
-(NSMutableArray *)commentLayoutsArr
{
    if (!_commentLayoutsArr) {
        _commentLayoutsArr = [NSMutableArray array];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"moment2" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in dataArray) {
            FCHotelComment *model = [FCHotelComment yy_modelWithDictionary:dict];
            FCHotelCommentLayout *layout = [[FCHotelCommentLayout alloc] initWithModel:model];
            [_commentLayoutsArr addObject:layout];
        }
    }
    return _commentLayoutsArr;
}
- (void)setUpTableView
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
    
    self.tableView.showsVerticalScrollIndicator = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark -- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentLayoutsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCHotelCommentLayout *layout = self.commentLayoutsArr[indexPath.row];
    return layout.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCHotelCommentCell * cell = [FCHotelCommentCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FCHotelCommentLayout *layout = self.commentLayoutsArr[indexPath.row];
    cell.commentLayout = layout;
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FCHotelCommentHeader *header = [FCHotelCommentHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
    hx_weakify(self);
    header.lookMoreCall = ^{
        hx_strongify(weakSelf);
        FCHotelCommentVC *cvc = [FCHotelCommentVC new];
        [strongSelf.navigationController pushViewController:cvc animated:YES];
    };
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
