
#import "XHTwitterPaggingViewer.h"
#import "IS_CategoryView.h"



@interface XHTwitterPaggingViewer () <UIScrollViewDelegate>

/**
 *  显示内容的容器
 */
@property (nonatomic, strong) UIView *centerContainerView;
@property (nonatomic, strong) UIScrollView *paggingScrollView;

/**
 *  显示title集合的容器
 */
@property (nonatomic, strong) IS_CategoryView *categoryView;

/**
 *  标识当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger lastPage;



@end

@implementation XHTwitterPaggingViewer

#pragma mark - Action



#pragma mark - DataSource

- (NSInteger)getCurrentPageIndex {
    return self.currentPage;
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
//    self.paggingNavbar.currentPage = currentPage;
    self.currentPage = currentPage;
    
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    CGPoint contentOffset = self.paggingScrollView.contentOffset;
    contentOffset.x = currentPage * pageWidth;
    [self.paggingScrollView setContentOffset:contentOffset animated:animated];
}

- (void)reloadData {
    if (!self.viewControllers.count) {
        return;
    }
    
    [self.paggingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        CGRect contentViewFrame = viewController.view.bounds;
        contentViewFrame.origin.y = IS_NAV_BAR_HEIGHT+40;
        contentViewFrame.origin.x = idx * CGRectGetWidth(self.view.bounds);
        viewController.view.frame = contentViewFrame;
        [self.paggingScrollView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
    
    [self.paggingScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * self.viewControllers.count, 0)];
    
   
    [self callBackChangedPage];
}

#pragma mark - Propertys

- (UIView *)centerContainerView {
    if (!_centerContainerView) {
        _centerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _centerContainerView.backgroundColor = self.view.backgroundColor;
        
        [_centerContainerView addSubview:self.paggingScrollView];
     
    }
    return _centerContainerView;
}

- (UIScrollView *)paggingScrollView {
    if (!_paggingScrollView) {
        _paggingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _paggingScrollView.bounces = NO;
        _paggingScrollView.pagingEnabled = YES;
        [_paggingScrollView setScrollsToTop:NO];
        _paggingScrollView.delegate = self;
        _paggingScrollView.showsVerticalScrollIndicator = NO;
        _paggingScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _paggingScrollView;
}


- (UIViewController *)getPageViewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    } else {
        return nil;
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage)
        return;
    _lastPage = _currentPage;
    _currentPage = currentPage;
    
    self.categoryView.currentItemIndex = currentPage;
    
    [self callBackChangedPage];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Ensure that the paggingScrollView is the correct height.
    // This facilitates situations where the XHTwitterPaggingViewer is shown within
    // a UITabBarController.
    CGRect scrollViewFrame = self.paggingScrollView.frame;
    scrollViewFrame.size.height = self.view.frame.size.height;
    self.paggingScrollView.frame = scrollViewFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupViews];
    
    [self reloadData];
    
    [self setupCategoryView];
}

#define IS_CategoryView_H 40


- (void)setupCategoryView{
    
    _categoryView = [[IS_CategoryView alloc]initWithFrame:CGRectMake(0, IS_NAV_BAR_HEIGHT, ScreenWidth, IS_CategoryView_H)];
    [self.view addSubview:_categoryView];
    
    NSArray * itemTitles = @[@"全部",@"婚礼",@"情侣",@"宠物",@"亲子",@"闺密",@"独享",@"旅行"];
    _categoryView.itemTitles = itemTitles;
    [_categoryView updateData];
    
    
}

- (void)setupViews {
    [self.view addSubview:self.centerContainerView];
    
  
}


#pragma mark - Block Call Back Method

- (void)callBackChangedPage {
    UIViewController *fromViewController = [self.viewControllers objectAtIndex:self.lastPage];
    UIViewController *toViewController = [self.viewControllers objectAtIndex:self.currentPage];

    [fromViewController viewWillDisappear: true];
    [fromViewController viewDidDisappear: true];
    [toViewController viewWillAppear: true];
    [toViewController viewDidAppear: true];

    if (self.didChangedPageCompleted) {
        self.didChangedPageCompleted(self.currentPage, [[self.viewControllers valueForKey:@"title"] objectAtIndex:self.currentPage]);
    }
}


#pragma mark - View Helper Method

- (UIView *)subviewWithClass:(Class)cuurentClass onView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:cuurentClass]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.paggingNavbar.contentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    // 根据当前的x坐标和页宽度计算出当前页数
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
