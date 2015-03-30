#import "IS_MainController.h"
#import "IS_Button.h"
#import "IS_SencePageController.h"
#import "IS_NavigationController.h"
#import "IS_LoginController.h"

@interface IS_MainController ()
@property (strong,nonatomic)UIImageView * bottomTabbar;
@end

@implementation IS_MainController{

    UIButton * _selectBtn;
    NSMutableArray * _btnArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBottomTabbar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"home_icon_setting" highlightedIcon:@"home_icon_setting" target:self action:@selector(settingAction:)];

}
-(void)settingAction:(id)sender{
    IS_LoginController * login = [[IS_LoginController alloc]init];
    [self presentViewController:login animated:YES completion:nil];
   
}

#define TAB_IMG @"img"
#define TAB_TITLE @"title"
- (void)setupBottomTabbar{
    
    _btnArray = [NSMutableArray array];
    [self.tabBar setHidden:YES];
    [self.view addSubview:self.bottomTabbar];
    
    NSArray * btn_array = @[@{TAB_TITLE:@"热门案例",TAB_IMG:@"home_icon_hot"},
                            @{TAB_TITLE:@"",TAB_IMG:@"home_bottom_tab"},
                            @{TAB_TITLE:@"我的分享",TAB_IMG:@"home_icon_mine"}];
    
    for (int i =0; i<3; i++) {
        IS_Button * btn = [[IS_Button alloc]initWithFrame:CGRectMake(i * IS_MAIN_TABBAR_ITEM_WIDTH, -3, IS_MAIN_TABBAR_ITEM_WIDTH, IS_MAIN_TABBAR_HEIGHT) ButtonPositionType:ButtonPositionTypeBothCenter];
        
        
        NSString * img_name = btn_array[i][TAB_IMG];
        NSString * highlight_name = [img_name stringByAppendingString:@"_highlight"];

        [btn setImage:[UIImage imageNamed:img_name] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highlight_name] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:IS_SYSTEM_COLOR forState:UIControlStateSelected];

        
        [btn setTitle:btn_array[i][TAB_TITLE] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        if (i==1) {
            btn.y -=5;
            btn.height +=10;
        }else if (i==0){
              btn.x +=30;
            
        }else if (i==2){
             btn.x -=30;
        }
     
        
        [_btnArray addObject:btn];
        [self.bottomTabbar addSubview:btn];
    }
    
    
    
    UIButton * btn = _btnArray[0];
    [self btnAction:btn];
}
-(UIImageView *)bottomTabbar{
    
    if (!_bottomTabbar) {
        _bottomTabbar = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight-IS_MAIN_TABBAR_HEIGHT, ScreenWidth, IS_MAIN_TABBAR_HEIGHT)];
        _bottomTabbar.image = [UIImage resizedImage:@"IS_Toolbar_up"];
        _bottomTabbar.userInteractionEnabled= YES;
    }
    return _bottomTabbar;

}

- (void)btnAction:(UIButton*)sender{
    if (sender.tag==1) {
        IS_SencePageController * pvc = [[IS_SencePageController alloc]init];
        CGSize windowSize = self.view.window.bounds.size;
        
        UIImage * snapshot = [UIImage getImageFromCurView:self.view];
        snapshot = [snapshot applyBlurWithRadius:40
                                       tintColor:Color(244, 244, 244, 0.7)
                           saturationDeltaFactor:0.8
                                       maskImage:nil];
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
        backgroundImageView.frame =  CGRectMake(0, 0, windowSize.width, windowSize.height);;
        backgroundImageView.userInteractionEnabled = YES;
        [pvc.view addSubview:backgroundImageView];
        [pvc.view sendSubviewToBack:backgroundImageView];
        [self.navigationController pushViewController:pvc animated:YES];
        
    }else{
        [self setSelectedIndex:[sender tag]];
        _selectBtn.selected = !_selectBtn.selected;
        sender.selected = YES;
        _selectBtn = sender;
    }

}


@end
