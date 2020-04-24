//
//  FCHouseRenterDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCHouseRenterDetailVC.h"
#import "FCUrgencyContactCell.h"
#import "FCAddVisitVC.h"
#import "FCPriceRuleShowView.h"
#import <zhPopupController.h>

static NSString *const UrgencyContactCell = @"UrgencyContactCell";
@interface FCHouseRenterDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jinjiViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *houseTitle;
/** 是否滑动 */
@property(nonatomic,assign)BOOL isCanScroll;
@end

@implementation FCHouseRenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.houseTitle addFlagLabelWithName:@"二次出租" lineSpace:5.f titleString:@"三湘花园5栋1单元1002" withFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60.f, 0);
    self.scrollView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"childScrollCan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(childScrollHandle:) name:@"MainTableScroll" object:nil];
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCUrgencyContactCell class]) bundle:nil] forCellReuseIdentifier:UrgencyContactCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.jinjiViewHeight.constant = strongSelf.tableView.contentSize.height + 44.f;
    });
}
#pragma mark -- 点击事件
- (IBAction)addVisitClicked:(UIButton *)sender {
    FCAddVisitVC *vvc = [FCAddVisitVC new];
    [self.navigationController pushViewController:vvc animated:YES];
}
- (IBAction)priceRuleClicked:(UIButton *)sender {
    FCPriceRuleShowView *show = [FCPriceRuleShowView loadXibView];
    show.hxn_size = CGSizeMake(HX_SCREEN_WIDTH - 15.f*2, 40.f*3 + 120.f);
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:show size:show.hxn_size];
    popupController.layoutType = zhPopupLayoutTypeCenter;
    popupController.dismissOnMaskTouched = YES;
    [popupController show];
}

#pragma mark -- 通知处理
-(void)childScrollHandle:(NSNotification *)user{
    if ([user.name isEqualToString:@"childScrollCan"]){
        self.isCanScroll = YES;
    }else if ([user.name isEqualToString:@"MainTableScroll"]){
        self.isCanScroll = NO;
        [self.scrollView setContentOffset:CGPointZero];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.isCanScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (scrollView.contentOffset.y<=0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MainTableScroll" object:nil];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
