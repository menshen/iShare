

#import "IS_SenceSubTemplateModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"
#import "HttpTool.h"
@implementation IS_SenceSubTemplateModel

#pragma mark
-(instancetype)init{
    
    if (self = [super init]) {
    }
    return self;
}
+ (NSMutableArray *)configureSubTemplateModelIndex:(NSInteger)index
                                          subIndex:(NSInteger)subIndex
                                              page:(NSInteger)page
                                           isSence:(BOOL)isSence{
   
    if (index==0) {
        return nil;
    }
    
    //1.模板对应配置文件
    NSString *styleName =nil;
    if (isSence) {
        styleName = [NSString stringWithFormat:@"s%d_%d",(int)subIndex,(int)index];
    }else{
        styleName = [NSString stringWithFormat:@"p%d_%d",(int)subIndex,(int)index];
    }
    
    //2.
    NSDictionary *styleDict =nil;
    if (![NSString objectFromJsonFilePath:styleName]) {
        return nil;
    }else{
       styleDict= [NSString objectFromJsonFilePath:styleName];

    }
    
    
    //3.
    NSArray * sub_view_info_array = styleDict[SUB_VIEW_INFO];
    
    
    //4.遍历 每一个子视图信息
    
    //默认的
    CGFloat WIDTH =IS_CARD_ITEM_WIDTH;
    CGFloat HEIGHT =IS_CARD_ITEM_HEIGHT;
    
    //5.模板子视图
    NSMutableArray * arrayM = [NSMutableArray array];
    [sub_view_info_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        IS_SenceSubTemplateModel * senceSubTemplateModel = [[IS_SenceSubTemplateModel alloc]init];

        NSDictionary  * sub_view_info_dic = obj;
        //5.frame 信息
        NSDictionary  * sub_view_frame = sub_view_info_dic[FRAME_KEY];
        CGFloat X = [sub_view_frame[X_KEY] floatValue]*0.01*WIDTH;
        CGFloat Y = [sub_view_frame[Y_KEY] floatValue]*0.01*HEIGHT;
        CGFloat W = [sub_view_frame[WIDTH_KEY] floatValue]*0.01*WIDTH;
        CGFloat H = [sub_view_frame[HEIGHT_KEY] floatValue]*0.01*HEIGHT;
        CGRect rect = CGRectMake(X, Y, W, H);
        senceSubTemplateModel.sub_frame = NSStringFromCGRect(rect);
        //6.point 信息
        
        if (sub_view_info_dic[POINT_KEY]) {
            NSArray * ponitArray = sub_view_info_dic[POINT_KEY];
            senceSubTemplateModel.sub_bezierPath =[IS_SenceEditTool getBezierPathFromArray:ponitArray
                                                                                       WIDTH:WIDTH
                                                                                      HEIGHT:HEIGHT type:1];;
          
            
        }
        
  
        
        //6.是什么类型的
        senceSubTemplateModel.sub_type =[sub_view_info_dic[TYPE_KEY] integerValue];
        //7.占位符
        NSString * place_image_name = sub_view_info_dic[PLACE_IMAGE_NAME];
        NSString * place_name_jpg = [place_image_name stringByAppendingString:@".jpg"];
        senceSubTemplateModel.img_place_name = place_name_jpg?place_name_jpg:UPLOAD_IMAGE;
        
        //8.占位文字
        NSString * place_text =  sub_view_info_dic[PLACE_TEXT];
        senceSubTemplateModel.text_place_string =place_text;
        
        
        //9.tag
        senceSubTemplateModel.sub_tag =idx;
        
        //10.page
        senceSubTemplateModel.page =page;
        
        
    
        
        [arrayM addObject:senceSubTemplateModel];

        
    }];
    
    return arrayM;
    
}

-(void)uploadImageData:(UIImage*)imageData{
    
//    [imageData setAccessibilityValue:@"1"];
//    imageData.accessibilityValue
    
    BOOL condition =(self.img_upload_state == IS_ImageUploadStateBegin||self.img_upload_state == IS_ImageUploadStateFailure)&&!self.img_url;
    if (condition){
        
        self.img_upload_state = IS_ImageUploadStateing;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IMAGE_UPLOAD" object:self];
        
        [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
            [HttpTool upLoadimage:imageData
                             path:@"test.php" // //upload/upload.php
                            param:nil
                         imageKey:@"pic"
                          success:^(id result) {
                              
                              //1.发出通知
                              self.img_upload_state = IS_ImageUploadStateDone;
                              self.img_url=@"XX";
                              [[NSNotificationCenter defaultCenter]postNotificationName:@"IMAGE_UPLOAD" object:self];
                              
                              
                          } failure:^(NSError *error) {
                            
                              
                          }];
        }];
    
    }

}


@end
