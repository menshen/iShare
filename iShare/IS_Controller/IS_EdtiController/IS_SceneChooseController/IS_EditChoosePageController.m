//
//  IS_ScencPageController.m
//  iShare
//
//  Created by wusonghe on 15/4/7.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditChoosePageController.h"
#import "IS_SceneCollectionController.h"
#import "IS_SenceEditTool.h"
#import "IS_EditChooseController.h"
#define TITLE_KEY @"title"
#define IMG_KEY   @"img"

#define BOTTOM_BTN_WIDTH ScreenWidth/5
#define COVER_WINDOW_H ScreenHeight/2
#define BOTTOM_SHEET_H 50



@interface IS_EditChoosePageController ()<IS_EditChooseControllerDelegate>{
    NSMutableArray * _btnArray;
    UIButton * _selectBtn;
    UIImageView * _bottomView;
    NSIndexPath * _curIndexPath;
}
@property (strong , nonatomic)UIViewController * rootController;
@property (nonatomic, strong) UIWindow *actionsheetWindow;
@property (nonatomic, strong) UIWindow *oldKeyWindow;
@end

@implementation IS_EditChoosePageController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [self setup];
    [super viewDidLoad];

}

- (void)setup{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.paggingScrollView.height-=BOTTOM_SHEET_H;
    self.centerContainerView.height-=BOTTOM_SHEET_H;
    [self setupVCS];

    
    
    [self setupBottomView];
    [self.view addSubview:_bottomView];
    



}

- (void)setupVCS{
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *actionTypes = TEMPLATE_TYPE_NAME_ARRAY;
    
    [actionTypes enumerateObjectsUsingBlock:^(NSString *actionType, NSUInteger idx, BOOL *stop) {
        IS_EditChooseController *sceneVC = [[IS_EditChooseController alloc] init];
        sceneVC.tempateStyle = idx+1;
        sceneVC.delegate =self;
        [viewControllers addObject:sceneVC];
    }];
    self.viewControllers = viewControllers;
    self.titles = TEMPLATE_TYPE_NAME_ARRAY;
    self.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        NSLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };
    
    [self reloadData];
    
}
- (void)setupBottomView{
    
    
    _btnArray = [NSMutableArray array];
    
    _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0,ScreenHeight- BOTTOM_SHEET_H, ScreenWidth, BOTTOM_SHEET_H)];
    _bottomView.userInteractionEnabled = YES;
    _bottomView.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    
    
    //1.5个数组
    NSArray * btn_infos =@[@{TITLE_KEY:@"",IMG_KEY:@"bottom_template_icon_cancel"},
                           @{TITLE_KEY:@"纯图",IMG_KEY:@""},
                           @{TITLE_KEY:@"少字",IMG_KEY:@""},
                           @{TITLE_KEY:@"多字",IMG_KEY:@""},
                           @{TITLE_KEY:@"",IMG_KEY:@""}];
    for (int i = 0; i<5; i++) {
        CGRect frame = CGRectMake(BOTTOM_BTN_WIDTH * i, 0, BOTTOM_BTN_WIDTH, BOTTOM_SHEET_H);
        UIButton * btn = [[UIButton alloc]initWithFrame:frame];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:IS_SYSTEM_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        NSDictionary * info = btn_infos[i];
        if ([info[IMG_KEY] length]==0&&info[TITLE_KEY]) {
            [btn setTitle:info[TITLE_KEY] forState:UIControlStateNormal];
            
        }else if ([info[TITLE_KEY] length]==0&&info[IMG_KEY]){
            [btn setImage:[UIImage imageNamed:info[IMG_KEY]] forState:UIControlStateNormal];
            
        }
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_btnArray addObject:btn];
        [_bottomView addSubview:btn];
        
    }
    
    UIButton * btn_3 = _btnArray[2];
    [self btnAction:btn_3];
    
    

    
    
}
-(void)btnAction:(UIButton *)btn{
    
    if (btn.tag==0) {
      [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if(btn.tag==4){
        
    }else{
        _selectBtn.selected = !_selectBtn.selected;
        btn.selected = YES;
        _selectBtn = btn;
        [self setCurrentPage:btn.tag-1 animated:YES];
        
    }
    
    
    
}
- (void)addActionWithDismissBlock:(DidDismissBlock)didDismissBlock
                   DidSelectBlock:(DidSelectBlock)didSelectBlock{
    
    self.didSelectBlock =didSelectBlock;
    self.didDismissBlock = didDismissBlock;
}

- (void)IS_EditChooseControllerDidSelect:(id)result{
    
    if (self.didSelectBlock) {
        self.didSelectBlock(result);
        [self dismissCollectionViewControllerSheet];
//        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
#pragma mark - 展示
#pragma mark - 从根视图来展示
-(UIViewController *)rootController{
    
    if (!_rootController) {
        _rootController = [[UIViewController alloc]init];
    }
    return _rootController;
}
#pragma mark - 显示

- (void)showCollectionViewControllerSheetWithDismissBlock:(DidDismissBlock)didDismissBlock
                                           DidSelectBlock:(DidSelectBlock)didSelectBlock{
    
    self.didSelectBlock = didSelectBlock;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.userInteractionEnabled =YES;
    window.windowLevel = UIWindowLevelStatusBar + [UIApplication sharedApplication].windows.count;
    window.rootViewController = self.rootController;
    self.actionsheetWindow = window;
    
    self.oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    [self.actionsheetWindow makeKeyAndVisible];
    
    [self.view layoutIfNeeded];
    
    self.rootController.view.alpha = 0;
    CGRect targetRect = self.rootController.view.frame;
    CGRect initialRect = targetRect;
    initialRect.origin.y += initialRect.size.height;
    self.rootController.view.frame = initialRect;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.rootController.view.alpha = 1;
                         self.rootController.view.frame = targetRect;
                         [self.rootController presentViewController:self animated:YES completion:nil];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
}

- (void)dismissCollectionViewControllerSheet {
    
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
                         self.rootController=nil;
                         [self dismissViewControllerAnimated:YES completion:nil];
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
}


@end
