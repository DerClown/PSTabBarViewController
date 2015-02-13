//
//  PSTabBarViewController.m
//  PSTabBarViewController
//
//  Created by User on 15/2/26.
//  Copyright (c) 2015年 DDong. All rights reserved.
//

#import "PSTabBarViewController.h"

#define TOP_NAVBAR_HEIGHT    44

#define SLIDER_VIEW_HEIGHT   4
#define SLIDER_VIEW_PADDING  2

#define SLIDER_VIEW_DEFAULT_BACKGROUNDCOLOR UIColor.greenColor

@interface PSTabBarViewController()<UIPageViewControllerDataSource,
                                          UIPageViewControllerDelegate,
                                          UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageViewControllers;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIScrollView *pageScrollView;

@property (nonatomic, strong) UIView *topNavBar;
@property (nonatomic, strong) UIScrollView *navBarScrollView;
@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) float sliderViewWidth;

@end

@implementation PSTabBarViewController

- (id)initWithSegmentTitles:(NSArray *)titles
            viewControllers:(NSArray *)viewControllers
                  pageIndex:(NSInteger)pageIndex {
    if (self = [super init]) {
        self.currentPageIndex = pageIndex;
        
        self.titles = [NSArray arrayWithArray:titles];
        self.pageViewControllers = [NSArray arrayWithArray:viewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //initalization
    [self initalizationViews];
}

#pragma mark - config UI

- (void)initalizationViews {
    //UIPageViewController
    self.pageViewController.view.frame = CGRectMake(0, TOP_NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - TOP_NAVBAR_HEIGHT);
    [self synchPageScrollView];
    
    //topNavBar
    self.topNavBar.frame = CGRectMake(0, 0, self.view.frame.size.height, TOP_NAVBAR_HEIGHT);
    
    //navBarScrollView
    self.sliderViewWidth = self.pageViewControllers.count > 5 ? self.view.frame.size.width / 5 -  4: self.view.frame.size.width/self.pageViewControllers.count - 4;
    
    //navBarScrollView
    self.navBarScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, TOP_NAVBAR_HEIGHT);
    self.navBarScrollView.contentSize = CGSizeMake(self.pageViewControllers.count*(self.sliderViewWidth + 4), TOP_NAVBAR_HEIGHT);
    [self addSegmentButtonsForNavBarScrollView];
    
    //sliderView
    self.sliderView.frame = CGRectMake((self.sliderViewWidth + 4)*self.currentPageIndex + 2, TOP_NAVBAR_HEIGHT - SLIDER_VIEW_HEIGHT, self.sliderViewWidth, SLIDER_VIEW_HEIGHT);
}

- (void)synchPageScrollView {
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
            self.pageScrollView.pagingEnabled = YES;
            self.pageScrollView.bouncesZoom = NO;
        }
    }
}

- (void)addSegmentButtonsForNavBarScrollView {
    for (int i = 0; i < self.pageViewControllers.count; i ++ ) {
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        segmentBtn.backgroundColor = [UIColor clearColor];
        segmentBtn.frame = CGRectMake((self.sliderViewWidth + 4) * i, 0, self.sliderViewWidth + 4, TOP_NAVBAR_HEIGHT);
        segmentBtn.tag = i;
        segmentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [segmentBtn setTitle:self.titles[i] forState:UIControlStateNormal];
        [segmentBtn addTarget:self action:@selector(selectedPageIndeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navBarScrollView addSubview:segmentBtn];
    }
}

#pragma mark - UIPageViewController Datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger pageIndex = [self indexOfViewController:viewController];
    
    if (pageIndex == NSNotFound || pageIndex == 0) {
        return nil;
    }
    
    pageIndex --;
    
    return self.pageViewControllers[pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger pageIndex = [self indexOfViewController:viewController];
    
    if (pageIndex == NSNotFound) {
        return nil;
    }
    
    pageIndex ++;
    
    if (pageIndex == self.pageViewControllers.count) {
        return nil;
    }
    
    return self.pageViewControllers[pageIndex];
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageViewControllers indexOfObject:viewController];
    
    if (index != NSNotFound) {
        return index;
    }
    
    return NSNotFound;
}

