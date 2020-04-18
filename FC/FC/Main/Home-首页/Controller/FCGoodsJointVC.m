//
//  FCGoodsJointVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/17.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCGoodsJointVC.h"
#import "FCGoodsJointHeader.h"
#import "FCGoodsJointCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "HXPlaceholderTextView.h"
#import "FCSubmitPicCell.h"
#import <ZLPhotoActionSheet.h>

static NSString *const GoodsJointCell = @"GoodsJointCell";
static NSString *const SubmitPicCell = @"SubmitPicCell";

@interface FCGoodsJointVC ()< UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate,UITableViewDelegate,UITableViewDataSource>
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

@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

/** 水电数组 */
@property (nonatomic,strong) NSMutableArray *shuiDianPicsData;
/** 水电已选择的数组 */
@property (nonatomic,strong) NSMutableArray *shuiDianSelectedAssets;
/** 水电已选择的数组 */
@property (nonatomic,strong) NSMutableArray *shuiDianSelectedPhotos;
/** 水电是否原图 */
@property (nonatomic, assign) BOOL isShuiDianOriginal;
/** 水电是否选择了4张 */
@property (nonatomic, assign) BOOL isShuiDianSSelect4;

/** 正在操作水电 */
@property (nonatomic, assign) BOOL isHandleShuiDianPic;

/** 房间数组 */
@property (nonatomic,strong) NSMutableArray *housePicsData;
/** 房间已选择的数组 */
@property (nonatomic,strong) NSMutableArray *houseSelectedAssets;
/** 房间已选择的数组 */
@property (nonatomic,strong) NSMutableArray *houseSelectedPhotos;
/** 房间是否原图 */
@property (nonatomic, assign) BOOL isHouseOriginal;
/** 房间是否选择了9张 */
@property (nonatomic, assign) BOOL isHouseSSelect9;
@end

