
/**
 *  1.发送图文+URL
 *  2.发送音乐
 */
#import "SocialTool.h"



@interface SocialTool()<WXApiDelegate>
{
    enum WXScene _scene;
}
@end

@implementation SocialTool
+(void)socialToolPlatformWithURLString:(NSString*)url_string
                                 Title:(NSString*)title
                                   Des:(NSString*)des
                                 Image:(UIImage*)image
                          PlatformType:(SocialPlatformType)platformType{

    [self ShareWXWithURLString:url_string Title:title Des:des Image:image scene:platformType];

    

}
#pragma mark - 微信
+ (void)ShareWXWithURLString:(NSString*)url_string
                              Title:(NSString*)title
                                Des:(NSString*)des
                              Image:(UIImage*)image
                                scene:(NSInteger)scene{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =title;
    message.description = des;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    //
    [WXApi sendReq:req];
    
}
#pragma mark -新浪
+ (void)ShareSinaWBWithURLString:(NSString*)url_string
                       Title:(NSString*)title
                         Des:(NSString*)des
                           Image:(UIImage*)image{

    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.sina.com";
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    message.text =des;
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
}

#pragma mark -QQ
+ (void)ShareQQWithURLString:(NSString*)url_string
                           Title:(NSString*)title
                             Des:(NSString*)des
                       Image:(UIImage*)image
                        platformType:(SocialPlatformType)platformType{
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url_string]
                                title:title
                                description:des
                                previewImageData:UIImageJPEGRepresentation(image, 0.8)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    
    if (platformType==SocialPlatformTypeQQ) {
        [QQApiInterface sendReq:req];
    }else{
        //QQ-ZONE
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if (sent) {}
    }
    
    


}


@end
