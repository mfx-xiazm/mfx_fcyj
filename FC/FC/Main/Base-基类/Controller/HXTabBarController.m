//
//  HXTabBarController.m
//  HX
//
//  Created by hxrc on 17/3/2.
//  Copyright © 2017年 HX. All rights reserved.
//

#import "HXTabBarController.h"
#import "UIImage+HXNExtension.h"
#import "HXNavigationController.h"
#import "FCHomeVC.h"
#import "FCContactVC.h"
#import "FCApproveVC.h"
#import "FCMyVC.h"

@interface HXTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HXTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    attrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x999999);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = HXControlBg;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [self setupChildVc:[[FCHomeVC alloc] init] title:@"首页" image:@"首页灰" selectedImage:@"首页选中"];
    [self setupChildVc:[[FCContactVC alloc] init] title:@"通讯录" image:@"通讯录灰" selectedImage:@"通讯录"];
    [self setupChildVc:[[FCApproveVC alloc] init] title:@"审批" image:@"审批灰" selectedImage:@"审批选中"];
    [self setupChildVc:[[FCMyVC alloc] init] title:@"我的" image:@"我的灰" selectedImage:@"我的"];
    
    self.delegate = self;
    
    // 设置透明度和背景颜色
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    self.tabBar.translucent = NO;//这句表示取消tabBar的透明效果。
    [self.tabBar setShadowImage:[UIImage imageWithColor:UIColorFromRGB(0xEEEEEE) size:CGSizeMake(HX_SCREEN_WIDTH, 1)]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
//    if (@available(iOS 13.0, *)) {
//        UITabBarAppearance *appearance = [UITabBarAppearance new];
//        appearance.shadowColor = UIColorFromRGB(0xEEEEEE);
//        appearance.backgroundColor = [UIColor whiteColor];
                        
//        UITabBarItemStateAppearance *normalAppearance = appearance.stackedLayoutAppearance.normal;
//        normalAppearance.titleTextAttributes = attrs;
//
//        UITabBarItemStateAppearance *selectedAppearance = appearance.stackedLayoutAppearance.selected;
//        selectedAppearance.titleTextAttributes = selectedAttrs;
        
//        self.tabBar.standardAppearance = appearance;
//    }else{
//        UITabBarItem *item = [UITabBarItem appearance];
//        [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
//        [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        
//        [self.tabBar setShadowImage:[UIImage imageWithColor:UIColorFromRGB(0xEEEEEE) size:CGSizeMake(HX_SCREEN_WIDTH, 1)]];
//        [self.tabBar setBackgroundImage:[UIImage new]];
//    }
    
}
/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 包装一个自定义的导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}
#pragma mark -- ————— UITabBarController 代理 —————
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    if ([viewController.tabBarItem.title isEqualToString:@"购物车"] || [viewController.tabBarItem.title isEqualToString:@"我的"]){
//        if (![MSUserManager sharedInstance].isLogined){// 未登录
//            DSLoginVC *lvc = [DSLoginVC new];
//            HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:lvc];
//            if (@available(iOS 13.0, *)) {
//                nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                /*当该属性为 false 时，用户下拉可以 dismiss 控制器，为 true 时，下拉不可以 dismiss控制器*/
//                nav.modalInPresentation = YES;
//                
//            }
//            [tabBarController.selectedViewController presentViewController:nav animated:YES completion:nil];
//            return NO;
//        }else{ // 如果已登录
//            return YES;
//        }
//    }else{
//        return YES;
//    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
