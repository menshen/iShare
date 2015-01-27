

#import "IS_SenceTemplateModel.h"

@implementation IS_SenceTemplateModel


#pragma mark 

-(NSMutableArray *)s_img_array{
    
    if (!_s_img_array) {
        _s_img_array = [NSMutableArray array];
    }
    return _s_img_array;
}
-(NSMutableArray *)s_text_array{
    
    if (!_s_text_array) {
        _s_text_array = [NSMutableArray array];
    }
    return _s_text_array;

}

@end
