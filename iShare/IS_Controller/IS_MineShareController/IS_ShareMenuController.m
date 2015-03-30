
#import "IS_ShareMenuController.h"
#import "IS_EditLoadingView.h"
#import "KVNProgress.h"
#import "IS_WebContentController.h"

@interface IS_ShareMenuController ()
@property (strong ,nonatomic)IS_EditLoadingView * loadingView;
@end

@implementation IS_ShareMenuController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBaseKVNProgressUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    //1.
   // [self setupLoadingView];
    
    //2.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    

}
- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}


- (void)setupCustomKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor lightGrayColor];
    [KVNProgress appearance].statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    
    
    [KVNProgress appearance].backgroundFillColor = [UIColor greenColor];
    [KVNProgress appearance].backgroundTintColor = [UIColor blackColor];
    [KVNProgress appearance].successColor = [UIColor whiteColor];
    [KVNProgress appearance].errorColor = [UIColor whiteColor];
    [KVNProgress appearance].circleSize = 110.0f;
    [KVNProgress appearance].lineWidth = 1.0f;
}
#pragma mark - 加载视图
- (void)setupLoadingView{

    [self setupCustomKVNProgressUI];
    
    [self showProgress];

}
- (void)showProgress
{
//    [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: @"Success",
//    KVNProgressViewParameterFullScreen: @(YES)}];
   // [KVNProgress showSuccessWithStatus:@"Loading..."];

    
}





@end
