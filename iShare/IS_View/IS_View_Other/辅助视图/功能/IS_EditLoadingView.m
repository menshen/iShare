//
//  IS_LoadingView.m
//  iShare
//
//  Created by 伍松和 on 15/3/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditLoadingView.h"

@interface IS_EditLoadingView()


@end

@implementation IS_EditLoadingView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //0.
        self.backgroundColor = Color(0, 0, 0, 0.3);
        
        //1.
        [self addSubview:self.loadingView];
        
        //2.
        [self addSubview:self.refreshBtn];
    }
    return self;
}

-(RTSpinKitView *)loadingView{
    
    if (!_loadingView) {
        _loadingView = [[RTSpinKitView alloc]initWithStyle:RTSpinKitViewStylePulse color:IS_SYSTEM_COLOR];
        _loadingView.frame = CGRectMake(0, 0, 20, 20);
        _loadingView.center = CGPointMake(self.width/2, self.height/2);
        _loadingView.hidden = YES;
       
        
    }
    return _loadingView;
}
-(UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.frame = CGRectMake(0, 0, 20, 20);
        _refreshBtn.center = CGPointMake(self.width/2, self.height/2);
        _refreshBtn.hidden = YES;
        [_refreshBtn addTarget:self action:@selector(refreshBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}
#pragma mark - 重新上传
-(void)refreshBtnAction:(UIButton*)btn{
    
    
}

#pragma mark - 展示隐藏 loading
-(void)showLoading{
    
    self.hidden = NO;
    _loadingView.hidden=NO;
    [_loadingView startAnimating];
    

}
- (void)hideLoading{
    self.hidden = YES;
    _loadingView.hidden=YES;
    [_loadingView stopAnimating];
}
@end
