//
//  SCNavTabBar.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCNavTabBar.h"
#import "SCNavCommonMacro.h"
#import "SCPopView.h"
#define SCNavTabbarBundleName           @"SCNavTabBar.bundle"
#define SCNavTabbarSourceName(file) [SCNavTabbarBundleName stringByAppendingPathComponent:file]
@interface SCNavTabBar () <SCPopViewDelegate>
{
    UIScrollView    *_navgationTabBar;      // all items on this scroll view
    UIView          *_line;                 // underscore show which item selected
    NSMutableArray  *_btnArray;                // SCNavTabBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
    UIButton        *_selectBtn;
}

@end

@implementation SCNavTabBar

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private Methods
- (void)setup{
    
    _btnArray = [NSMutableArray array];
    
    [self setupSubView];
    
}
-(void)setupSubView{
    CGFloat functionButtonX = SCREEN_WIDTH;
    
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, functionButtonX, NAV_TAB_BAR_HEIGHT)];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(15, NAV_TAB_BAR_HEIGHT - 3.0f, width - 30.0f, 1)];
    _line.backgroundColor = IS_SYSTEM_COLOR;
    [_navgationTabBar addSubview:_line];
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = DOT_COORDINATE;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, DOT_COORDINATE, [widths[index] floatValue], NAV_TAB_BAR_HEIGHT);
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:IS_SYSTEM_COLOR forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(button.width-2, button.height/4, 1, button.height/2)];
        line.image = [UIImage imageNamed:@"icon_line"];
        [button addSubview:line];
       
        
        [_navgationTabBar addSubview:button];
        
        [_btnArray addObject:button];
        buttonX += [widths[index] floatValue];
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    [self btnAction:_btnArray[0]];
    return buttonX;
}



- (void)btnAction:(UIButton *)button
{
    _selectBtn.selected = !_selectBtn.selected;
    button.selected = YES;
    _selectBtn = button;
    
    NSInteger index = [_btnArray indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
}


- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        NSNumber *width = [NSNumber numberWithFloat:size.width + 50];
        [widths addObject:width];
    }
    
    return widths;
}




#pragma mark -
#pragma mark - Public Methods


- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _btnArray[currentItemIndex];
    CGFloat flag = SCREEN_WIDTH;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            offsetX = offsetX + 40.0f;
        }
        
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, DOT_COORDINATE) animated:YES];
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(DOT_COORDINATE, DOT_COORDINATE) animated:YES];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _line.x = button.frame.origin.x + 15.0f;
    }];
}

- (void)updateData
{
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
    }
}


#pragma mark - SCFunctionView Delegate Methods
#pragma mark -
- (void)itemPressedWithIndex:(NSInteger)index
{
    [_delegate itemDidSelectedWithIndex:index];
}

@end

