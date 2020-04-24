//
//  FCGoodsJointShowVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/24.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCGoodsJointShowVC.h"
#import "FCGoodsJointHeader.h"
#import "FCGoodsJointCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "FCSubmitPicCell.h"

static NSString *const GoodsJointCell = @"GoodsJointCell";
static NSString *const SubmitPicCell = @"SubmitPicCell";

@interface FCGoodsJointShowVC ()< UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dianQiTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dianQiTableHeight;

@property (weak, nonatomic) IBOutlet UITableView *jiaJuTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiaJuTableHeight;

@property (weak, nonatomic) IBOutlet UITableView *qiTaTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qiTaTableHeight;

@property (weak, nonatomic) IBOutlet UITableView *jiChuTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiChuTableHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *shuiDianCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shuiDianCollectionHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *houseCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseCollectionHeight;

@property (weak, nonatomic) IBOutlet UILabel *remark;

@end

@implementation FCGoodsJointShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"房屋交割单"];
    [self setUpTableView];
    [self setUpCollectionView];
}
#pragma mark -- 懒加载

#pragma mark -- 视图
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.dianQiTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dianQiTableView.rowHeight = 0;//预估高度
    self.dianQiTableView.estimatedSectionHeaderHeight = 0;
    self.dianQiTableView.estimatedSectionFooterHeight = 0;
    
    self.dianQiTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dianQiTableView.dataSource = self;
    self.dianQiTableView.delegate = self;
    
    self.dianQiTableView.showsVerticalScrollIndicator = NO;
    
    self.dianQiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.dianQiTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCGoodsJointCell class]) bundle:nil] forCellReuseIdentifier:GoodsJointCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.jiaJuTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.jiaJuTableView.rowHeight = 0;//预估高度
    self.jiaJuTableView.estimatedSectionHeaderHeight = 0;
    self.jiaJuTableView.estimatedSectionFooterHeight = 0;
    
    self.jiaJuTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.jiaJuTableView.dataSource = self;
    self.jiaJuTableView.delegate = self;
    
    self.jiaJuTableView.showsVerticalScrollIndicator = NO;
    
    self.jiaJuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.jiaJuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCGoodsJointCell class]) bundle:nil] forCellReuseIdentifier:GoodsJointCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.qiTaTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.qiTaTableView.rowHeight = 0;//预估高度
    self.qiTaTableView.estimatedSectionHeaderHeight = 0;
    self.qiTaTableView.estimatedSectionFooterHeight = 0;
    
    self.qiTaTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.qiTaTableView.dataSource = self;
    self.qiTaTableView.delegate = self;
    
    self.qiTaTableView.showsVerticalScrollIndicator = NO;
    
    self.qiTaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.qiTaTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCGoodsJointCell class]) bundle:nil] forCellReuseIdentifier:GoodsJointCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.jiChuTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.jiChuTableView.rowHeight = 0;//预估高度
    self.jiChuTableView.estimatedSectionHeaderHeight = 0;
    self.jiChuTableView.estimatedSectionFooterHeight = 0;
    
    self.jiChuTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.jiChuTableView.dataSource = self;
    self.jiChuTableView.delegate = self;
    
    self.jiChuTableView.showsVerticalScrollIndicator = NO;
    
    self.jiChuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.jiChuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FCGoodsJointCell class]) bundle:nil] forCellReuseIdentifier:GoodsJointCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.dianQiTableHeight.constant = weakSelf.dianQiTableView.contentSize.height;
        weakSelf.jiaJuTableHeight.constant = weakSelf.jiaJuTableView.contentSize.height;
        weakSelf.qiTaTableHeight.constant = weakSelf.qiTaTableView.contentSize.height;
        weakSelf.jiChuTableHeight.constant = weakSelf.jiChuTableView.contentSize.height;
    });
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.shuiDianCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.shuiDianCollectionView.collectionViewLayout = flowLayout;
    self.shuiDianCollectionView.dataSource = self;
    self.shuiDianCollectionView.delegate = self;
    
    [self.shuiDianCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.houseCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout1 = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout1.delegate = self;
    flowLayout1.canDrag = NO;
    flowLayout1.header_suspension = NO;
    self.houseCollectionView.collectionViewLayout = flowLayout1;
    self.houseCollectionView.dataSource = self;
    self.houseCollectionView.delegate = self;
    
    [self.houseCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.shuiDianCollectionHeight.constant = weakSelf.shuiDianCollectionView.contentSize.height;
        weakSelf.houseCollectionHeight.constant = weakSelf.houseCollectionView.contentSize.height;
    });
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.dianQiTableView) {
        return 2;
    }else if (tableView == self.jiaJuTableView) {
        return 3;
    }else if (tableView == self.qiTaTableView) {
        return 3;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCGoodsJointCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodsJointCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.jiChuView.hidden = YES;
    cell.dianQiView.hidden = YES;
    if (tableView == self.jiChuTableView) {
        cell.jiChuShowView.hidden = NO;
        cell.dianQiShowView.hidden = YES;
    }else{
        cell.jiChuShowView.hidden = YES;
        cell.dianQiShowView.hidden = NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FCGoodsJointHeader *header = [FCGoodsJointHeader loadXibView];
    header.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 30.f);
    header.jiChuView.hidden = YES;
    header.dianQiView.hidden = YES;
    if (tableView == self.jiChuTableView) {
        header.jiChuShowView.hidden = NO;
        header.dianQiShowView.hidden = YES;
    }else{
        header.jiChuShowView.hidden = YES;
        header.dianQiShowView.hidden = NO;
    }
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{\
    if (collectionView == self.shuiDianCollectionView) {
        return 4;
    }else{
        return 4;
    }
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FCSubmitPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SubmitPicCell forIndexPath:indexPath];
    if (collectionView == self.shuiDianCollectionView) {
        cell.picContent.image = HXGetImage(@"上传");
    }else{
        cell.picContent.image = HXGetImage(@"上传");
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-12*2.f - 10.f)/2.0;
    CGFloat height = width*3/4.0;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(12, 12, 12, 12);
}

@end
