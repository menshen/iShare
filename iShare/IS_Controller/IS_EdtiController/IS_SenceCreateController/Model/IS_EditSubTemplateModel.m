

#import "IS_EditSubTemplateModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "IS_SenceEditTool.h"
#import "MutilThreadTool.h"
#import "HttpTool.h"
@implementation IS_EditSubTemplateModel

#pragma mark
-(instancetype)init{
    
    if (self = [super init]) {
    }
    return self;
}
//#define QINIU_BASEURL @"http://7vznnu.com2.z0.glb.qiniucdn.com/default/"
#define HEIGHT IS_CARD_ITEM_HEIGHT
#define WIDTH  HEIGHT*.63

+ (NSMutableArray *)configureSubTemplateModelWithAID:(NSString*)aid
                                                page:(NSInteger)page
                                             isSence:(BOOL)isSence{
   
   
    
    //1.模板对应配置文件
    NSDictionary *styleDict =nil;
    if (![IS_SenceEditTool objectFromJsonFilePath:aid]) {
        return nil;
    }else{
       styleDict= [IS_SenceEditTool objectFromJsonFilePath:aid];

    }
    if (!aid) {
        return nil;
    }
    //3.
    NSArray * subTemplateInfoArray = styleDict[SUB_VIEW_INFO];
    //4.遍历 每一个子视图信息

    
    //5.模板子视图
    NSMutableArray * arrayM = [NSMutableArray array];
    [subTemplateInfoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        IS_EditSubTemplateModel * subModel = [[IS_EditSubTemplateModel alloc]init];
        NSDictionary  * subDic = obj;
        subModel.view_id = subDic[VIEW_ID];
        subModel.sub_tag =idx;
        subModel.page =page;
        
#pragma mark - frame
        subModel = [self setFramesInfo:subDic within:subModel];
#pragma mark - 图片
        subModel.sub_type =[subDic[TYPE_KEY] integerValue];
        IS_ImageModel * imgModel = [[IS_ImageModel alloc]init];
        NSString * place_image_name = subDic[PLACE_IMAGE_NAME];
        imgModel.img_place_name = place_image_name?place_image_name:UPLOAD_IMAGE;
//        if ([UIImage imageNamed:place_image_name]) {
//            imgModel.img_place_url = DEFAULT_PIC_URL(place_image_name);
//        }
        //        NSString * place_name_jpg = [place_image_name stringByAppendingString:@".jpg"];
        if (subDic[PLACE_IMAGE_NAME_URL]) {
            imgModel.img_place_url = subDic[PLACE_IMAGE_NAME_URL];
        }else{
            
            
        }
        if (subDic[MASK_IMAGE_NAME]) {
            subModel.img_mask_name = subDic[MASK_IMAGE_NAME];
        }
        if (subDic[MASK_IMAGE_URL_NAME]) {
            imgModel.img_mask_url = subDic[MASK_IMAGE_URL_NAME];
        }
        
        subModel.imageModel = imgModel;
#pragma mark - 文字
        NSString * place_text =  subDic[PLACE_TEXT];
        subModel.text_place_string =place_text;
        if (subDic[TEXT_INFO_KEY]) {
            subModel.text_info = subDic[TEXT_INFO_KEY];
            subModel.isTextEdit = [subDic[TEXT_INFO_KEY][TEXT_INFO_EDIT] boolValue];
        }
        
        subModel.text_action = subDic[TEXT_ACTION_KEY];
        
       
        if (subModel) {
            [arrayM addObject:subModel];

        }
       

        
    }];
    
    return arrayM;
    
}
#pragma mark - 位置大小

+ (IS_EditSubTemplateModel *)setFramesInfo:(id)subDic
                                    within:(IS_EditSubTemplateModel*)subModel{

    //5.frame 信息
    CGRect rect1 = CGRectZero;
    if (subDic[FRAMES_KEY]) {
        NSArray * a= subDic[FRAMES_KEY];
        rect1 = CGRectMake([a[0] floatValue]*0.01*WIDTH,
                           [a[1] floatValue]*0.01*HEIGHT,
                           [a[2] floatValue]*0.01*WIDTH,
                           [a[3] floatValue]*0.01*HEIGHT);
        
    }
    if (!subDic[FRAMES_KEY]&&subDic[FRAME_KEY]) {
        NSDictionary  * sub_view_frame = subDic[FRAME_KEY];
        CGFloat X = [sub_view_frame[X_KEY] floatValue]*0.01*IS_CARD_ITEM_WIDTH;
        CGFloat Y = [sub_view_frame[Y_KEY] floatValue]*0.01*HEIGHT;
        CGFloat W = [sub_view_frame[WIDTH_KEY] floatValue]*0.01*WIDTH;
        CGFloat H = [sub_view_frame[HEIGHT_KEY] floatValue]*0.01*HEIGHT;
        rect1 = CGRectMake(X, Y, W, H);
        
    }
    
    
    
    
    CGRect rect = rect1;//CGRectMake(X, Y, W, H);
    subModel.sub_frame = NSStringFromCGRect(rect);
    
    return subModel;
}

#pragma mark - 图片

+ (IS_EditSubTemplateModel *)setImageInfo:(id)subDic
                                   within:(IS_EditSubTemplateModel*)subModel{
    

    return subModel;
}
#pragma mark - 文字
+ (IS_EditSubTemplateModel *)setTextInfo:(id)subDic
                                  within:(IS_EditSubTemplateModel*)subModel{
    
 
    return subModel;
}



-(IS_ImageModel *)imageModel{
    
    if (!_imageModel) {
        _imageModel = [[IS_ImageModel alloc]init];
    }
    return _imageModel;
}


@end
