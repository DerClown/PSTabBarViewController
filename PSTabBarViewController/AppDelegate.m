//
//  AppDelegate.m
//  PSTabBarViewController
//
//  Created by User on 15/2/26.
//  Copyright (c) 2015年 DDong. All rights reserved.
//

#import "AppDelegate.h"

#import "PSTabBarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;
    
    UIViewController *demo = [[UIViewController alloc]init];
    UIViewController *demo2 = [[UIViewController alloc]init];
    UIViewController *demo3 = [[UIViewController alloc]init];
    UIViewController *demo4 = [[UIViewController alloc]init];
    UIViewController *demo5 = [[UIViewController alloc]init];
    UIViewController *demo6 = [[UIViewController alloc]init];
    UIViewController *demo7 = [[UIViewController alloc]init];
    demo.view.backgroundColor = [UIColor redColor];
    demo2.view.backgroundColor = [UIColor magentaColor];
    demo3.view.backgroundColor = [UIColor grayColor];
    demo4.view.backgroundColor = [UIColor orangeColor];
    demo5.view.backgroundColor = [UIColor cyanColor];
    demo6.view.backgroundColor = [UIColor purpleColor];
    demo7.view.backgroundColor = [UIColor orangeColor];

    
    PSTabBarViewController *viewController = [[PSTabBarViewController alloc] initWithSegmentTitles:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"] viewControllers:@[demo,demo2,demo3 ,demo4, demo5, demo6, demo7] pageIndex:1];
    viewController.title = @"PSTabBarViewController";
    viewController.view.frame = CGRectMake(0, 200, self.window.frame.size.width, self.window.frame.size.height - 200);
    
    UIViewController *newCtrl = [[UIViewController alloc] init];
    [newCtrl addChildViewController:viewController];
    [newCtrl.view addSubview:viewController.view];
    newCtrl.view.backgroundColor = [UIColor brownColor];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newCtrl];
    
    self.window.rootViewController = navigationController;
    
    [_window makeKeyAndVisible];
    return YES;
}

@end
