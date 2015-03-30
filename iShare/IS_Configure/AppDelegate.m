//
//  AppDelegate.m
//  iShare
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "AppDelegate.h"
#import "IS_NavigationController.h"
#import "IS_HomeController.h"
#import "RootControllerTool.h"
#import "FLEXManager.h"
#import "WXApi.h"
#import "HttpTool.h"
#import "KVNProgress.h"
#import "IS_MainController.h"
@interface AppDelegate ()<WXApiDelegate>
@property (copy,nonatomic)NSString * wx_code;
@property (copy,nonatomic)NSString * openID;
@property (copy,nonatomic)NSString * tokenID;
@end

@implementation AppDelegate

//void myExceptionHandler(NSException *exception)
//{
//    NSArray *stack = [exception callStackReturnAddresses];
//    NSLog(@"Stack trace: %@", stack);
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //iShare_List
    
  
    
    [WXApi registerApp:WX_APPID withDescription:@"WEIXIN"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    [self.window makeKeyAndVisible];
    
    //1.首页
    
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"IS_MainController" owner:nil options:nil];
    UITabBarController *tabBarController = [arr lastObject];
    tabBarController.title  =@"爱分享";
    IS_NavigationController * nav = [[IS_NavigationController alloc]initWithRootViewController:tabBarController];
    
    [self.window addSubview:nav.view];
    [self.window setRootViewController:nav];

    
    //2
    [[UINavigationBar appearance] setBarTintColor:IS_SYSTEM_COLOR];
    [[UINavigationBar appearance] setTintColor:kColor(250, 250, 250)];//142
     NSDictionary * font_dic =@{NSForegroundColorAttributeName:kColor(250, 250, 250),
                               NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    [[UINavigationBar appearance] setTitleTextAttributes:font_dic];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];    
    
    
    //3.    //short version
    [self setupFLEXManager];

    return YES;

}


#pragma mark - 开启FLEX调试

- (void)setupFLEXManager{
    
    UITapGestureRecognizer * two_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSixFingerQuadrupleTap:)];
    two_tap.numberOfTapsRequired=2;
    two_tap.numberOfTouchesRequired=2;
    
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:two_tap];
    
    

}
#if DEBUG
#import "FLEXManager.h"

#endif

- (void)handleSixFingerQuadrupleTap:(UITapGestureRecognizer *)tapRecognizer
{
#if DEBUG
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        // This could also live in a handler for a keyboard shortcut, debug menu item, etc.
        [[FLEXManager sharedManager] showExplorer];
    }
#endif
}
#pragma mark - 调用WxAPI
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    return [TencentOAuth HandleOpenURL:url] ||
//    [WeiboSDK handleOpenURL:url delegate:self] ||
//    [WXApi handleOpenURL:url delegate:self];;
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];

}
//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [KVNProgress showWithStatus:@"正在授权"];
        /*
         ErrCode ERR_OK = 0(用户同意)
         ERR_AUTH_DENIED = -4（用户拒绝授权）
         ERR_USER_CANCEL = -2（用户取消）
         code    用户换取access_token的code，仅在ErrCode为0时有效
         state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
         lang    微信客户端当前语言
         country 微信用户当前国家信息
         */
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            //        NSString *code = aresp.code;
            //        NSDictionary *dic = @{@"code":code};
            self.wx_code = aresp.code;
            [self getAccess_token];
            
        }

    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        [KVNProgress showSuccess];

    }else{
        [KVNProgress showSuccess];
   
    }
    
}
-(void)getAccess_token
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_APPID,WX_APPSECRET,self.wx_code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
                self.tokenID = [dic objectForKey:@"access_token"];
                self.openID = [dic objectForKey:@"openid"];
                [self getUserInfo];
                
            }
        });
    });
}
#pragma mark - 获取UserInfo
-(void)getUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.tokenID,self.openID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            if (data) {
                
                NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:@{WX_TOKEN:self.tokenID}];
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [dicM addEntriesFromDictionary:dic];
                NSString * json = [NSString jsonFromObject:dicM];
//                json = [json URLEncodedString];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                NSLog(@"%@",json);
                
                NSDictionary * params = @{DATA_KEY:json};
                [HttpTool postWithPath:WX_LOGIN_API params:params success:^(id result) {
                    [KVNProgress showSuccessWithStatus:@"成功"];
                } failure:^(NSError *error) {
                    [KVNProgress showErrorWithStatus:@"请求失败"];

                }];
                
               // NSString * nickName = [dic objectForKey:@"nickname"];
//                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                
            }
                
    });

}

@end
