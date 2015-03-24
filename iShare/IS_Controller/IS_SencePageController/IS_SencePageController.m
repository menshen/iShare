
#import "IS_SencePageController.h"
#import "IS_SenceCollectionController.h"
#import "IS_SenceTemplateCollectionController.h"
#import "UIViewController+MMDrawerController.h"

#import "SUNSlideSwitchView.h"
#import "SCNavTabBarController.h"
#import "DrawerViewController.h"
#import "IS_CollectionView.h"
@interface IS_SencePageController ()

@property (nonatomic,strong)NSMutableArray * titleArray;
@property (nonatomic,strong)NSMutableArray * controllerArray;
@property (nonatomic,strong)SCNavTabBarController * navTabBarController;
@property (nonatomic,strong)IS_CollectionView * collectionView;
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

    
    
    NSArray * titleArray = @[@"婚礼",@"情侣",@"宠物",@"亲子",@"闺密",@"个人"];
    self.controllerArray = [NSMutableArray array];
    
    for (int i =0; i<6; i++) {
        IS_SenceCollectionController *vc = [[IS_SenceCollectionController alloc] init];
        vc.view.height-=100;
        vc.title = titleArray[i];
        [self.controllerArray addObject:vc];
        

    }
    self.navTabBarController.subViewControllers = self.controllerArray;
    [self.navTabBarController addParentController:self];
    self.navTabBarController.view.height-=100;

    


  
}
#define CLOSE_BUTTON_WIDTH 60

-(void)setupClosebtn{
    
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth-CLOSE_BUTTON_WIDTH)/2, ScreenHeight-70, CLOSE_BUTTON_WIDTH,CLOSE_BUTTON_WIDTH)];
    [_closeBtn addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeBtn];
}

- (void)closeButtonAction:(UIButton*)btn{
   
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(SCNavTabBarController *)navTabBarController{
    if (!_navTabBarController) {
        _navTabBarController = [[SCNavTabBarController alloc]init];
    }
    return _navTabBarController;
}


@end
