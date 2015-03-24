
#import "IS_SenceEditTool.h"
#import "IS_SenceCreateImageView.h"
#import "IS_SenceCreateEditView.h"
#import "IS_SenceSubTemplateModel.h"
#import "UIWindow+JJ.h"
#import "MutilThreadTool.h"
#import "HttpTool.h"

#define APP_CREATE_URL  @"newmodule/index.php?M=index&a=appcreate"

@interface IS_SenceEditTool()
@end

@implementation IS_SenceEditTool



+(char)numberToAlpha:(char)beChar{
    
    //1->a
    char c =beChar;
    c+=96;
    return c;

}
+(char)AlphaToNumber:(char)beChar{
    
    //a-1
    char c =beChar;
    c-=96;
    return c;
    
}


#pragma mark - 把场景出去来
+ (IS_SenceModel *)getSenceModelWithID:(NSString*)sence_id{

    NSString * condition = [NSString stringWithFormat:@"sence_id = '%@'",sence_id];
    //  NSString * condition = [NSString stringWithFormat:@"rowid = '%d'",(int)sence_id];
    NSMutableArray * arrayM = [IS_SenceModel queryFormDB:condition orderBy:nil count:1 success:nil];
    IS_SenceModel * s = [arrayM lastObject];
    return s;
}

