//typedef NS_ENUM(NSInteger, RootControllerStyle) {
//    
//    //0.新手教程
//    //1.登录注册界面
//    //2.注册后界面,设置界面
//    //3.主界面
//    
//    RootControllerStyleFirstOpen,
//    RootControllerStyleLoginResgiter,
//    RootControllerStyleAfterLoginResgiter,
//    RootControllerStyleMain,
//};

typedef NS_ENUM(NSInteger, ROOT_CONTROLLER_STATE_TYPE) {
    
    /*
     1.无帐号,无新手教程
     2.无帐号
     3.有帐号,UID,没有完善资料
     4.有帐号,有资料
     */
    
    ROOT_CONTROLLER_STATE_NO_ACCOUNT_NO_TUTOUIAL, //教程页面
    ROOT_CONTROLLER_STATE_NO_ACCOUNT_HAVE_TUTOUIAL, //登录页面
    ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_NO_ALTER, //设置页面
    ROOT_CONTROLLER_STATE_HAVE_ACCOUNT_HAVE_ALTER, //主页面
};
///根视图的状态,4种
#define ROOT_CONTROLLER_STATE @"ROOT_CONTROLLER_STATE"
#define SET_ROOT_CONTROLLER_STATE(OBJ) [[NSUserDefaults standardUserDefaults]setObject:OBJ forKey:ROOT_CONTROLLER_STATE];[[NSUserDefaults standardUserDefaults]synchronize]
#define GET_ROOT_CONTROLLER_STATE [[NSUserDefaults standardUserDefaults]objectForKey:ROOT_CONTROLLER_STATE]
#define DEL_ROOT_CONTROLLER_STATE [[NSUserDefaults standardUserDefaults]setObject:nil forKey:ROOT_CONTROLLER_STATE];[[NSUserDefaults standardUserDefaults]synchronize]
#import <Foundation/Foundation.h>
@interface RootControllerTool : NSObject
/**
 *  初次选择根控制器
 */
+ (void)chooseRootControllerFirstState:(ROOT_CONTROLLER_STATE_TYPE)state;
/**
 *  强制选择根控制器
 */
+ (void)chooseRootController:(ROOT_CONTROLLER_STATE_TYPE)rootControllerStyle;

@end