#pragma mark - UIPageViewController Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [self indexOfViewController:[[pageViewController viewControllers] lastObject]];
        
        //setup navbarScrollView contentOffset.y
        [self setupNavBarScrollViewContentOffsetYByPageIndex:self.currentPageIndex];
    }
}

- (void)setupNavBarScrollViewContentOffsetYByPageIndex:(NSInteger)pageIndex {
    if (self.pageViewControllers.count <= 5) {
        return;
    }
    
    float contentOffsetX = self.navBarScrollView.contentOffset.x;
    if (contentOffsetX > self.sliderView.frame.origin.x) {
        [self.navBarScrollView setContentOffset:CGPointMake(contentOffsetX - self.sliderViewWidth - 4, 0) animated:YES];
    } else if ((contentOffsetX + self.view.frame.size.width) < (self.sliderView.frame.size.width + self.sliderView.frame.origin.x)) {
        [self.navBarScrollView setContentOffset:CGPointMake(contentOffsetX + self.sliderViewWidth + 4, 0) animated:YES];
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.pageScrollView) {
        CGFloat xFromCenter = self.view.frame.size.width-self.pageScrollView.contentOffset.x;
        
        NSInteger coorX = (self.sliderView.frame.size.width + 4)*self.currentPageIndex + 2;
        
        NSInteger averageCount = self.pageViewControllers.count > 5 ? 5 : self.pageViewControllers.count;
        
        self.sliderView.frame = CGRectMake(coorX-xFromCenter/averageCount, self.sliderView.frame.origin.y, self.sliderView.frame.size.width, self.sliderView.frame.size.height);
    }
}

#pragma mark - Actions

- (void)selectedPageIndeAction:(UIButton *)segmentBtn {
    if (segmentBtn.tag == self.currentPageIndex) {
        return;
    }
    
    NSInteger currentIndex = self.currentPageIndex;
    __weak typeof(self) weakSelf = self;
    
    if (segmentBtn.tag > currentIndex) {
        for (int i = (int)currentIndex + 1; i<=segmentBtn.tag; i++) {
            [self.pageViewController setViewControllers:@[self.pageViewControllers[i]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf setCurrentPageIndex:i];
                }
            }];
        }
    } else {
        for (int i = (int)currentIndex - 1; i >= segmentBtn.tag; i --) {
            [self.pageViewController setViewControllers:@[self.pageViewControllers[i]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
                if (finished) {
                    [weakSelf setCurrentPageIndex:i];
                }
            }];
        }
    }
    
    [self setupSliderViewWithPageIndex:segmentBtn.tag];
}

- (void)setupSliderViewWithPageIndex:(NSInteger)pageIndex {
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.frame = CGRectMake((self.sliderViewWidth + 4)*pageIndex + 2, TOP_NAVBAR_HEIGHT - SLIDER_VIEW_HEIGHT, self.sliderViewWidth, SLIDER_VIEW_HEIGHT);
    }];
}

#pragma mark - Getters

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController =[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [_pageViewController setViewControllers:@[self.pageViewControllers[self.currentPageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

- (UIView *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[UIView alloc] init];
        _topNavBar.backgroundColor = [UIColor whiteColor];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        [_topNavBar addSubview:bottomLine];
        
        [self.view addSubview:_topNavBar];
    }
    return _topNavBar;
}

- (UIScrollView *)navBarScrollView {
    if (!_navBarScrollView) {
        _navBarScrollView = [[UIScrollView alloc] init];
        _navBarScrollView.backgroundColor = [UIColor clearColor];
        _navBarScrollView.showsHorizontalScrollIndicator = NO;
        
        [self.topNavBar addSubview:_navBarScrollView];
    }
    return _navBarScrollView;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = self.sliderViewTiniColor ? self.sliderViewTiniColor : SLIDER_VIEW_DEFAULT_BACKGROUNDCOLOR;
        
        [self.navBarScrollView addSubview:_sliderView];
    }
    return _sliderView;
}

#pragma mark - Setters

- (void)setSliderViewTiniColor:(UIColor *)sliderViewTiniColor {
    _sliderViewTiniColor = sliderViewTiniColor;
    
    self.sliderView.backgroundColor = sliderViewTiniColor;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    _currentPageIndex = currentPageIndex;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
