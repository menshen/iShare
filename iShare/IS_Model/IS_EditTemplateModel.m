

#import "IS_EditTemplateModel.h"
@implementation IS_EditTemplateModel

#pragma mark
-(instancetype)init{
    
    if (self = [super init]) {
        self.selected_tag=-1;
    }
    return self;
}


#pragma mark - 根据主风格+子风格 ->构建子视图的参数
-(void)setType:(NSInteger)type{
    
    _type = type;
}
-(void)setSub_type:(NSInteger)sub_type{
    _sub_type = sub_type;
    
   
    
    //初始化时候构建占位的
    NSMutableArray * arrayM = [IS_EditSubTemplateModel configureSubTemplateModelIndex:_type
                                                                              subIndex:_sub_type
                                                                                  page:_row_num
                                                                               isSence:_is_sence];
    self.subview_array = arrayM;
    
  
}

-(NSMutableArray *)img_array{
    if (!_img_array) {
        _img_array = [NSMutableArray array];
        [_subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_EditSubTemplateModel * sub_model = obj;
            if (sub_model.sub_type == IS_SubTypeImage&&sub_model.img) {
               
                [_img_array addObject:sub_model.img];
            }
        }];
    }
    return _img_array;
}

-(NSMutableArray *)subview_array{
    
    if (!_subview_array) {
        _subview_array = [NSMutableArray array];
    }
    return _subview_array;
}

-(NSInteger)img_count{
    
    return _sub_type;
}

- (void)configureRowNum:(NSInteger)row{
    
    [self.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IS_EditSubTemplateModel * subModel = obj;
        subModel.page = row;
        [self.subview_array replaceObjectAtIndex:idx withObject:subModel];
        
    }];
}
@end
