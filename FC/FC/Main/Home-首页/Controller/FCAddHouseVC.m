//
//  FCAddHouseVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/20.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCAddHouseVC.h"
#import <ZLPhotoActionSheet.h>
#import <AFNetworking.h>
#import "HXPlaceholderTextView.h"
#import "FCSubmitPicCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "ZJPickerView.h"
#import "FCChooseHouseVC.h"

static NSString *const SubmitPicCell = @"SubmitPicCell";
@interface FCAddHouseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *remark;

/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedAssets;
/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
/** 是否原图 */
@property (nonatomic, assign) BOOL isOriginal;
/** 是否选择了9张 */
@property (nonatomic, assign) BOOL isSelect9;
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *showHousePics;

@end

@implementation FCAddHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"录入房源"];
    self.remark.placeholder = @"请输入备注";
    [self setUpCollectionView];
}
-(NSMutableArray *)showHousePics
{
    if (_showHousePics == nil) {
        _showHousePics = [NSMutableArray array];
        [_showHousePics addObject:HXGetImage(@"上传房间图片")];
    }
    return _showHousePics;
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
    actionSheet.configuration.maxSelectCount = 9;
    
    // -- required
    /**
     必要参数！required！ 如果调用的方法没有传sender，则该属性必须提前赋值
     */
    actionSheet.sender = self;
    /**
     已选择的图片数组
     */
    actionSheet.arrSelectedAssets = self.selectedAssets;
    /**
     选择照片回调，回调解析好的图片、对应的asset对象、是否原图
     pod 2.2.6版本之后 统一通过selectImageBlock回调
     */
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        [self.showHousePics removeAllObjects];
        [self.showHousePics addObjectsFromArray:images];
        if (self.showHousePics.count != 9) {
            [self.showHousePics addObject:HXGetImage(@"上传房间图片")];
            self.isSelect9 = NO;
        }else{
            self.isSelect9 = YES;
        }
        
        self.selectedAssets = assets.mutableCopy;
        self.isOriginal = isOriginal;
        self.selectedPhotos = images.mutableCopy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.collectionViewHeight.constant = self.collectionView.contentSize.height;
            });
        });
    }];
    return actionSheet;
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
    
    hx_weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hx_strongify(weakSelf);
        strongSelf.collectionViewHeight.constant = strongSelf.collectionView.contentSize.height;
    });
}
#pragma mark -- 点击事件

