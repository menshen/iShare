

#import "RootControllerTool.h"

#import "IS_LoginController.h"
#import "IS_RegisterViewController.h"
#import "IS_HomeController.h"
#import "IS_RegisterAfterController.h"
#import "IS_NavigationController.h"
#import "SVProgressHUD.h"
@interface RootControllerTool()
@end
@implementation RootControllerTool
#pragma mark -选择
+ (void)chooseRootController:(ROOT_CONTROLLER_STATE_TYPE)rootctrl_stateType{
    
    switch (rootctrl_stateType) {
        case ROOT_CONTROLLER_STATE_NO_ACCOUNT_NO_TUTOUIAL:
            break;
        case ROOT_CONTROLLER_STATE_NO_ACCOUNT_HAVE_TUTOUIAL:
            [self jumpToLoginResgiter:YES];
            break;
        case ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_NO_ALTER:
            [self jumpToResgiterAlter];
            break;
        case ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_HAVE_ALTER:
            [self jumpToMainController];
            break;
            
        default:
            break;
    }
}

#pragma mark -自动选择
+ (void)chooseRootControllerFirstState:(ROOT_CONTROLLER_STATE_TYPE)state{
    
    ROOT_CONTROLLER_STATE_TYPE rootControllerState  =state;
    if (GET_ROOT_CONTROLLER_STATE) {
        rootControllerState=[GET_ROOT_CONTROLLER_STATE integerValue];
    }
    switch (rootControllerState) {
        case ROOT_CONTROLLER_STATE_NO_ACCOUNT_NO_TUTOUIAL:
            [self jumpToTutorial];
            break;
        case ROOT_CONTROLLER_STATE_NO_ACCOUNT_HAVE_TUTOUIAL:
            [self jumpToLoginResgiter:NO];
            break;
        case ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_NO_ALTER:
            [self jumpToResgiterAlter];
            break;
        case ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_HAVE_ALTER:
            [self jumpToMainController];
            break;
            
        default:
            break;
    
    }
//
 
 
    
}

#pragma mark -跳转动画


#pragma mark -新手教程
///新手教程
+(void)jumpToTutorial{
    SET_ROOT_CONTROLLER_STATE(@(ROOT_CONTROLLER_STATE_NO_ACCOUNT_NO_TUTOUIAL));
}
#pragma mark -登录界面,有数据则清空数据
+(void)jumpToLoginResgiter:(BOOL)animated{
    
    
    SET_ROOT_CONTROLLER_STATE(@(ROOT_CONTROLLER_STATE_NO_ACCOUNT_HAVE_TUTOUIAL));
    if (animated) {
        [SVProgressHUD showWithStatus:@"正在退出"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView: [UIApplication sharedApplication].keyWindow
                              duration:0.5
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                IS_LoginController*hi_login =[[IS_LoginController alloc]init];
                                IS_NavigationController  *nav= [[IS_NavigationController alloc]initWithRootViewController:hi_login];
                                [UIApplication sharedApplication].keyWindow.rootViewController=nav;
                                [SVProgressHUD dismiss];

                            }
                            completion:^(BOOL finished) {
//                                [[BaseModel getUsingLKDBHelper]dropAllTable];
                                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_ACCOUNT];
                                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:MY_UID];
                                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"account"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                            }];
        });

    }else{
    
        //IS_RegisterViewController.h
//           IS_RegisterViewController*hi_login =[[IS_RegisterViewController alloc]init];
       IS_LoginController*hi_login =[[IS_LoginController alloc]init];
        IS_NavigationController  *nav= [[IS_NavigationController alloc]initWithRootViewController:hi_login];
        [UIApplication sharedApplication].keyWindow.rootViewController=nav;
    }
    
    
  
    
  
    
    
   
    
}
#pragma mark -修改
+(void)jumpToResgiterAlter{
    
    SET_ROOT_CONTROLLER_STATE(@(ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_NO_ALTER));
    IS_RegisterAfterController*setting= [[IS_RegisterAfterController alloc]init];
    IS_NavigationController  *nav= [[IS_NavigationController alloc]initWithRootViewController:setting];
    [UIApplication sharedApplication].keyWindow.rootViewController=nav;
  
    
}
+(void)jumpToMainController{
    
 
    SET_ROOT_CONTROLLER_STATE(@(ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_HAVE_ALTER));
    [UIApplication sharedApplication].keyWindow.rootViewController=[[IS_HomeController alloc]init];
    
}


@end
