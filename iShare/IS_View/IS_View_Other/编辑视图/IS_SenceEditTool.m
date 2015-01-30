
#import "IS_SenceEditTool.h"
#import "IS_SenceCreateImageView.h"
#import "IS_SenceCreateEditView.h"
#import "IS_SenceSubTemplateModel.h"

@interface IS_SenceEditTool()
@end

@implementation IS_SenceEditTool

+ (NSMutableArray*)appendSenceDefaultData{

    NSMutableArray * arrayM = [NSMutableArray array];
    for (int i = 0; i<2; i++) {
        IS_SenceTemplateModel  * senceModel = [[IS_SenceTemplateModel alloc]init];
        if (i<1) {
            
            senceModel.s_template_style=1;
            senceModel.s_sub_template_style=3;
            
        }else{
            senceModel.s_template_style=0;
            senceModel.s_sub_template_style=0;
        }
        senceModel.s_Id = i;
        [arrayM addObject:senceModel];
        //        NSString * id_condition = [NSString stringWithFormat:@"s_id = %d",(int)senceModel.s_Id];
        //        [IS_SenceTemplateModel insertModelToDB:senceModel condition:id_condition didInsertBlock:nil];
        
    }
    //    self.senceTemplateArray =[IS_SenceTemplateModel queryFormDB:nil orderBy:nil count:10 success:nil];
    
    return arrayM;
}

-(void)ss:(NSInteger)index sub_index:(NSInteger)sub_index {

    //1.模板对应配置文件
    NSString *styleName = [NSString stringWithFormat:@"t_%d_%d",(int)index,(int)sub_index];
    
    //2.
    NSDictionary *styleDict = [NSString objectFromJsonFilePath:styleName];
    
    
    //3.
    NSArray * sub_view_info_array = styleDict[SUB_VIEW_INFO];
    
    
    //4.遍历 每一个子视图信息
    
    CGFloat WIDTH =ScreenWidth;
    CGFloat HEIGHT =ScreenHeight-60-120;
    
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
        
      
        
    }];

}
@end
