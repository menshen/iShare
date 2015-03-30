#import "IS_CategoryView.h"

@interface IS_CategoryView()<UIScrollViewDelegate>
//@property (strong,nonatomic) UIScrollView   *scrollView;
@property (strong,nonatomic) UIView         *line;// underscore show which item selected
@property (strong,nonatomic) NSMutableArray *items;// SCNavTabBar pressed item
@property (strong,nonatomic) NSArray        *itemsWidth;// an array of items' width
@property (strong,nonatomic) UIButton       *selectedBtn;
@end

@implementation IS_CategoryView
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        _items = [NSMutableArray array];
        
       self.showsHorizontalScrollIndicator = NO;
//        self.delegate = self;

//        self.image = [UIImage resizedImage:@"IS_Toolbar_down"];
        
    }
    return self;

}



#pragma mark - 提示图

- (void)itemPressed:(UIButton *)button
{
    
    
    if (!_selectedBtn) {
        _selectedBtn = button;
    }

    
    _selectedBtn.selected = !_selectedBtn.selected;
    [_selectedBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    button.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1, 1);
        button.selected = YES;
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    }];
    _selectedBtn = button;

   

    
    
    
    NSInteger index =button.tag;
    _currentItemIndex = index;

    
  

}
#pragma mark - Public Methods
#pragma mark - ScrollView


- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    CGFloat flag = SCREEN_WIDTH;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            offsetX = offsetX + 40.0f;
        }
        
        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
        [self setContentOffset:CGPointMake(DOT_COORDINATE, 0) animated:YES];
    }
    [self itemPressed:button];

    
//    [UIView animateWithDuration:0.2f animations:^{
//        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue] - 4.0f, _line.frame.size.height);
//    }];
}
#pragma mark - 更新数据
- (void)updateData
{
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        self.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
        self.contentOffset = CGPointMake(0, 0);

    }
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
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        [self addSubview:button];
        
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
    }
    
//    [self setupScrollViewWithWidth:[widths[0] floatValue]];
    [self itemPressed:_items[0]];
    return buttonX;
}
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        NSNumber *width = [NSNumber numberWithFloat:size.width + 35.0f];;//@(ScreenWidth/titles.count);
//
        [widths addObject:width];
    }
    
    return widths;
}
//#pragma mark - FunctionView Delegate Methods
//#pragma mark -
//- (void)itemPressedWithIndex:(NSInteger)index
//{
//    [_delegate itemDidSelectedWithIndex:index];
//}

@end
