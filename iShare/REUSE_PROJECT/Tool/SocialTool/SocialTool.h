


#import <Foundation/Foundation.h>
#import "SocialConfig.h"
@interface SocialTool : NSObject
/**
 *  分享信息
 *
 *  @param url_string URL
 *  @param title      标题
 *  @param des        详情
 *  @param image      缩略图
 *  @param sendType   平台类型
 */
+(void)socialToolPlatformWithURLString:(NSString*)url_string
                           Title:(NSString*)title
                               Des:(NSString*)des
                             Image:(UIImage*)image
                          PlatformType:(SocialPlatformType)platformType;
@end
