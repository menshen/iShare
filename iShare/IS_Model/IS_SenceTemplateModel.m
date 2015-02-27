

#import "IS_SenceTemplateModel.h"
@implementation IS_SenceTemplateModel

#pragma mark
-(instancetype)init{
    
    if (self = [super init]) {
        self.s_selected_tag=-1;
    }
    return self;
}


#pragma mark - 根据主风格+子风格 ->构建子视图的参数
-(void)setS_template_style:(NSInteger)s_template_style{
    
    _s_template_style = s_template_style;
}
-(void)setS_sub_template_style:(NSInteger)s_sub_template_style{
    _s_sub_template_style = s_sub_template_style;
    
    //初始化时候构建占位的
    NSMutableArray * arrayM = [IS_SenceSubTemplateModel configureSubTemplateModelWithStandardSize:CGSizeZero
                                                                                            Index:_s_template_style
                                                                                        sub_index:_s_sub_template_style];
    self.s_sub_view_array = arrayM;
    
  
}

-(void)setS_selected_tag:(NSInteger)s_selected_tag{
    if (s_selected_tag==-1) {
        [self.s_sub_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_SenceSubTemplateModel * sub =obj;
            sub.image_selected=NO;
            [self.s_sub_view_array replaceObjectAtIndex:idx withObject:sub];
        }];
        //[self.s_sub_view_array makeObjectsPerformSelector:@selector(setImage_selected:) withObject:@(YES)];
    }else{
        [self.s_sub_view_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            IS_SenceSubTemplateModel * sub =obj;
            sub.image_selected=(idx==s_selected_tag);
            [self.s_sub_view_array replaceObjectAtIndex:idx withObject:sub];
        }];
       
    }
   
    
}

-(NSMutableArray *)s_sub_view_array{
    
    if (!_s_sub_view_array) {
        _s_sub_view_array = [NSMutableArray array];
    }
    return _s_sub_view_array;
}

-(NSInteger)img_count{
    
    return _s_sub_template_style;
}

@end
