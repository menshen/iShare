/*
 1.封装简单的web服务
 2.传输格式:JSON
 3.GET.POST,etc
 
 */
#define RET_MSG   @"retmsg"
#define ERROR     @"error"
#define MOUTH_KEY @"mon"
#define DATA_KEY  @"data"
#define TYPE_KEY  @"type"
#define PAGE_KEY  @"page"
#define PIC_KEY   @"pic"
#define WX_TOKEN  @"wx_token"

#define GET_MINE_SHARE_DATA @"/newmodule_dev/index.php?M=index&a=appgetcreatedata"
#define GET_RANKLIST_DATA    @"/newmodule_dev/index.php?M=index&a=appgetranklist"
#define GET_HOTLIST_DATA    @"/newmodule_dev/index.php?M=index&a=appgethotlist"
#define CREATE_HTML_API     @"/newmodule/index.php/app/create" //http://wx.ishareh5.com/newmodule/index.php/Home/app/create
#define UPLOAD_IMG_DATA     @"/upload/index.php?M=index&a=fileupload"
#define WX_LOGIN_API        @"/newmodule/index.php/app/wechatlogin"
#import <Foundation/Foundation.h>
#define BASEURL @"http://wx.ishareh5.com"//112.124.98.154//http://wx.ishareh5.com/upload/upload.php //http://api.waoo.cc
@interface HttpTool : NSObject



typedef void(^HttpSuccessBlock)(id result);
typedef void(^HttpFailureBlock)(NSError * error);
typedef void(^HttpImageProgressBlock)(id imageProgress);

/**
 *  根据URL路径跟请求参数完成GET请求
 *
 *  @param path         详细路径
 *  @param param        请求参数
 *  @param successBlock 请求成功
 *  @param failureBlock 请求失败
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params
                success:(HttpSuccessBlock)success
                failure:(HttpFailureBlock)failure;

/**
 *  根据URL路径跟请求参数完成GET请求
 *
 *  @param path         详细路径
 *  @param param        请求参数
 *  @param successBlock 请求成功
 *  @param failureBlock 请求失败
 */

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;





+ (void)headWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

//- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
//                    parameters:(NSDictionary *)parameters
//                       success:(void (^)(NSURLSessionDataTask *task))success
//                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  下载资源文件
 *
 *  @param fileURL 文件路径
 */
+(void)downloadFile:(NSString *)fileURL;

/**
    上传图片
 */
#pragma mark -上传图片
+(void)upLoadimage:(UIImage*)image
              path:(NSString*)path
             param:(NSDictionary*)param
          imageKey:(NSString*)imageKey
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;

#pragma mark - 下载图片

+ (void)downloadImgaeWithURL:(NSString*)imageURL
                    progress:(HttpImageProgressBlock)progressBlock
                     success:(HttpSuccessBlock)success
                     failure:(HttpFailureBlock)failure;




@end
