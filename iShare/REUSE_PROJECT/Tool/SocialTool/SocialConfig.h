//
//  SocialConfig.h
//  iShare
//
//  Created by 伍松和 on 15/1/16.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#ifndef iShare_SocialConfig_h
#define iShare_SocialConfig_h

typedef NS_ENUM(NSInteger, SocialPlatformType) {
    
    
    SocialPlatformTypeNone = -1,
    SocialPlatformTypeWXSession,
    SocialPlatformTypeWXTimeline,//朋友圈
    SocialPlatformTypeQQ,
    SocialPlatformTypeQQZone,
    SocialPlatformTypeWeibo,
    SocialPlatformTypeSMS,
    SocialPlatformTypeEmail
};

#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

/**
 *  AVOS
 *///
#define SocialConfig_URL    [[NSBundle mainBundle]URLForResource:@"SocialConfig" withExtension:@"plist"]
#define SocialConfig_Dic    [NSDictionary dictionaryWithContentsOfURL:SocialConfig_URL]
#define AVOSAppID           SocialConfig_Dic[@"AVOSINFO"][@"AVOSAppID"]
#define AVOSAppkey          SocialConfig_Dic[@"AVOSINFO"][@"AVOSAppkey"]
#define AVOSMasterkey       SocialConfig_Dic[@"AVOSINFO"][@"AVOSMasterkey"]

/**
 *  新浪
 */

#define SinaAppkey          SocialConfig_Dic[@"SINAINFO"][@"SinaAppkey"]
#define SinaAppSecret       SocialConfig_Dic[@"SINAINFO"][@"SinaAppSecret"]
#define SinaRedirectURI     SocialConfig_Dic[@"SINAINFO"][@"SinaRedirectURI"]
/**
 *  QQ
 */

#define QQAppKey            SocialConfig_Dic[@"QQINFO"][@"QQAppKey"]
#define QQAppSecret         SocialConfig_Dic[@"QQINFO"][@"QQAppSecret"]


//微信
#define WeChatAppkey        SocialConfig_Dic[@"WECHATINFO"][@"WeChatAppkey"]

#endif
