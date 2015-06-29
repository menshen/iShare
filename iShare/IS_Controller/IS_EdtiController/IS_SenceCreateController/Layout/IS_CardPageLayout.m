//
//  IS_CardPageLayout.m
//  iShare
//
//  Created by 伍松和 on 15/3/18.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CardPageLayout.h"

@implementation IS_CardPageLayout
-(instancetype)init{
    
    if (self=[super init]) {
        
        self.itemSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
    
    //1.初始化
    
    
}
-(void)prepareLayout{

    [super prepareLayout];
    
    self.itemSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
//    NSLog(@"%@",NSStringFromCGSize(self.itemSize));
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    attributes.transform3D = CATransform3DMakeScale(0.9, 0.9, 1.0);
    attributes.transform = CGAffineTransformMakeScale(1.1, 1.1);
    attributes.alpha  =0.15;
    return attributes;

}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{

    
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    CATransform3D transform = CATransform3DMakeTranslation(0, self.collectionView.bounds.size.height, 0);
    transform = CATransform3DRotate(transform, M_PI/4, 0, 0, 1);
    attributes.transform3D = transform;
    attributes.alpha  =0.1;
    
      return attributes;
}


@end
