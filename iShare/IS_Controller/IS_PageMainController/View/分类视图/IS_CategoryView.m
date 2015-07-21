#import "IS_CategoryView.h"

@interface IS_CategoryView()<UIScrollViewDelegate>
@property (strong,nonatomic)UIView         *containView;
@property (strong,nonatomic)UIView         *line;// underscore show which item selected
@property (strong,nonatomic)NSMutableArray *items;// SCNavTabBar pressed item
@property (strong,nonatomic)NSArray        *itemsWidth;// an array of items' width
@property (strong,nonatomic)UIButton       *selectedBtn;
@property (strong,nonatomic)UIView         *itemsView;

@end

@implementation IS_CategoryView
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.containView];
  
        
    }
    return self;

}
-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}
#pragma mark - 底部视图
#define CONTAIN_X 100*0.5

-(UIView *)containView{
    
    if (!_containView) {
        _containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width-CONTAIN_X*2, self.height)];
//        _containView.backgroundColor = [UIColor redColor];
    }
    return _containView;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.containView.centerX=(self.centerX-20);

}
#pragma mark - 提示图
#define BTN_MARGIN 50
#define LINE_MARGIN BTN_MARGIN-70
#define BTN_FONT IS_ARIAL_BOLD_FONT(19)

- (void)itemPressed:(UIButton *)button
{
    
    
    if (!_selectedBtn) {
        _selectedBtn = button;
    }

    
    _selectedBtn.selected = !_selectedBtn.selected;
    [_selectedBtn.titleLabel setFont:BTN_FONT];
    button.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1, 1);
        button.selected = YES;
        [button.titleLabel setFont:BTN_FONT];
    }];
    _selectedBtn = button;

   

    
    if (self.didBtnSelectBlock) {
        self.didBtnSelectBlock(button);
    }
    
    NSInteger index =button.tag;
    _currentItemIndex = index;

    
    [UIView animateWithDuration:0.2f animations:^{
        _line.x = _selectedBtn.x;
    }];
    
    
  

}
#pragma mark - Public Methods
#pragma mark - ScrollView


- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    if (currentItemIndex>2) {
        return;
    }
    UIButton *button = _items[currentItemIndex];
    CGFloat flag = SCREEN_WIDTH;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
           // offsetX = offsetX + 80.0f;
        }
        
//        [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
//        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (!_selectedBtn) {
        _selectedBtn = button;
    }
    
    
    _selectedBtn.selected = !_selectedBtn.selected;
    [_selectedBtn.titleLabel setFont:BTN_FONT];
    button.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1, 1);
        button.selected = YES;
        [button.titleLabel setFont:BTN_FONT];
    }];
    _selectedBtn = button;
    
    [UIView animateWithDuration:0.2f animations:^{
        
       
        _line.x =  _selectedBtn.x;//_currentItemIndex*_line.width;
    }];
}
#pragma mark - 更新数据
- (void)updateData
{
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    CGFloat btnW = [_itemsWidth[0] floatValue];
    self.line= [[UILabel alloc]initWithFrame:CGRectMake(0, self.height, btnW, 3)];
    self.line.backgroundColor = [UIColor clearColor];
    
    UIView * interLine = [[UIView alloc]initWithFrame:CGRectMake(btnW/4, -3-(iPhone6_6PLUS?5:0), btnW/(iPhone6_6PLUS?2:1.5), 3)];
    interLine.backgroundColor = [UIColor colorWithHexString:@"27b8f3"];
    interLine.centerX = self.line.centerX;
    [self.line addSubview:interLine];
    

    
   // [self.containView addSubview:self.line];
    
    if (_itemsWidth.count)
    {
        [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
//        self.contentSize = CGSizeMake(contentWidth, 0);
//        self.contentOffset = CGPointMake(0, 0);

    }
    
    [self setCurrentItemIndex:0];
}
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake([widths[index] floatValue]*index, 0, [widths[index] floatValue], self.height);
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        
        
        [button setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"27b8f3"] forState:UIControlStateSelected];
        button.titleLabel.font = BTN_FONT;
      
        
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        [self.containView addSubview:button];
        
        [self.items addObject:button];
        
        
        
        
    }
    
//    [self setupScrollViewWithWidth:[widths[0] floatValue]];
    [self itemPressed:_items[0]];
    return 0;
}
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
      //  CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
//        NSNumber *width = [NSNumber numberWithFloat:size.width +(iPhone6_6PLUS?45:40)];;//@(ScreenWidth/titles.count);
//
        NSNumber *width = @((self.width-CONTAIN_X*2)/_itemTitles.count);
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
