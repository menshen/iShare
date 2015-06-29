//
//  IS_EditShowModel.m
//  iShare
//
//  Created by wusonghe on 15/4/3.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditShowModel.h"

@implementation IS_EditShowModel

-(void)setMore_class:(NSString *)more_class{
    
    _more_class = more_class;
    if ([more_class isEqualToString:A_CLASS_SCENE]) {
        _editTemplateStyle = IS_EditTemplateStyleScene;
    }else if ([more_class isEqualToString:M_ONLY_PIC]){
        _editTemplateStyle = IS_EditTemplateStyleNoWord;
        
    }else if ([more_class isEqualToString:M_LESS_WORD]){
        _editTemplateStyle = IS_EditTemplateStyleLessWord;
        
    }else if ([more_class isEqualToString:M_MORE_WORD]){
        _editTemplateStyle = IS_EditTemplateStyleMutilWord;
        
    }

}

- (BOOL)isExist{

    NSString * appPath = [[NSBundle mainBundle]pathForResource:_a_id ofType:@"json"];
   BOOL isExi =  [[NSFileManager defaultManager]fileExistsAtPath:appPath];
    if (!isExi) {
        appPath = MODULE_AID_JSON_PATH(_a_id);// [FCFileManager pathForLibraryDirectoryWithPath:[NSString stringWithFormat:@"module/%@/%@.json",_a_id,_a_id]];
         isExi =  [[NSFileManager defaultManager]fileExistsAtPath:appPath];
        return isExi;
        
       
    }
    
    return isExi;
    
}
- (NSString *)getPicFamilyName{
    
    //p1_a
    
    NSString * num = [_a_id substringWithRange:NSMakeRange(1, 1)];
    NSString * name = [NSString stringWithFormat:@"pic%@",num];
    
    return name;

}


- (NSString *)getPlaceImgaeName{
    
    return AID_PIC_URL(_a_id);

}


@end
