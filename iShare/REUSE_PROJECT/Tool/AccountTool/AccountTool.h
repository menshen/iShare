
/**
 *  1.QQ/WeChat/Weibo 第三方登录
 *  2.手机注册
    3.手机登录
 */
/**
 *  系统帐号的增删改查 -->其实用 Sqlite 可能更好
 */


typedef void(^HttpSuccessBlock)(id result);
typedef void(^HttpFailureBlock)(NSError * error);

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "SocialConfig.h"

@interface AccountTool : NSObject
single_interface(AccountTool)

#pragma mark 网络部分

/**
 *  验证手机(0.得到验证码 1.注册 2.忘记密码)
 *
 */
+(void)VerifyPhone:(NSString*)phone
         Success:(HttpSuccessBlock)success
         Failure:(HttpFailureBlock)failure;

/**
 *  注册
 */
+(void)registerPhone:(NSString*)phone
                Password:(NSString*)password
                Verifycode:(NSString*)verifycode
                Success:(HttpSuccessBlock)success
                Failure:(HttpFailureBlock)failure;

/**
 *  登录
 */
+(void)loginPhone:(NSString*)phone
            Password:(NSString*)password
            Success:(HttpSuccessBlock)success
            Failure:(HttpFailureBlock)failure;

/**
 *  第三方登录/注册 (1.如果返回有 UID 就是登录 2.否则注册)
 */

+(void)login_registerWithSocialPlatformType:(SocialPlatformType)socialPlatformType
                                    Success:(HttpSuccessBlock)success
                                    Failure:(HttpFailureBlock)failure;;

@end
