
#import "IS_SenceEditTool.h"
#import "IS_SenceCreateImageView.h"
#import "IS_SenceCreateEditView.h"
#import "IS_SenceSubTemplateModel.h"
#import "UIWindow+JJ.h"
#import "MutilThreadTool.h"


@interface IS_SenceEditTool()
@end

@implementation IS_SenceEditTool

+ (NSMutableArray*)appendSenceDefaultData{

    NSMutableArray * arrayM = [NSMutableArray array];
    for (int i = 0; i<1; i++) {
        IS_SenceTemplateModel  * senceModel = [[IS_SenceTemplateModel alloc]init];
       
        if (i<3) {
            
            senceModel.s_template_style=1;
            senceModel.s_sub_template_style=i+1;
            
        }
        senceModel.s_Id = i;
        [arrayM addObject:senceModel];
        //        NSString * id_condition = [NSString stringWithFormat:@"s_id = %d",(int)senceModel.s_Id];
        //        [IS_SenceTemplateModel insertModelToDB:senceModel condition:id_condition didInsertBlock:nil];
        
    }
    //    self.senceTemplateArray =[IS_SenceTemplateModel queryFormDB:nil orderBy:nil count:10 success:nil];
    
    return arrayM;
}

+ (NSArray *)get_tempArray{
    
    return @[@"1,1",@"1,2",@"1,3",@"1,4",@"1,6",@"2,1",@"2,2",@"2,3"];

}



#pragma mark - 把场景出去来
+ (IS_SenceModel *)getSenceModelWithID:(NSString*)sence_id{

    NSString * condition = [NSString stringWithFormat:@"sence_id = '%@'",sence_id];
    //  NSString * condition = [NSString stringWithFormat:@"rowid = '%d'",(int)sence_id];
    NSMutableArray * arrayM = [IS_SenceModel queryFormDB:condition orderBy:nil count:1 success:nil];
    
    IS_SenceModel * s = [arrayM lastObject];
    
    //1.
    
    
    //2.
    
    return s;
}

#pragma mark - 保存
+ (void)saveSenceModelWithSenceID:(NSString*)senceID
                    TemplateArray:(NSMutableArray*)templateArray
             SubTemplateDataArray:(NSMutableArray*)subTemplateDataArray
                    CompleteBlock:(SenceModelCompleteBlock)CompleteBlock
{
    
    UIWINDOW_SUCCESS(@"正在保存..");
//    [UIWindow showWithBarStatus:@"正在保存.." dismissAfter:3];
//    [UIWindow showWithHUDStatus:@"正在保存.." detailStatus:@"...." dismissAfter:3];

//   __block UIImage * image = [UIImage imageNamed:@"bg_001"];
    
    [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        [templateArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_SenceTemplateModel * tm = obj;
            //                NSDictionary * dic = [tm keyValues];
            //                NSArray * arrayM =dic[@"s_sub_view_array"];
            [tm.s_sub_view_array enumerateObjectsUsingBlock:^(id s_obj, NSUInteger s_idx, BOOL *stop) {
                
                IS_SenceSubTemplateModel * s =s_obj;
//                if (s.sub_type == IS_SenceSubTemplateTypeImage&&idx==0) {
//                    image = s.image_data;
//                }
                
                s.image_data=nil;
                [tm.s_sub_view_array replaceObjectAtIndex:s_idx withObject:s];
                
            }];
            
            [templateArray replaceObjectAtIndex:idx withObject:tm];
        }];
        
        [subTemplateDataArray enumerateObjectsUsingBlock:^(id s_obj, NSUInteger s_idx, BOOL *stop) {
            IS_SenceSubTemplateModel * s =s_obj;
            s.image_data=nil;
            [subTemplateDataArray replaceObjectAtIndex:s_idx withObject:s];
        }];
        
        
        if (senceID) {
            
            IS_SenceModel * senceModel_exist = [self getSenceModelWithID:senceID];
            
            //1.场景数组
            senceModel_exist.sence_template_array = templateArray;
            
            //2.用过的图片
            senceModel_exist.image_array = subTemplateDataArray;
            
            [senceModel_exist updateToDB];
            
            
        }else{
            //0.
            IS_SenceModel * senceModel = [[IS_SenceModel alloc]init];
            
            //1.场景数组
            
            senceModel.sence_template_array = templateArray;
            
            //2.用过的图片
            
            
            
            senceModel.image_array = subTemplateDataArray;
            
            senceModel.sence_id = [self msg_custom_id];
            
            senceModel.i_title = [NSString stringWithFormat:@"%@",[NSDate date]] ;
            
            
            
            
            senceModel.i_image = @"icon_5";
            
            [IS_SenceModel insertToDB:senceModel];
            
        }

    } MainThreadBlock:^{
        if (CompleteBlock) {
            CompleteBlock(@(YES));
        }
    }];
        
  
    
}
+(NSString*)msg_custom_id{
    NSString *chars=@"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length==62);
    int len=(int)chars.length;
    NSMutableString* result=[[NSMutableString alloc] init];
    for(int i=0;i<24;i++){
        int p=arc4random_uniform(len);
        NSRange range=NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}

#pragma mark - 利用条件锁使异步事件变同步


+(UIImage*)getImagesDataFromAssetURLString:(NSString*)URLString{

    
    NSURL * url = [NSURL URLWithString:URLString];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    ALAssetsLibrary* libary = [[ALAssetsLibrary alloc] init];
   __block UIImage * last_image = [[UIImage alloc]init];
        dispatch_async(queue, ^{
            [libary assetForURL:url resultBlock:^(ALAsset *asset) {
                last_image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                dispatch_semaphore_signal(sema);
            } failureBlock:^(NSError *error) {
                dispatch_semaphore_signal(sema);
            }];
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    return last_image;
}

@end
