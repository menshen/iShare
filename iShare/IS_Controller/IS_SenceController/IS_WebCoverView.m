//
//  IS_WebCoverView.m
//  iShare
//
//  Created by wusonghe on 15/3/28.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_WebCoverView.h"
#import "IS_WebDetailView.h"

@interface IS_WebCoverView()<IS_WebDetailViewDelegate>

@end

@implementation IS_WebCoverView{
    IS_WebDetailView * _webDetailView;
    UIButton * _backBtn;
}

#define WEB_DETAIL_H 262
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCoverView];
        [self setupWebDetailView];
        [self setupBackBtn];
    }
    return self;
}
- (void)setupWebDetailView{
    
    NSString * name = NSStringFromClass([IS_WebDetailView class]);
    _webDetailView = [[NSBundle mainBundle]loadNibNamed:name owner:nil options:nil][0];
    _webDetailView.frame = CGRectMake(0, 0, ScreenWidth, WEB_DETAIL_H);
    _webDetailView.delegate = self;
    [self addSubview:_webDetailView];
}
- (void)setupBackBtn{

    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-60, 80, 80)];
    [_backBtn setImage:[UIImage imageNamed:@"home_bottom_tab"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(IS_WebDetailViewDidBackAction:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.hidden =YES;
    [self addSubview:_backBtn];
}

#pragma mark - 视图
- (void)setupCoverView{
    self.backgroundColor = Color(0, 0, 0, .01);

    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipe];
}
- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
    
    [self.delegate IS_WebCoverViewDidScroll:self];
    [UIView animateWithDuration:.9 animations:^{
//        _backBtn.y=;
        _backBtn.hidden = NO;
//        _webDetailView.y = -scr;
        self.y = -ScreenHeight+80;

    } completion:^(BOOL finished) {

    }];
    
}
-(void)IS_WebDetailViewDidBackAction:(id)result{
    
    [self.delegate IS_WebCoverViewDidBackAction:self];
}
-(void)setCaseModel:(IS_CaseModel *)caseModel{

    _caseModel = caseModel;
    _webDetailView.caseModel = caseModel;
}


@end
