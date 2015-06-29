//
//  IS_EditOperatingView.m
//  iShare
//
//  Created by 伍松和 on 15/3/19.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditBottomView.h"
#import "IS_Button.h"

#define CREATE_BTN_WIDTH 70



#define BOTTOM_BTN_WIDTH ScreenWidth/5
#define BOTTOM_BTN_HEIGHT
#define IMG_KEY @"img"
#define TITLE_KEY @"title"

@interface IS_EditBottomView()

/**
 *  可以滚动的操作条
 */
@property (strong,nonatomic)UIScrollView * scrollView;
/**
 *  生成按钮
 */
@property (strong,nonatomic)IS_Button * createBtn;
@end

@implementation IS_EditBottomView{
    NSMutableArray * _btnArray;
}
-(instancetype)initWithFrame:(CGRect)frame
                    btnBlock:(IS_BottomEditViewBtnBlock)btnBlock{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];

        self.btnBlock = btnBlock;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
       
    }
    return self;
}
-(void)setup{

    self.userInteractionEnabled =YES;
    
    self.image = [UIImage resizedImage:@"IS_Toolbar_up"];
    
    [self setupScrollView];
    
    [self setupCreateBtn];
}
-(void)setupScrollView{
    
    [self addSubview:self.scrollView];
    _btnArray = [NSMutableArray array];
    NSArray * btn_array = @[@{IMG_KEY:@"bottom_add_icon",TITLE_KEY:@"加页"},
                            @{IMG_KEY:@"bottom_trash_icon",TITLE_KEY:@"减页"},
                            @{IMG_KEY:@"bottom_menu_icon",TITLE_KEY:@"总览"},
                            @{IMG_KEY:@"bottom_muisc_icon",TITLE_KEY:@"音乐"}];
    
    
    for (int i =0; i <btn_array.count; i++) {
        CGRect frame =CGRectMake(i*BOTTOM_BTN_WIDTH, 0, BOTTOM_BTN_WIDTH, self.height);
        IS_Button * bottomBtn = [[IS_Button alloc]initWithFrame:frame ButtonPositionType:ButtonPositionTypeBothCenter];
        [bottomBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [bottomBtn setTitle:btn_array[i][TITLE_KEY] forState:UIControlStateNormal];
        [bottomBtn setImage:[UIImage imageNamed:btn_array[i][IMG_KEY]] forState:UIControlStateNormal];
        [bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.tag = i;
        [_btnArray addObject:bottomBtn];
        [self.scrollView addSubview:bottomBtn];
        
    }
    
    
}
- (void)setupCreateBtn{
    
    [self addSubview:self.createBtn];
}

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width - CREATE_BTN_WIDTH  , self.height)];
        _scrollView.contentSize = CGSizeMake(self.width, self.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;

}
-(UIButton *)createBtn{
    
    if (!_createBtn) {
        CGRect frame =CGRectMake(self.width-CREATE_BTN_WIDTH, 1, CREATE_BTN_WIDTH, self.height-1);
        _createBtn = [[IS_Button alloc]initWithFrame:frame ButtonPositionType:ButtonPositionTypeBothCenter];
        [_createBtn setImage:[UIImage imageNamed:@"bottom_done_icon"] forState:UIControlStateNormal];
        [_createBtn setTitle:@"生成" forState:UIControlStateNormal];
        [_createBtn setTitleColor:IS_SYSTEM_COLOR forState:UIControlStateNormal];
        _createBtn.backgroundColor = kColor(250, 250, 250);
        [_createBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _createBtn.tag = IS_BottomEditViewButtonTypeDone;
         [_createBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;

}

- (void)bottomBtnAction :(UIButton *)btn {
    
    if (self.btnBlock) {
        self.btnBlock(btn);
    }

}

#pragma mark - 禁止
- (void)IS_BottomEditViewButtonEnableState:(BOOL)isEnable
                                       tag:(NSInteger)tag{
    IS_Button * bottomBtn =(IS_Button*)_btnArray[tag];
    bottomBtn.enabled = isEnable;
}
@end
