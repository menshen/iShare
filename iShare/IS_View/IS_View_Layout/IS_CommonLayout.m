//
//  IS_TemplateLayout.m
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CommonLayout.h"
#define ITEM_MARGIN 5 //间距
#define ITEM_WIDTH  (ScreenWidth/2-2*ITEM_MARGIN) //宽度
#define ITEM_HEIGHT ITEM_WIDTH*1.5 //高度

@implementation IS_CommonLayout

-(instancetype)init{
    
    if (self=[super init]) {
        self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
        self.minimumLineSpacing = ITEM_MARGIN;
        self.minimumInteritemSpacing = ITEM_MARGIN;
        self.sectionInset = UIEdgeInsetsMake(ITEM_MARGIN, ITEM_MARGIN, ITEM_MARGIN, ITEM_MARGIN);
    }
    
    return self;
    
    //1.初始化
    

}
-(instancetype)initWithItemWidth:(CGFloat)ItemWidth{

    if (self=[super init]) {
        self.itemSize = CGSizeMake(ItemWidth, ItemWidth);
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(ITEM_MARGIN, ITEM_MARGIN, ITEM_MARGIN, ITEM_MARGIN);
    }
    
    return self;
}

@end
