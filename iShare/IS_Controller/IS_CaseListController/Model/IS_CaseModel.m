//
//  IS_CaseModel.m
//  iShare
//
//  Created by wusonghe on 15/3/25.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CaseModel.h"

@implementation IS_CaseModel


-(NSString *)detailTitle{
    
    if (!_detailTitle||_detailTitle.length==0) {
        _detailTitle = @"";
    }
    return _detailTitle;
}
-(NSString *)title{
    
    
    if (!_title||_title.length==0) {
        _title = @"";
    }
    return _title;
    
}

@end
