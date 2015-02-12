//
//  EBCardCollectionViewLayout.h
//  Vindeo
//
//  Created by Ezequiel A Becerra on 7/11/14.
//  Copyright (c) 2014 Ezequiel A Becerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IS_CardLayout : UICollectionViewFlowLayout

@property (readonly) NSInteger currentPage;
@property (nonatomic, assign) UIOffset offset;
@property (nonatomic, strong) NSDictionary *layoutInfo;


@property (nonatomic, strong) NSIndexPath   *hiddenIndexPath;
@property (strong, nonatomic) NSIndexPath   *fromIndexPath;
@property (strong, nonatomic) NSIndexPath   *toIndexPath;
@end
