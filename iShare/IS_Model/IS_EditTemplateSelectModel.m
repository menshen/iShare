

#import "IS_EditTemplateSelectModel.h"

@implementation IS_EditTemplateSelectModel
-(void)setS_img_name:(NSString *)s_img_name{
    
    _s_img_name = s_img_name;
    
    //0.什么风格
    NSRange r = [s_img_name rangeOfString:@"_"];
    NSString * template_style =[s_img_name substringWithRange:NSMakeRange(r.location+1, s_img_name.length-r.location-1)];
    _type = [template_style integerValue];
    
    //1.风格
    NSString * sub_template_style =[s_img_name substringWithRange:NSMakeRange(1, s_img_name.length-template_style.length-2)];
    _sub_type = [sub_template_style integerValue];
    
    //2.图片数量
    
    _img_count = _sub_type;
    
    //3.
    NSString * is_scene = [s_img_name substringToIndex:1];
    _isScene =[is_scene isEqualToString:@"s"];
    
    
}
@end
