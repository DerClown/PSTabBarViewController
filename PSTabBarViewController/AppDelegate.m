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
    
    [self onCheckVersion];
    
    [_window makeKeyAndVisible];
    return YES;
}

- (void)onCheckVersion {
    NSString *URL = @"http://itunes.apple.com/lookup?id=你的应用程序的ID";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    /*SBJSON *json = [[SBJSON alloc] init];
    NSDictionary *dic = [json objectWithString:results error:nil];*/
    NSDictionary *dic;
    NSAssert(dic, @"Should be parser post result to dic.");
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:systemVersion()]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
    }
}

NSString *systemVersion() {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return currentVersion;
}

@end
