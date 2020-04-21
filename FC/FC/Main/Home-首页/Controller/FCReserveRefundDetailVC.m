//
//  FCReserveRefundDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/21.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCReserveRefundDetailVC.h"
#import "FCSubmitPicCell.h"
#import <ZLCollectionViewVerticalLayout.h>

static NSString *const SubmitPicCell = @"SubmitPicCell";
@interface FCReserveRefundDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *otherCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherCllectionViewHeight;

@end

@implementation FCReserveRefundDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"定金退订"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(approveClicked) nomalImage:HXGetImage(@"审批") higeLightedImage:HXGetImage(@"审批") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.otherCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout1 = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout1.delegate = self;
    flowLayout1.canDrag = NO;
    flowLayout1.header_suspension = NO;
    self.otherCollectionView.collectionViewLayout = flowLayout1;
    self.otherCollectionView.dataSource = self;
    self.otherCollectionView.delegate = self;
    
    [self.otherCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
        strongSelf.otherCllectionViewHeight.constant = strongSelf.otherCollectionView.contentSize.height;
    });
}
#pragma mark -- 点击事件
-(void)approveClicked
{
    HXLog(@"审批详情");
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
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
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-12.f*2-10.f)/2.0;
    CGFloat height = width*0.75;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 12, 10, 12);
}

@end
