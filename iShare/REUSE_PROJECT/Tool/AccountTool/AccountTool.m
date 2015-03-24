#import "AccountTool.h"
@implementation AccountTool
single_implementation(AccountTool)


-(instancetype)init{
    
    if (self = [super init]) {
        //
    }
    return self;
}

/**
 *  验证手机(0.得到验证码 1.注册 2.忘记密码)
 *
 */
+(void)VerifyPhone:(NSString*)phone
           Success:(HttpSuccessBlock)success
           Failure:(HttpFailureBlock)failure{}

/**
 *  注册
 */
+(void)registerPhone:(NSString*)phone
            Password:(NSString*)password
          Verifycode:(NSString*)verifycode
             Success:(HttpSuccessBlock)success
             Failure:(HttpFailureBlock)failure{}

/**
 *  登录
 */
+(void)loginPhone:(NSString*)phone
         Password:(NSString*)password
          Success:(HttpSuccessBlock)success
          Failure:(HttpFailureBlock)failure{}

/**
 *  第三方登录/注册 (1.如果返回有 UID 就是登录 2.否则注册)
 */

+(void)login_registerWithSocialPlatformType:(SocialPlatformType)socialPlatformType
                                    Success:(HttpSuccessBlock)success
                                    Failure:(HttpFailureBlock)failure;{

    
    
    switch (socialPlatformType) {
        case SocialPlatformTypeQQ:
        {
            if (![TencentOAuth iphoneQQInstalled]) {}
            [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:QQAppKey andAppSecret:QQAppSecret andRedirectURI:nil];
            break;
        }
        case SocialPlatformTypeWeibo:
        {
            if (![WeiboSDK isWeiboAppInstalled]) {
            }
            [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:SinaAppkey andAppSecret:SinaAppSecret andRedirectURI:SinaRedirectURI];
            break;
        }
            
            
        default:
            break;
    }
   
    
    if (socialPlatformType != SocialPlatformTypeWXSession) {
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (!object||error) {
                failure(error);
                return;
            }else{
                success(object);
                NSString * accessToken = nil;
                if (socialPlatformType==SocialPlatformTypeWeibo) {
                    accessToken=object[@"accessToken"];
                }else{
                    accessToken=object[@"access_token"];
                }
            }
            
            
            
        } toPlatform:(AVOSCloudSNSType)(socialPlatformType==SocialPlatformTypeWeibo)?AVOSCloudSNSSinaWeibo:AVOSCloudSNSQQ];
    }else{
        //微信登录
      
            //构造SendAuthReq结构体
            SendAuthReq* req =[[SendAuthReq alloc ] init];
            req.scope = @"snsapi_userinfo" ;
            req.state = @"123" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req];
        
        //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
        
    }
    
    


}
@end