#pragma mark - 保存
+ (void)saveSenceModelWithSenceID:(NSString*)senceID
                    TemplateArray:(NSMutableArray*)templateArray
             SubTemplateDataArray:(NSMutableArray*)subTemplateDataArray
                    CompleteBlock:(SenceModelCompleteBlock)CompleteBlock
{
    
    UIWINDOW_SUCCESS(@"正在保存..");

    
    //1.模板数组
    NSMutableArray * arrayM = [NSMutableArray array];
    
    
    
    [MutilThreadTool ES_AsyncConcurrentOperationQueueBlock:^{
        [templateArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //2.每个模板的信息
            NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
            
            IS_SenceTemplateModel * tm = obj;
            //3.模板主题+子模板主题
            NSString * a_id =nil;
            if (tm.is_sence) {
                a_id = [NSString stringWithFormat:@"scene%d_%c",(int)tm.type,[self numberToAlpha:tm.sub_type]];

            }else{
                a_id = [NSString stringWithFormat:@"p%d_%c",(int)tm.type,[self numberToAlpha:tm.sub_type]];

            }
          
            NSDictionary * type_dic = @{T_AID:a_id};
            [dictM addEntriesFromDictionary:type_dic];
            
        // p2_b_1t
            //4.图片数组
            NSMutableArray * img_array = [NSMutableArray array];
           __block  NSInteger text_num =0;
            __block NSInteger decorate_num = 0;
            [tm.subview_array enumerateObjectsUsingBlock:^(id s_obj, NSUInteger s_idx, BOOL *stop) {
                
                IS_SenceSubTemplateModel * s =s_obj;
                NSMutableDictionary *content_dic = [NSMutableDictionary dictionary];
                NSString * t_name = nil;
                
                switch (s.sub_type) {
                    case IS_SubTypeText:
                    {
                    if (s.text_place_string||s.text) {
                        //1.有文字
                        text_num++;
                        [content_dic addEntriesFromDictionary:@{TYPE_KEY:@(1)}];
                        t_name = [NSString stringWithFormat:@"%@_t%d",a_id,text_num];
                        [content_dic addEntriesFromDictionary:@{TEXT_KEY:s.text_place_string?s.text_place_string:@""}];
                    }
                     break;
                    }
                    case IS_SubTypeImage:{
                    if (s.img_url) {
                        //有图片数据
                        [content_dic addEntriesFromDictionary:@{TYPE_KEY:@(0)}];
                        t_name = [NSString stringWithFormat:@"%@_%d",a_id,s_idx+1-text_num-decorate_num];
                        [content_dic addEntriesFromDictionary:@{IMAGE_URL_KEY:s.img_url?s.img_url:@""}];
                        if (s.img_info) {
                            NSMutableDictionary * temp =[NSMutableDictionary dictionaryWithDictionary:s.img_info];
                            if (temp[TRANSLATE_KEY]) {
                                CGPoint point = CGPointFromString(temp[TRANSLATE_KEY]);
                                CGFloat X = point.x/IS_CARD_ITEM_WIDTH;
                                CGFloat Y = point.y/IS_CARD_ITEM_HEIGHT;
                                NSArray * XY = @[@(X),@(Y)];
                                [temp setObject:XY forKey:TRANSLATE_KEY];
                            }
                            [content_dic addEntriesFromDictionary:@{IMAGE_INFO_KEY:temp?temp:@{}}];
                            
                        }
                    }
                     break;
                    }
                    case IS_SubTypeDecorate:{
                        decorate_num++;
                    }
                        
                    default:
                        break;
                    }
                
               
                
                
                if (t_name&&content_dic[TYPE_KEY]) {
                   
                    NSDictionary * img_content_dic = @{t_name:content_dic};
                    [img_array addObject:img_content_dic];
                }
               
                
                
                
            }];
            text_num=0;
            decorate_num=0;
            [dictM addEntriesFromDictionary:@{T_CONTENT_KEY:img_array}];
            [arrayM addObject:dictM];
        }];
        
        NSMutableDictionary * last_dic =[NSMutableDictionary dictionaryWithDictionary:@{T_MODULE_KEY:arrayM}];
        
        //1.enter_id
        NSString * datestr = [NSDate getRealDateTime:[NSDate date] withFormat:@"yyyyMMdd"];
        NSInteger sub =(arc4random() % 99999) + 1;
        NSString * enter_id = [NSString stringWithFormat:@"%@%d",datestr,sub];
        [last_dic addEntriesFromDictionary:@{@"enterid":enter_id}];
        [last_dic addEntriesFromDictionary:@{@"share_txt":@"测试 AAA"}];
        [last_dic addEntriesFromDictionary:@{@"share_img":@"https://ss0.bdstatic.com/5a21bjqh_Q23odCf/static/superplus/img/logo_white_ee663702.png"}];
        [last_dic addEntriesFromDictionary:@{@"title":@"测试 BB"}];
        [last_dic addEntriesFromDictionary:@{@"activity_name":@"iwedding"}];
        NSString * json = [NSString jsonFromObject:last_dic];
        NSLog(@"json-%@",json);
        [HttpTool postWithPath:APP_CREATE_URL
                        params:@{@"data":json}
                       success:^(id result) {
                           
                           NSLog(@"http://wx.ishareh5.com%@",result[@"url"]);
                       }
                       failure:^(NSError *error) {
                           NSLog(@"error:%@",error);

                       }];
    
        
//        [subTemplateDataArray enumerateObjectsUsingBlock:^(id s_obj, NSUInteger s_idx, BOOL *stop) {
//            IS_SenceSubTemplateModel * s =s_obj;
//            s.img=nil;
//            [subTemplateDataArray replaceObjectAtIndex:s_idx withObject:s];
//        }];
//        
//        
//        if (senceID) {
//            
//            IS_SenceModel * senceModel_exist = [self getSenceModelWithID:senceID];
//            
//            //1.场景数组
//            senceModel_exist.sence_template_array = templateArray;
//            
//            //2.用过的图片
//            senceModel_exist.image_array = subTemplateDataArray;
//            
//            [senceModel_exist updateToDB];
//            
//            
//        }else{
//            //0.
//            IS_SenceModel * senceModel = [[IS_SenceModel alloc]init];
//            
//            //1.场景数组
//            
//            senceModel.sence_template_array = templateArray;
//            
//            //2.用过的图片
//            
//            
//            
//            senceModel.image_array = subTemplateDataArray;
//            
//            senceModel.sence_id = [self msg_custom_id];
//            
////            senceModel.i_title = [NSString stringWithFormat:@"%@",[NSDate date]] ;
////            
////            
////            
////            
////            senceModel.i_image = @"icon_5";
//            
//            [IS_SenceModel insertToDB:senceModel];
//            
//        }

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
#pragma mark - 贝塞尔曲线

#pragma mark - 根据数组组建贝塞尔曲线(1.普通直线 2.曲线 3.等等)
+ (UIBezierPath *)getBezierPathFromArray:(id)array
                                   WIDTH:(CGFloat)WIDTH
                                  HEIGHT:(CGFloat)HEIGHT
                                    type:(NSInteger)type{
    UIBezierPath * path = [UIBezierPath bezierPath];

    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * pointStr = obj;
        NSArray * xy = [pointStr componentsSeparatedByString:@","];
        CGFloat X = [xy[0] floatValue]*0.01*WIDTH;
        CGFloat Y = [xy[1] floatValue]*0.01*HEIGHT;
        CGPoint point = CGPointMake(X, Y);
        if (idx == 0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
            //                    [path addCurveToPoint: controlPoint1:<#(CGPoint)#> controlPoint2:<#(CGPoint)#>]
            //                    [path addCurveToPoint:CGPointMake(101.5, 72.5) controlPoint1: CGPointMake(67.78, 56.83) controlPoint2: CGPointMake(75.76, 76.01)];
        }
        
    }];
    [path closePath];
    return path;
}


#pragma mark - 根据贝塞尔曲线获取数组
//CGPathRef p = path.CGPath;
//NSMutableArray *bezierPoints = [NSMutableArray array];
//CGPathApply(p, (__bridge void *)(bezierPoints), CGPathApplierFunc);
void CGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    CGPoint *points = element->points;
    CGPathElementType type = element->type;
    
    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;
            
        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;
            
        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
    
}
@end
