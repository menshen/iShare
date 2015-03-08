
#import "IS_SencePageController.h"
#import "IS_SenceCollectionController.h"

@interface IS_SencePageController ()<ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation IS_SencePageController

- (void)viewDidLoad {
    

     // Do any additional setup after loading the view from its nib.
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"View Pager";
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabWidth = ScreenWidth/5;
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 6;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"选项%i", (int)index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    IS_SenceCollectionController *cvc = [[IS_SenceCollectionController alloc]init];
    
//    cvc.labelString = [NSString stringWithFormat:@"Content View #%i", index];
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
//- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
//    
//    switch (option) {
//        case ViewPagerOptionStartFromSecondTab:
//            return 1.0;
//            break;
//        case ViewPagerOptionCenterCurrentTab:
//            return 0.0;
//            break;
//        case ViewPagerOptionTabLocation:
//            return 1.0;
//            break;
//        default:
//            break;
//    }
//    
//    return value;
//}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}

@end
