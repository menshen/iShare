//
//  IS_CardPageLayout.m
//  iShare
//
//  Created by 伍松和 on 15/3/18.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CardPageLayout.h"
#define ITEM_MARGIN 0 //间距
#define ITEM_WIDTH  ScreenWidth //宽度
#define ITEM_HEIGHT ITEM_WIDTH*1.5 //高度
@implementation IS_CardPageLayout
-(instancetype)init{
    
    if (self=[super init]) {
      
    }
    
    return self;
    
    //1.初始化
    
    
}
-(void)prepareLayout{

    [super prepareLayout];
    
    self.itemSize = CGSizeMake(ScreenWidth, self.collectionView.height-20);
    self.minimumLineSpacing = ITEM_MARGIN;
    self.minimumInteritemSpacing = ITEM_MARGIN;
    self.sectionInset = UIEdgeInsetsMake(ITEM_MARGIN, ITEM_MARGIN, ITEM_MARGIN, ITEM_MARGIN);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}
@end