@implementation FCGoodsJointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"房东/租客交割单"];
    self.remark.placeholder = @"交割单备注信息";
    [self setUpTableView];
    [self setUpCollectionView];
}
#pragma mark -- 懒加载
-(NSMutableArray *)shuiDianPicsData
{
    if (_shuiDianPicsData == nil) {
        _shuiDianPicsData = [NSMutableArray array];
        [_shuiDianPicsData addObject:HXGetImage(@"上传图片")];
    }
    return _shuiDianPicsData;
}
-(NSMutableArray *)housePicsData
{
    if (_housePicsData == nil) {
        _housePicsData = [NSMutableArray array];
        [_housePicsData addObject:HXGetImage(@"上传房间图片")];
    }
    return _housePicsData;
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = HXControlBg;
    actionSheet.configuration.bottomViewBgColor = HXControlBg;
    actionSheet.configuration.indexLabelBgColor = HXControlBg;
    // -- optional
    //以下参数为自定义参数，均可不设置，有默认值
    /**
     是否升序排列，预览界面不受该参数影响，默认升序 YES
     */
    actionSheet.configuration.sortAscending = NO;
    /**
     是否允许相册内部拍照 ，设置相册内部显示拍照按钮 默认YES
     */
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    /**
     是否在相册内部拍照按钮上面实时显示相机俘获的影像 默认 YES
     */
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
    /**
     是否允许滑动选择 默认 YES （预览界面不受该参数影响）
     */
    actionSheet.configuration.allowSlideSelect = YES;
    /**
     编辑图片后是否保存编辑后的图片至相册，默认YES
     */
    actionSheet.configuration.saveNewImageAfterEdit = NO;

    /**
     回调时候是否允许框架解析图片，默认YES
     如果选择了大量图片，框架一下解析大量图片会耗费一些内存，开发者此时可置为NO，拿到assets数组后自行解析，该值为NO时，回调的图片数组为nil
     */
    actionSheet.configuration.shouldAnialysisAsset = YES;

    /**
     是否允许选择照片 默认YES (为NO只能选择视频)
     */
    actionSheet.configuration.allowSelectImage = YES;
    /**
     是否允许选择视频 默认YES
     */
    actionSheet.configuration.allowSelectVideo = NO;
    /**
     是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认YES （此属性与是否允许选择照片相关联，如果可以允许选择照片那就会展示gif[前提是照片中存在gif]）
     */
    actionSheet.configuration.allowSelectGif = NO;
    /**
     是否允许编辑图片，选择一张时候才允许编辑，默认YES
     */
    actionSheet.configuration.allowEditImage = YES;
    /**
     是否允许录制视频(当useSystemCamera为YES时无效)，默认YES
     */
    actionSheet.configuration.allowRecordVideo = NO;
    /**
     设置照片最大选择数 默认10张
     */
    actionSheet.configuration.maxSelectCount = self.isHandleShuiDianPic?4:9;

    // -- required
    /**
     必要参数！required！ 如果调用的方法没有传sender，则该属性必须提前赋值
     */
    actionSheet.sender = self;
    /**
     已选择的图片数组
     */
    actionSheet.arrSelectedAssets = self.isHandleShuiDianPic?self.shuiDianSelectedAssets:self.houseSelectedAssets;
    /**
     选择照片回调，回调解析好的图片、对应的asset对象、是否原图
     pod 2.2.6版本之后 统一通过selectImageBlock回调
     */
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        if (self.isHandleShuiDianPic) {
            [self.shuiDianPicsData removeAllObjects];
            [self.shuiDianPicsData addObjectsFromArray:images];
            if (self.shuiDianPicsData.count != 4) {
                [self.shuiDianPicsData addObject:HXGetImage(@"上传图片")];
                self.isShuiDianSSelect4 = NO;
            }else{
                self.isShuiDianSSelect4 = YES;
            }

            self.shuiDianSelectedAssets = assets.mutableCopy;
            self.isShuiDianOriginal = isOriginal;
            self.shuiDianSelectedPhotos = images.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shuiDianCollectionView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.shuiDianCollectionHeight.constant = self.shuiDianCollectionView.contentSize.height;
                });
            });
        }else{
            [self.housePicsData removeAllObjects];
            [self.housePicsData addObjectsFromArray:images];
            if (self.housePicsData.count != 9) {
                [self.housePicsData addObject:HXGetImage(@"上传房间图片")];
                self.isHouseSSelect9 = NO;
            }else{
                self.isHouseSSelect9 = YES;
            }

            self.houseSelectedAssets = assets.mutableCopy;
            self.isHouseOriginal = isOriginal;
            self.houseSelectedPhotos = images.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.houseCollectionView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.houseCollectionHeight.constant = self.houseCollectionView.contentSize.height;
                });
            });
        }
    }];
    return actionSheet;
}
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
    if (tableView == self.jiChuTableView) {
        cell.jiChuView.hidden = NO;
        cell.dianQiView.hidden = YES;
    }else{
        cell.jiChuView.hidden = YES;
        cell.dianQiView.hidden = NO;
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
    if (tableView == self.jiChuTableView) {
        header.jiChuView.hidden = NO;
        header.dianQiView.hidden = YES;
    }else{
        header.jiChuView.hidden = YES;
        header.dianQiView.hidden = NO;
    }
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{\
    if (collectionView == self.shuiDianCollectionView) {
        return self.shuiDianPicsData.count;
    }else{
        return self.housePicsData.count;
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
        cell.picContent.image = self.shuiDianPicsData[indexPath.item];
    }else{
        cell.picContent.image = self.housePicsData[indexPath.item];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (collectionView == self.shuiDianCollectionView) {
        self.isHandleShuiDianPic = YES;
        if (self.isShuiDianSSelect4) {
            [[self getPas] previewSelectedPhotos:self.shuiDianSelectedPhotos assets:self.shuiDianSelectedAssets index:indexPath.row isOriginal:self.isShuiDianOriginal];
        }else{
            if (indexPath.row == self.shuiDianPicsData.count - 1) {//最后一个
                [[self getPas] showPhotoLibrary];
            }else{
                [[self getPas] previewSelectedPhotos:self.shuiDianSelectedPhotos assets:self.shuiDianSelectedAssets index:indexPath.row isOriginal:self.isShuiDianOriginal];
            }
        }
    }else{
        self.isHandleShuiDianPic = NO;
        if (self.isHouseSSelect9) {
            [[self getPas] previewSelectedPhotos:self.houseSelectedPhotos assets:self.houseSelectedAssets index:indexPath.row isOriginal:self.isHouseOriginal];
        }else{
            if (indexPath.row == self.housePicsData.count - 1) {//最后一个
                [[self getPas] showPhotoLibrary];
            }else{
                [[self getPas] previewSelectedPhotos:self.houseSelectedPhotos assets:self.houseSelectedAssets index:indexPath.row isOriginal:self.isHouseOriginal];
            }
        }
    }
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