- (IBAction)addHouseTypeClicked:(UIButton *)sender {
    NSArray *showData = nil;
    if(sender.tag == 5){
        // 小区
        FCChooseHouseVC *cvc = [FCChooseHouseVC new];
        [self.navigationController pushViewController:cvc animated:YES];
    }else{
        if (sender.tag == 1) {
            showData = @[@{@"店铺1":@[@"光谷分组1",@"光谷分组2",@"光谷分组3",@"光谷分组4"]},@{@"店铺2":@[@"中南分组1",@"中南分组2",@"中南分组3",@"中南分组4"]}];
        }else if(sender.tag == 2){
            showData = @[@"58同城",@"闲鱼",@"网上联系",@"中介介绍"];
        }else if(sender.tag == 3){
            showData = @[@"男",@"女"];
        }else if(sender.tag == 4){
            // 省市区
            showData =@[@{@"省1":@[@{@"市1":@[@"区1",@"区2",@"区3"]},@{@"市2":@[@"区1",@"区2",@"区3"]},@{@"市3":@[@"区1",@"区2",@"区3"]},@{@"市4":@[@"区1",@"区2",@"区3"]}]},@{@"省2":@[@{@"市1":@[@"区1",@"区2",@"区3"]},@{@"市2":@[@"区1",@"区2",@"区3"]},@{@"市3":@[@"区1",@"区2",@"区3"]},@{@"市4":@[@"区1",@"区2",@"区3"]}]},@{@"省3":@[@{@"市1":@[@"区1",@"区2",@"区3"]},@{@"市2":@[@"区1",@"区2",@"区3"]},@{@"市3":@[@"区1",@"区2",@"区3"]},@{@"市4":@[@"区1",@"区2",@"区3"]}]}];
        }else if(sender.tag == 6){
             showData = @[@"栋",@"幢",@"胡同"];
        }else if(sender.tag == 7){
            showData = @[@"单元",@"大单元",@"小单元"];
        }else if(sender.tag == 8){
            showData = @[@"毛胚房",@"简装房",@"改装房",@"精装房"];
        }else if(sender.tag == 9){
            showData = @[@"月付",@"季付",@"半年付",@"年付"];
        }else if(sender.tag == 10){
            showData = @[@"是",@"否"];
        }else if(sender.tag == 11){
            showData = @[@"方正",@"客厅异性",@"厨房异性",@"卧室异性"];
        }else if(sender.tag == 12){
            showData = @[@"通透",@"整体采光不好",@"客厅采光不好",@"主卧采光不好"];
        }else if(sender.tag == 13){
            showData = @[@"安静",@"噪音大",@"临街",@"临闹市"];
        }else if(sender.tag == 14){
            showData = @[@"好",@"一般",@"无小区情况"];
        }else if(sender.tag == 15){
            showData = @[@"步行5分钟",@"步行10分钟",@"步行30分钟",@"步行50分钟"];
        }else if(sender.tag == 16){
            showData = @[@"步行5分钟",@"步行10分钟",@"步行30分钟",@"步行50分钟"];
        }else if(sender.tag == 17){
            showData = @[@"商业核心",@"学校周边",@"旅游周边",@"较偏区域"];
        }else if(sender.tag == 18){
            showData = @[@"不限",@"居家",@"上班族",@"娱乐行业"];
        }
        // 1.Custom propery（自定义属性）
        NSDictionary *propertyDict = @{
            ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
            ZJPickerViewPropertySureBtnTitleKey  : @"确定",
            //ZJPickerViewPropertyTipLabelTextKey  : (textKey&&textKey.length)?textKey:@"选择贷款年限", // 提示内容
            ZJPickerViewPropertyTipLabelTextKey  :@"提示语", // 提示内容
            ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0x999999),
            ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x845D32),
            ZJPickerViewPropertyTipLabelTextColorKey :
                UIColorFromRGB(0x131D2D),
            ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
            ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
            ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:13.0f],
            ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:13.0f],
            ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
            ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
            ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x845D32), NSFontAttributeName : [UIFont systemFontOfSize:13.0f]},
            ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x999999), NSFontAttributeName : [UIFont systemFontOfSize:13.0f]},
            ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xF2F2F2),
            ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
            ZJPickerViewPropertyIsShowSelectContentKey : @YES,
            ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
            ZJPickerViewPropertyIsAnimationShowKey : @YES};
        
        // 2.Show（显示）
        //    hx_weakify(self);
        [ZJPickerView zj_showWithDataList:showData propertyDict:propertyDict completion:^(NSString *selectContent) {
            //        hx_strongify(weakSelf);
            // show select content|
            //        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
            //
            //        NSArray *years = [results.firstObject componentsSeparatedByString:@","];
            //
            //        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
            //
            //        years.firstObject rows.firstObject
        }];
    }
}
/*
 - (NSMutableArray *)getCityData
 {
     NSMutableArray *areaDataArray = [NSMutableArray array];
     NSString *path = [[NSBundle mainBundle] pathForResource:@"CityData3" ofType:@"txt"];
     NSString *areaString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
     if (areaString && ![areaString isEqualToString:@""]) {
         NSError *error = nil;
         NSArray *areaStringArray = [NSJSONSerialization JSONObjectWithData:[areaString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
         if (areaStringArray && areaStringArray.count) {
             [areaStringArray enumerateObjectsUsingBlock:^(NSDictionary *currentProviceDict, NSUInteger idx, BOOL * _Nonnull stop) {
                 NSMutableDictionary *proviceDict = [NSMutableDictionary dictionary];
                 NSString *proviceName = currentProviceDict[@"name"];
                 NSArray *cityArray = currentProviceDict[@"childs"];
                 
                 NSMutableArray *tempCityArray = [NSMutableArray arrayWithCapacity:cityArray.count];
                 [cityArray enumerateObjectsUsingBlock:^(NSDictionary *currentCityDict, NSUInteger idx, BOOL * _Nonnull stop) {
                     NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                     NSString *cityName = currentCityDict[@"name"];
                     NSArray *countryArray = currentCityDict[@"childs"];
                     
                     NSMutableArray *tempCountryArray = [NSMutableArray arrayWithCapacity:countryArray.count];
                     if (countryArray) {
                         [countryArray enumerateObjectsUsingBlock:^(NSDictionary *currentCountryDict, NSUInteger idx, BOOL * _Nonnull stop) {
                             [tempCountryArray addObject:currentCountryDict[@"name"]];
                         }];
                         
                         if (cityName) {
                             [cityDict setObject:tempCountryArray forKey:cityName];
                             [tempCityArray addObject:cityDict];
                         }
                     } else {
                         [tempCityArray addObject:cityName];
                     }
                 }];
                 
                 if (proviceName && cityArray) {
                     [proviceDict setObject:tempCityArray forKey:proviceName];
                     [areaDataArray addObject:proviceDict];
                 }
             }];
         } else {
             NSLog(@"解析错误");
         }
     }
     return areaDataArray;
 }
 */
