

#import "IS_EditTemplateModel.h"
@implementation IS_EditTemplateModel


-(NSString *)template_id{
    if (!_template_id) {
        _template_id = [NSString randomString_16];
    }
    return _template_id;
}

-(void)setMore_class:(NSString *)more_class{
    
    _more_class = more_class;
//    if ([more_class isEqualToString:S_SCENE_KEY]) {
//        _editStyle = IS_EditTemplateStyleScene;
//    }else if ([more_class isEqualToString:M_ONLY_PIC]){
//        _editStyle = IS_EditTemplateStyleNoWord;
//        
//    }else if ([more_class isEqualToString:M_LESS_WORD]){
//        _editStyle = IS_EditTemplateStyleLessWord;
//        
//    }else if ([more_class isEqualToString:M_MORE_WORD]){
//        _editStyle = IS_EditTemplateStyleMutilWord;
////        
//    }
    
}
-(void)setA_class:(NSString *)a_class{
    
    _a_class =a_class;
    
    
    
    if ([a_class isEqualToString:A_CLASS_SCENE]) {
        _isScene = YES;
    }else{
        _isScene = NO;
    }
    
}


-(NSMutableArray *)getImgArray{
        NSMutableArray * imgArrayM = [NSMutableArray array];
        if (_subview_array) {
            [_subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                IS_EditSubTemplateModel * sub_model = obj;
                
                if (sub_model.sub_type == IS_SubTypeImage) {
                    
                    [imgArrayM addObject:sub_model];
                }
            }];
        }
        
    
    return imgArrayM;
}

-(NSMutableArray *)getImgWithImgDataArray{
    NSMutableArray * imgArrayM = [NSMutableArray array];
    if (_subview_array) {
        [_subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_EditSubTemplateModel * sub_model = obj;
            
            if (sub_model.sub_type == IS_SubTypeImage&&sub_model.imageModel.img) {
                [imgArrayM addObject:sub_model.imageModel.img];
            }
        }];
    }
    
    
    return imgArrayM;
}

-(NSMutableArray *)subview_array{
    
    if (!_subview_array) {
        _subview_array = [NSMutableArray array];
    }
    return _subview_array;
}
- (void)configureRowNum:(NSInteger)row{
    
    if (self.subview_array) {
        [self.subview_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IS_EditSubTemplateModel * subModel = obj;
            [self.subview_array replaceObjectAtIndex:idx withObject:subModel];
            
        }];
    }
    
}
-(void)setA_id:(NSString *)a_id{
    
    _a_id = a_id;
  
    
    //初始化时候构建占位的
    NSMutableArray * arrayM = [IS_EditSubTemplateModel
                               configureSubTemplateModelWithAID:_a_id
                               page:0
                               isSence:_isScene];
    
    [self template_id];
    
    
    self.subview_array = arrayM;
    
    
    
    
    
}
@end
