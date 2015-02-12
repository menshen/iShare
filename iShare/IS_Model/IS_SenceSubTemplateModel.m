

#import "IS_SenceSubTemplateModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "IS_SenceEditTool.h"
@implementation IS_SenceSubTemplateModel

#pragma mark
//-(instancetype)init{
//    
//    if (self = [super init]) {
//        self.image_selected=-1;
//    }
//    return self;
//}
+ (NSMutableArray *)configureSubTemplateModelWithStandardSize:(CGSize)size
                                                        Index:(NSInteger)index
                                                    sub_index:(NSInteger)sub_index {
   
    if (index==0) {
        return nil;
    }
    
    //1.模板对应配置文件
    NSString *styleName = [NSString stringWithFormat:@"p%d_%d",(int)sub_index,(int)index];
    
    //2.
    NSDictionary *styleDict = [NSString objectFromJsonFilePath:styleName];
    
    
    //3.
    NSArray * sub_view_info_array = styleDict[SUB_VIEW_INFO];
    
    
    //4.遍历 每一个子视图信息
    
    //默认的
    CGFloat WIDTH =ScreenWidth-80;
    CGFloat HEIGHT =ScreenHeight-60-120-20;
    
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
        //6.是什么类型的
        senceSubTemplateModel.sub_type =[sub_view_info_dic[TYPE_KEY] integerValue];
        //7.占位符
        NSString * place_image_name = sub_view_info_dic[PLACE_IMAGE_NAME];
        senceSubTemplateModel.image_place_name = place_image_name?place_image_name:UPLOAD_IMAGE;
        
        //8.占位文字
        NSString * place_text =  sub_view_info_dic[PLACE_TEXT];
        senceSubTemplateModel.text_string =place_text;
        
        
        //9.tag
        senceSubTemplateModel.sub_tag =idx;
        [arrayM addObject:senceSubTemplateModel];
        
        
        
    }];
    
    return arrayM;
    
}
/*
if (!_image_url) {
    
    
    
    NSData * d =[self loadDataForDefaultRepresentation:[NSURL URLWithString:_image_url]];
    
    //         ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    //         [assetLibrary assetForURL:[NSURL URLWithString:_image_url] resultBlock:^(ALAsset *asset) {
    //             _image_data = copyOfOriginalImage;
    //         } failureBlock:nil];
    
}else{
    
}

*/
-(UIImage *)image_data{
    
    if (!_image_data) {

        [_image_data setAccessibilityIdentifier:UPLOAD_IMAGE];

       


    }else{
        [_image_data setAccessibilityIdentifier:[_image_data description]];
    }
    return _image_data;
 

}
#pragma mark -

// --------------- .h file

// class members in the header file (can't be local as then the blocks wouldn't be able to use them



// --------------- .m file

// NSConditionLock values



@end
