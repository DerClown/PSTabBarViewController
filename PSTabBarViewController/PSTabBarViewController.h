//
//  PSTabBarViewController.h
//  PSTabBarViewController
//
//  Created by Dong on 15/2/26.
//  Copyright (c) 2015年 DDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSTabBarViewController : UIViewController

- (id)initWithSegmentTitles:(NSArray *)titles
            viewControllers:(NSArray *)viewControllers
                  pageIndex:(NSInteger)pageIndex;

@property (nonatomic, copy) UIColor *sliderViewTiniColor;

@end
