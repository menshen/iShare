//
//  IS_TemplateActonSheet.m
//  iShare
//
//  Created by wusonghe on 15/3/24.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_TemplateActonSheet.h"
#import "IS_TemplateActionSheetCell.h"

@interface IS_TemplateActonSheet()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIWindow *actionsheetWindow;
@property (nonatomic, strong) UIWindow *oldKeyWindow;
@property (nonatomic,strong)UIViewController * rootController;

@end

@implementation IS_TemplateActonSheet
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setupSCollectionView];
        [self setupActionSheet];
        
        self.c_datasource = [NSMutableArray arrayWithArray:@[@"11",@"11",@"11",@"11",@"11",@"11"]];
    }
    return self;
}
#pragma mark - UIWindow

- (void)setupSCollectionView{

    self.commonLayout.itemSize = CGSizeMake(IS_TEMPLATE_ITEM_WIDTH,IS_TEMPLATE_ITEM_HEIGHT);
    self.commonLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.commonLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self.collectionView setCollectionViewLayout:self.commonLayout];
    NSString * classStr = NSStringFromClass([IS_TemplateActionSheetCell class]);
    UINib * nib = [UINib nibWithNibName:classStr bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:classStr];
    [self.collectionView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth,ScreenHeight-200)];

    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellID = NSStringFromClass([IS_TemplateActionSheetCell class]);
    IS_TemplateActionSheetCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - ActionSheet

#pragma mark - 显示
- (void)setupActionSheet{

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    self.backgroundColor = Color(0, 0, 0, 0.6);
    [UIView animateWithDuration:.25 animations:^{
        
        [self.collectionView setFrame:CGRectMake(0, 100, ScreenWidth,ScreenHeight-200)];
    } completion:^(BOOL finished) {
    }];

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

- (void)showAnimationAtContainerView:(UIView *)containerView
                actonSheetBlock:(IS_ActonSheetBlock)actonSheetBlock{
    
    
    self.actonSheetBlock = actonSheetBlock;
    UIView * view =  [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [view addSubview:self];
    
}
#pragma mark - 关闭
- (void)dismiss{
    
    [UIView animateWithDuration:.25 animations:^{
        [self.collectionView setFrame:CGRectMake(0, ScreenHeight,ScreenWidth, ScreenHeight-200)];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


@end
