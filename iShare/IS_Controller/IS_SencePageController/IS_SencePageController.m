
#import "IS_SencePageController.h"
#import "UIViewController+MMDrawerController.h"

#import "SUNSlideSwitchView.h"
#import "SCNavTabBarController.h"
#import "IS_CollectionView.h"
@interface IS_SencePageController ()<IS_SceneCollectionControllerDelegate>

@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic,strong)NSMutableArray * controllerArray;
@property (nonatomic,strong)SCNavTabBarController * navTabBarController;
@property (nonatomic,strong)IS_CollectionView * collectionView;


@property (nonatomic, strong) UIWindow *actionsheetWindow;
@property (nonatomic, strong) UIWindow *oldKeyWindow;
@property (nonatomic,strong) UIViewController * rootController;
@end

@implementation IS_SencePageController{
    
    UIButton * _closeBtn;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupClosebtn];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[UIBarButtonItem appearance]setTintColor:[UIColor whiteColor]];

    self.title = @"场景选择";

    
    
   
    [self createVCS:IS_SceneChooseTypeCreate];
    


  
}
- (void)createVCS:(IS_SceneChooseType)sceneChooseType{
    self.navTabBarController.subViewControllers=nil;
    NSArray * titleArray = @[@"婚礼",@"情侣",@"宠物",@"亲子",@"闺密",@"个人"];
    self.controllerArray = [NSMutableArray array];
    
    for (int i =0; i<6; i++) {
        IS_SceneCollectionController *vc = [[IS_SceneCollectionController alloc] init];
        [vc appendDatasource:[NSMutableArray arrayWithArray:SENCE_1_ARRAY]];
        vc.title = titleArray[i];
        if (sceneChooseType==IS_SceneChooseTypeCreate) {
            
        }else{
        }
        vc.delegate = self;

        vc.sceneChooseType = sceneChooseType;
        [self.controllerArray addObject:vc];
        
        
    }
    self.navTabBarController.subViewControllers = self.controllerArray;
    [self.navTabBarController addParentController:self];
    self.navTabBarController.view.height-=50;
}
- (void)IS_SceneCollectionControllerDidSceneChange:(id)result{
    

    
    if (self.selectBlock) {
        self.selectBlock(result);
    }
    [self disMiss];

}
#define CLOSE_BUTTON_WIDTH 50

-(void)setupClosebtn{
    
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-CLOSE_BUTTON_WIDTH)/2, ScreenHeight-60, CLOSE_BUTTON_WIDTH,CLOSE_BUTTON_WIDTH)];
    [_closeBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeBtn];
}

- (void)closeButtonAction:(UIButton*)btn{
   
    if (self.sceneChooseType==IS_SceneChooseTypeCreate) {
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [self disMiss];
    }
//
}
-(SCNavTabBarController *)navTabBarController{
    if (!_navTabBarController) {
        _navTabBarController = [[SCNavTabBarController alloc]init];
    }
    return _navTabBarController;
}
#pragma mark - 展示视图
-(UIViewController *)rootController{
    
    if (!_rootController) {
        _rootController = [[UIViewController alloc]init];
    }
    return _rootController;
}
- (void)showAnimationAtContainerView:(UIView *)containerView
                         selectBlock:(IS_SencePageDidSelectBlock)selectBlock{
    
    self.selectBlock = selectBlock;
    self.sceneChooseType = IS_SceneChooseTypeChange;
//    [self createVCS:IS_SceneChooseTypeChange];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.userInteractionEnabled =YES;
    window.windowLevel = UIWindowLevelStatusBar + [UIApplication sharedApplication].windows.count;
    window.rootViewController = self.rootController;
    self.actionsheetWindow = window;
    
    self.oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    [self.actionsheetWindow makeKeyAndVisible];
    
    
    self.rootController.view.alpha = 0;
    CGRect targetRect = self.rootController.view.frame;
    CGRect initialRect = targetRect;
    initialRect.origin.y += initialRect.size.height;
    self.rootController.view.frame = initialRect;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.rootController.view.alpha = 1;
                         self.rootController.view.frame = targetRect;
                         self.view.backgroundColor = [UIColor whiteColor];
                         [self.rootController presentViewController:self animated:YES completion:nil];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
}
- (void)disMiss {
    
    //    ActionSheetViewController *viewController =(ActionSheetViewController*)self.actionsheetWindow.rootViewController;
    
    
    [self.actionsheetWindow removeFromSuperview];
    self.actionsheetWindow = nil;
    
    [self.oldKeyWindow makeKeyWindow];
    self.oldKeyWindow = nil;
    
    
    
    CGRect targetRect = self.rootController.view.frame;
    targetRect.origin.y += targetRect.size.height;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.rootController.view.alpha = 0;
                         self.rootController.view.frame = targetRect;
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         self.rootController=nil;
                     }];
    
    
}


@end
