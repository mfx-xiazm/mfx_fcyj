//
//  FCSearchVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/15.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCSearchVC.h"
#import "FCSearchTagCell.h"
#import "FCSearchTagHeader.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "HXSearchBar.h"
#import "FCSearchResultVC.h"

#define KFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"kSearchHistory.plist"]
static NSString *const SearchTagCell = @"SearchTagCell";
static NSString *const SearchTagHeader = @"SearchTagHeader";
@interface FCSearchVC ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 搜索历史 */
@property (nonatomic,strong) NSMutableArray *historys;

@end

@implementation FCSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    [self setUpCollectionView];
    [self readHistorySearch];
}
-(NSMutableArray *)historys
{
    if (_historys == nil) {
        _historys = [NSMutableArray array];
    }
    return _historys;
}
#pragma mark -- 视图相关
-(void)setUpNavBar
{
    [self.navigationItem setTitle:nil];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancelClicked) title:@"取消" font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium ] titleColor:[UIColor colorWithHexString:@"#1A1A1A"] highlightedColor:[UIColor colorWithHexString:@"#1A1A1A"] titleEdgeInsets:UIEdgeInsetsZero];
    
    HXSearchBar *search = [HXSearchBar searchBar];
    search.backgroundColor = HXGlobalBg;
    search.frame = CGRectMake(50.f, 7.f, HX_SCREEN_WIDTH-50.f*2, 30.f);
    search.layer.cornerRadius = 15.f;
    search.layer.masksToBounds = YES;
    search.placeholder = @"请输入小区、商圈、地铁";
    search.searchIcon = @"地图搜索";
    search.delegate = self;
    [self.navigationItem setTitleView:search];
}
-(void)setUpCollectionView
{
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSearchTagCell class]) bundle:nil] forCellWithReuseIdentifier:SearchTagCell];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FCSearchTagHeader class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader];

}
#pragma mark -- UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField hasText]) {
        [MBProgressHUD showOnlyTextToView:self.view title:@"请输入关键字"];
        return NO;
    }
    [textField resignFirstResponder];//放弃响应
    [self checkHistoryData:textField.text];
    // 发起搜索
    
    return YES;
}
#pragma mark -- 业务逻辑
-(void)cancelClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)readHistorySearch
{
    // 判断是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:KFilePath] == NO) {
        HXLog(@"不存在");
        // 一、使用NSMutableArray来接收plist里面的文件
        //        plistArr = [[NSMutableArray alloc] init];
    } else {
        HXLog(@"存在");
        // 使用NSArray来接收plist里面的文件，获取里面的数据
        NSArray *arr = [NSArray arrayWithContentsOfFile:KFilePath];
        if (arr.count != 0) {
            [self.historys addObjectsFromArray:arr];
        } else {
            HXLog(@"plist文件为空");
        }
    }
    [self.collectionView reloadData];
}
-(void)writeHistorySearch
{
    [self.historys writeToFile:KFilePath atomically:YES];
}
-(void)checkHistoryData:(NSString *)history
{
    if (![self.historys containsObject:history]) {//如果历史数据不包含就加
        [self.historys insertObject:history atIndex:0];
    }else{//如果历史数据包含就更新
        [self.historys removeObject:history];
        [self.historys insertObject:history atIndex:0];
    }
//    if (self.historys.count > 6) {
//        [self.historys removeLastObject];
//    }
    [self writeHistorySearch];//写入
    
    [self.collectionView reloadData];//刷新页面
    
//    GXSearchResultVC *rvc = [GXSearchResultVC new];
//    rvc.keyword = history;
//    [self.navigationController pushViewController:rvc animated:YES];
}
-(void)clearClicked
{
    [self.historys removeAllObjects];
    [self writeHistorySearch];//写入
    [self.collectionView reloadData];
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.historys.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return LabelLayout;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FCSearchTagCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchTagCell forIndexPath:indexPath];
    cell.contentText.text = self.historys[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self checkHistoryData:self.historys[indexPath.item]];
    FCSearchResultVC *hvc = [FCSearchResultVC new];
    [self.navigationController pushViewController:hvc animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString : UICollectionElementKindSectionHeader]){
        FCSearchTagHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SearchTagHeader forIndexPath:indexPath];
        hx_weakify(self);
        headerView.clearHistoryCall = ^{
            hx_strongify(weakSelf);
            [strongSelf clearClicked];
        };
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 44);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.historys[indexPath.item] boundingRectWithSize:CGSizeMake(1000000, 34) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size.width + 30, 34);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 12, 5, 12);
}

@end
