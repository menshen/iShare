//
//  IS_ImageEditOperationView.h
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol IS_ImageEditOperationViewDelegate <NSObject>

-(void)IS_ImageEditOperationViewDidBtnAction:(id)result;

@end

@interface IS_ImageEditView : UIView

@property (nonatomic,weak)id<IS_ImageEditOperationViewDelegate>delegate;

@end
