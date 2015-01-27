//
//  IS_BaseModel.m
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_BaseModel.h"

@implementation IS_BaseModel
-(instancetype)initWithDictionary:(NSDictionary*)dict{
    
    if (self=[super init]) {
        [self setKeyValues:dict];
    }
    
    return self;
}
@end