//-(void)submitBtnClicked:(UIButton *)btn
//{
//    if (self.showData.count >1) {
//        hx_weakify(self);
//        if (self.isSelect4) {
//            [self runUpLoadImages:self.showData completedCall:^(NSMutableArray *result) {
//                hx_strongify(weakSelf);
//                [strongSelf submitSuggestRequest:btn imageUrls:result];
//            }];
//        }else{
//            NSMutableArray *tempImgs = [NSMutableArray arrayWithArray:self.showData];
//            [tempImgs removeLastObject];
//            [self runUpLoadImages:tempImgs completedCall:^(NSMutableArray *result) {
//                hx_strongify(weakSelf);
//                [strongSelf submitSuggestRequest:btn imageUrls:result];
//            }];
//        }
//    }else{
//        [self submitSuggestRequest:btn imageUrls:nil];
//    }
//}
//#pragma mark -- 接口
//-(void)submitSuggestRequest:(UIButton *)btn imageUrls:(NSArray *)imageUrls
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"refund_reason"] = self.refund_reason.text;//用户退款原因，长度100
//    parameters[@"oid"] = self.oid;//订单oid
//    if (imageUrls) {
//        NSMutableString *refund_imgs = [NSMutableString string];
//        [refund_imgs appendString:@"["];
//        for (NSString *imageUrl in imageUrls) {
//            if (refund_imgs.length > 1) {
//                [refund_imgs appendFormat:@",{\"content\":\"%@\"}",imageUrl];
//            }else{
//                [refund_imgs appendFormat:@"{\"content\":\"%@\"}",imageUrl];
//            }
//        }
//        [refund_imgs appendString:@"]"];
//        parameters[@"refund_imgs"] = refund_imgs;//退款原因图片
//    }else{
//        parameters[@"refund_imgs"] = @"";//退款原因图片
//    }
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"order_refund_set" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//            if (strongSelf.applyRefundActionCall) {
//                strongSelf.applyRefundActionCall();
//            }
//            [strongSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
//}
/**
 *  图片批量上传方法
 */
- (void)runUpLoadImages:(NSArray *)imageArr completedCall:(void(^)(NSMutableArray* result))completedCall{
    // 需要上传的图片数据imageArr
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (int i=0;i<imageArr.count;i++) {
        [result addObject:[NSNull null]];
    }
    // 生成一个请求组
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < imageArr.count; i++) {
        dispatch_group_enter(group);
        NSURLSessionUploadTask *uploadTask = [self uploadTaskWithImage:imageArr[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                // CBLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                //CBLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    if ([responseObject[@"status"] boolValue]){
                        // 将上传完成返回的图片链接存入数组
                        NSDictionary *dict = ((NSArray *)responseObject[@"result"]).firstObject;
                        result[i] = [NSString stringWithFormat:@"%@",dict[@"relative_url"]];
                    }else{
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
                    }
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //HXLog(@"上传完成!");
        if (completedCall) {
            completedCall(result);//将图片链接数组传入
        }
    });
}

/**
 *  生成图片批量上传的上传请求方法
 *
 *  @param image           上传的图片
 *  @param completionBlock 包装成的请求回调
 *
 *  @return 上传请求
 */

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    AFHTTPSessionManager *HTTPmanager = [AFHTTPSessionManager manager];
    //    HTTPmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSMutableURLRequest *request = [HTTPmanager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@multifileupload",HXRC_M_URL]  parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //把本地的图片转换为NSData类型的数据
        NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"filename" fileName:@"file.png" mimeType:@"image/png"];
    } error:&error];
    
    // 可在此处配置验证信息
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.showHousePics.count;
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
    cell.picContent.image = self.showHousePics[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (self.isSelect9) {
        [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
    }else{
        if (indexPath.row == self.showHousePics.count - 1) {//最后一个
            [[self getPas] showPhotoLibrary];
        }else{
            [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-12*2.f - 10.f)/2.0;
    CGFloat height = 140.f;
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
