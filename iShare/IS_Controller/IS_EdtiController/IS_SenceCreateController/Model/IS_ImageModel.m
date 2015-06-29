

#import "IS_ImageModel.h"
#import "MutilThreadTool.h"

@implementation IS_ImageModel


-(NSString *)img_id{
    if (!_img_id) {
        _img_id = [NSString randomString_16];
    }
    return _img_id;
}
#pragma mark - 上传操作
- (void)uploadUnderlyingImageAndNotify{
    
    [self img_id];
    
    
    @try {
        if (self.img_url&&self.img_upload_state==IS_ImageUploadStateDone) {
            [self imageUpLoadingComplete];
        } else if(self.img){
            [self performUpLoadImageAndNotify];
        }else{
            
        }
    }
    @catch (NSException *exception) {
       
        [self imageUpLoadingComplete];
    }
    @finally {
    }

}
#pragma mark - 正在上传
- (void)performUpLoadImageAndNotify{
    
 
        
//        self.img_upload_state = IS_ImageUploadStateing;
//        [[NSNotificationCenter defaultCenter]postNotificationName:IS_UPLOAD_NOTIFICATION object:self];
        [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            [HttpTool upLoadimage:self.img
                             path:UPLOAD_IMG_DATA // //upload/upload.php
                            param:nil
                         imageKey:PIC_KEY
                          success:^(id result) {
                              //1.发出通知
                              self.img_upload_state = IS_ImageUploadStateDone;
                              
                              NSLog(@"img_url:%@",result[DATA_KEY]);
                              NSLog(@"img_id:%@",self.img_id);
                              self.img_url=result[DATA_KEY]?result[DATA_KEY]:nil;
                              
                              [[NSNotificationCenter defaultCenter]postNotificationName:IS_UPLOAD_NOTIFICATION object:self];
                          } failure:^(NSError *error) {
                              self.img_upload_state = IS_ImageUploadStateFailure;
                              [[NSNotificationCenter defaultCenter]postNotificationName:IS_UPLOAD_NOTIFICATION object:self];
                          }];
        }];

    
}

#pragma mark - 上传完成
- (void)imageUpLoadingComplete {
//    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
//     Complete so notify
    // Notify on next run loop
    [self performSelector:@selector(postCompleteNotification) withObject:nil afterDelay:0];
}

- (void)postCompleteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:PHOTO_UPLOADING_DID_END_NOTIFICATION
                                                        object:self];
}
-(void)loadUnderlyingImageAndNotify{

}
@end
