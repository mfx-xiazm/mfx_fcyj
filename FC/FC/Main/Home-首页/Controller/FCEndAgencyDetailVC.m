//
//  FCEndAgencyDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCEndAgencyDetailVC.h"
#import "FCSubmitPicCell.h"
#import <ZLCollectionViewVerticalLayout.h>

static NSString *const SubmitPicCell = @"SubmitPicCell";
@interface FCEndAgencyDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *xieYiCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xieYiViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *wuYeCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wuYeViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *daKuanCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *daKuanViewHeight;

@end

@implementation FCEndAgencyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavBar];
    [self setUpCollectionView];
}
#pragma mark -- 视图
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"业主委托终止"];

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(approveClicked) nomalImage:HXGetImage(@"审批") higeLightedImage:HXGetImage(@"审批") imageEdgeInsets:UIEdgeInsetsZero];
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.xieYiCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.xieYiCollectionView.collectionViewLayout = flowLayout;
    self.xieYiCollectionView.dataSource = self;
    self.xieYiCollectionView.delegate = self;
    
    [self.xieYiCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.wuYeCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout1 = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout1.delegate = self;
    flowLayout1.canDrag = NO;
    flowLayout1.header_suspension = NO;
    self.wuYeCollectionView.collectionViewLayout = flowLayout1;
    self.wuYeCollectionView.dataSource = self;
    self.wuYeCollectionView.delegate = self;
    
    [self.wuYeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.daKuanCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout2 = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout2.delegate = self;
    flowLayout2.canDrag = NO;
    flowLayout2.header_suspension = NO;
    self.daKuanCollectionView.collectionViewLayout = flowLayout2;
    self.daKuanCollectionView.dataSource = self;
    self.daKuanCollectionView.delegate = self;
    
    [self.daKuanCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSubmitPicCell class]) bundle:nil] forCellWithReuseIdentifier:SubmitPicCell];
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.xieYiViewHeight.constant = strongSelf.xieYiCollectionView.contentSize.height;
        strongSelf.wuYeViewHeight.constant = strongSelf.wuYeCollectionView.contentSize.height;
        strongSelf.daKuanViewHeight.constant = strongSelf.daKuanCollectionView.contentSize.height;
    });
}
#pragma mark -- 点击事件
-(void)approveClicked
{
    HXLog(@"审批详情");
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;;
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
