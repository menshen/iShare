//
//  EBCardCollectionViewLayout.m
//  Vindeo
//
//  Created by Ezequiel A Becerra on 7/11/14.
//  Copyright (c) 2014 Ezequiel A Becerra. All rights reserved.
//

#import "IS_CardLayout.h"

@interface IS_CardLayout()
- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath;
- (CGRect)frameForCardAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)cardWidth;
- (CGFloat)pageWidth;
- (void)setup;
@end

@implementation IS_CardLayout

#pragma mark - Private

static NSString * const CellKind = @"CardCell";

- (void)setup {

    [self addObserver:self forKeyPath:@"collectionView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    UIOffset anOffset = UIOffsetMake(IS_CARD_LAYOUT_WIDTH, IS_CARD_LAYOUT_HEIGHT);
    [self setOffset:anOffset];
}
#pragma mark -计算尺寸问题

- (NSInteger)cardWidth {
    NSInteger retVal = self.collectionView.bounds.size.width - _offset.horizontal * 2;
    return retVal;
}

- (CGFloat)pageWidth {
    CGFloat retVal = [self cardWidth] + _offset.horizontal/2;
    return retVal;
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    NSString *retVal = [NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row];
    return retVal;
}

- (CGRect)frameForCardAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger posX = 0;
    
    if ([self.collectionView numberOfItemsInSection:0] == 1) {
        //  如果数据源只有一个数据,就cell直接居中显示
        posX = _offset.horizontal + [self pageWidth] * indexPath.row;
    }else{
        posX = _offset.horizontal / 2 + [self pageWidth] * indexPath.row;
    }
    
    CGRect retVal = CGRectMake(posX,
                               _offset.vertical,
                               [self cardWidth],
                               self.collectionView.bounds.size.height - _offset.vertical * 2);

    
    return retVal;
}

#pragma mark - Properties

- (void)setOffset:(UIOffset)offset {
    _offset = offset;
    //invalidateLayout是重新调整布局
   [self invalidateLayout];
}

#pragma mark - Public

- (id)init {
    self = [super init];
    if (self) {
      [self setup];
        
        self.minimumLineSpacing = 10000.0f;
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}
/**
 *  A.prepareLayout方法将创建布局对象所需的内部数据结构
 */
- (void)prepareLayout{
    

    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForCardAtIndexPath:indexPath];
            
            NSString *key = [self keyForIndexPath:indexPath];
            cellLayoutInfo[key] = itemAttributes;
        }
    }
    
    newLayoutInfo[@"CellKind"] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
    

}
/**
 *  B.向布局对象请求内容大小->滚动区域大小
 */
#define WIDTH_MARGIN 30
- (CGSize)collectionViewContentSize {
    
    CGFloat CONTENT_WIDTH =[self pageWidth] * [self.collectionView numberOfItemsInSection:0] + _offset.horizontal+WIDTH_MARGIN;
    CGFloat CONTENT_HEIGHT=self.collectionView.bounds.size.height;
    CGSize retVal = CGSizeMake(CONTENT_WIDTH,CONTENT_HEIGHT);
    
    return retVal;
}
/**
 *  C.布局对象返回可视矩形区域内的所有元素的布局属性
 *
 *  @param rect 可视矩形的位置大小
 *
 *  @return 元素的布局属性数组
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
//    return allAttributes[self modifiedLayoutAttributesForElements:allAttributes];

    return allAttributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self keyForIndexPath:indexPath];
    UICollectionViewLayoutAttributes *retVal = self.layoutInfo[@"CellKind"][key];
    return retVal;
}

///**
// *  当视图滚动时候自动调用invalidateLayout 方法
// */
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}

/**
 
    保证视图在手指停止拖动时,停留在某个点(位置)
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    
    CGPoint retVal = proposedContentOffset;
    
    CGFloat rawPageValue = self.collectionView.contentOffset.x / [self pageWidth];

    //0.当前页
    CGFloat currentPage = 0;
    if (velocity.x > 0.0) {
        currentPage = floor(rawPageValue); //取不大于rawPageValue
    } else {
        currentPage = ceil(rawPageValue); //取不小于rawPageValue
    }
    
    //1.下一页
    CGFloat nextPage = 0;
    if (velocity.x > 0.0) {
        nextPage = ceil(rawPageValue);
    } else {
        nextPage = floor(rawPageValue);
    }
    
    //2.
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        
        //  Change UICollectionViewCell
        retVal.x = nextPage * [self pageWidth];
        
        if (nextPage != [self.collectionView numberOfItemsInSection:0]-1) {
            retVal.x = retVal.x - _offset.horizontal/2;
        }
        
    } else {
        //  Bounces
        CGFloat posX = round(rawPageValue) * [self pageWidth] - _offset.horizontal/2;
        posX = MAX(0, posX);
        retVal.x = posX;
    }
    
    return retVal;
}

- (CGFloat)flickVelocity {
    return 0.2;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqualToString:@"collectionView.contentOffset"]) {
        CGFloat floatPage = self.collectionView.contentOffset.x / [self pageWidth];
        NSInteger newPage = round(floatPage);
        if (_currentPage != newPage) {
            _currentPage = newPage;
        }
    }
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"collectionView.contentOffset"];
    } @catch (NSException * exception) {
        
    }
}
#pragma mark -移动代码


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(0,0);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = CGPointMake(0, 0);
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

@end
