//
//  FCUnlockDetailVC.m
//  FC
//
//  Created by huaxin-01 on 2020/4/23.
//  Copyright © 2020 huaxin-01. All rights reserved.
//

#import "FCUnlockDetailVC.h"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "FCBannerCell.h"
#import <WebKit/WebKit.h>
#import "FCAppointSerVC.h"

@interface FCUnlockDetailVC ()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
/* 轮播图 */
@property (weak, nonatomic) IBOutlet TYCyclePagerView *cycleView;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;
@property (weak, nonatomic) IBOutlet UIView *webContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webContentViewHeight;
@property (nonatomic, strong) WKWebView  *webView;
@end

@implementation FCUnlockDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"开锁服务详情"];
    [self setUpCycleView];
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.webContentView addSubview:self.webView];
    NSString *h5 = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{width:100%%; height:auto;}body{margin:10px 10px;}</style></head><body>%@</body></html>",@"<p><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/a1465e13-3a64-4de6-91b5-f6a483d1db14.jpg\" alt=\"\" width=\"791\" height=\"1094\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/e516bece-be3f-4971-a81b-5a10986f9896.jpg\" alt=\"\" width=\"791\" height=\"880\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/2c118432-ee7b-4510-be22-eb87c7a68b99.jpg\" alt=\"\" width=\"791\" height=\"808\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/b35af870-9712-482c-8274-dcce59c5eedd.jpg\" alt=\"\" width=\"791\" height=\"810\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/14cc79c8-067b-45ea-acc5-15fa237e827e.jpg\" alt=\"\" width=\"791\" height=\"810\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/bad35353-b856-40a9-8711-cb10689c56a5.jpg\" alt=\"\" width=\"791\" height=\"806\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/106a4fcf-88a0-4fca-a07e-7a3ce32c8c1f.jpg\" alt=\"\" width=\"791\" height=\"810\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/85b2d641-4e58-42ca-81ce-24be4effa987.jpg\" alt=\"\" width=\"791\" height=\"1000\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/5f1e2a58-7bff-4358-a974-5d5b3274aded.jpg\" alt=\"\" width=\"791\" height=\"446\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/2120587f-c901-499d-8b9e-b5cc3f5718fc.jpg\" alt=\"\" width=\"791\" height=\"460\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/5b0b238c-0c60-414c-9fa5-2249ac2a4427.jpg\" alt=\"\" width=\"791\" height=\"1002\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/222b901f-46e8-4d71-9a5f-4bf08c7c648f.jpg\" alt=\"\" width=\"791\" height=\"572\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/99804f2f-acbd-4e3a-8e19-7b2ff0fa2998.jpg\" alt=\"\" width=\"791\" height=\"566\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/db5dcd55-4a47-4913-a683-39cba30bc92b.jpg\" alt=\"\" width=\"791\" height=\"1022\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/8cd2ae89-fe98-4afc-81ce-bafe3a301bcb.jpg\" alt=\"\" width=\"791\" height=\"566\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/cbee4c58-9fed-4c24-bc02-a7e36347152d.jpg\" alt=\"\" width=\"791\" height=\"566\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/ab63a330-9a7b-4635-80ef-fe2cb444cdde.jpg\" alt=\"\" width=\"791\" height=\"1004\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/e1f0d9c0-5ba0-4a37-90a7-53a3cf2faabe.jpg\" alt=\"\" width=\"791\" height=\"578\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/30c2ee55-0967-4321-b033-c0b491ed5263.jpg\" alt=\"\" width=\"791\" height=\"556\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/3f968ac3-e66f-4c65-b2b6-24c1983c67bc.jpg\" alt=\"\" width=\"791\" height=\"1002\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/298e8aae-42ca-4cc8-9ae5-4c91a3272fcc.jpg\" alt=\"\" width=\"791\" height=\"576\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/376a9cb3-8060-483a-b2a6-74d17675370e.jpg\" alt=\"\" width=\"791\" height=\"560\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/bc6fb0a7-591f-4cd3-ac4c-aba14c59127f.jpg\" alt=\"\" width=\"791\" height=\"1010\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/510579c2-7987-4331-acdb-060c2978b9e1.jpg\" alt=\"\" width=\"791\" height=\"570\" /><img src=\"http://api.whaleupgo.com:8180/daishupub/upload/2020/4/13/d64defef-ed34-4480-ae61-edd8e9fe466f.jpg\" alt=\"\" width=\"791\" height=\"562\" /></p>"];
    [self.webView loadHTMLString:h5 baseURL:nil];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.webContentView.bounds;
}
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //下方代码，禁止缩放
        WKUserContentController *userController = [WKUserContentController new];
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userController addUserScript:script];
        config.userContentController = userController;
        _webView = [[WKWebView alloc] initWithFrame:self.webContentView.bounds configuration:config];
        _webView.scrollView.scrollEnabled = NO;
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}
#pragma mark -- 视图
-(void)setUpCycleView
{
    [self.cycleView bringSubviewToFront:self.currentPage];
    
    self.cycleView.isInfiniteLoop = YES;
    self.cycleView.autoScrollInterval = 3.0;
    self.cycleView.dataSource = self;
    self.cycleView.delegate = self;
    // registerClass or registerNib
    [self.cycleView registerNib:[UINib nibWithNibName:NSStringFromClass([FCBannerCell class]) bundle:nil] forCellWithReuseIdentifier:@"BannerCell"];

    [self.cycleView reloadData];
}

#pragma mark -- 点击事件
- (IBAction)apointClicked:(UIButton *)sender {
    FCAppointSerVC *avc = [FCAppointSerVC new];
    [self.navigationController pushViewController:avc animated:YES];
}
#pragma mark -- TYCyclePagerView代理
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FCBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"BannerCell" forIndex:index];
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 0.f;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.currentPage.text = [NSString stringWithFormat:@"%zd/3",toIndex+1];
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
#pragma mark -- 事件监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.webView.hxn_height = self.webView.scrollView.contentSize.height;
        self.webContentViewHeight.constant = self.webView.scrollView.contentSize.height;
    }
}
-(void)dealloc
{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
@end
