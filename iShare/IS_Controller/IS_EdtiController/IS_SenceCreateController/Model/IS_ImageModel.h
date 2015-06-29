
#define PHOTO_UPLOADING_DID_END_NOTIFICATION @"PHOTO_UPLOADING_DID_END_NOTIFICATION"

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, IS_ImageUploadState) {
    
    IS_ImageUploadStateNone,
    IS_ImageUploadStateing,
    IS_ImageUploadStateDone,
    IS_ImageUploadStateFailure
};
@interface IS_ImageModel : BaseModel

@property (copy,nonatomic)NSString                     *img_id;
/**
 *  图片数据
 */
@property (nonatomic,strong) UIImage                  * img;
/**
 *  图片数据路径,本地或者网络上的
 */
@property (nonatomic,copy  ) NSString                 * img_asset;
/**
 *  图片上传 URL
 */
@property (nonatomic,copy  ) NSString                 * img_url;
/**
 *   相片信息
 */
@property (nonatomic,strong) NSMutableDictionary      * img_info;


/**
 *  占位符图片
 */
@property (nonatomic,copy  ) NSString                 * img_place_name;
/*
 *  mask图片
 */
@property (nonatomic,copy  ) NSString                 * img_mask_url;
/**
 *  占位符图片
 */
@property (nonatomic,copy  ) NSString                 * img_place_url;

/**
 *  上传状态
 */
@property (nonatomic,assign) IS_ImageUploadState      img_upload_state;

/**
 *  @brief  上传
 */
- (void)uploadUnderlyingImageAndNotify;
/**
 *  @brief   //还有加载
 */
- (void)loadUnderlyingImageAndNotify;

@end
