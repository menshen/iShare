
#import "IS_TextActionSheet.h"



@interface IS_TextActionSheet()<UITextViewDelegate>


@property (strong,nonatomic)UITextView * textView;
@property (strong,nonatomic)UIImageView * inputToolView;
@property (strong,nonatomic)UIButton * doneBtn;
@property (strong,nonatomic)UIView * contentView;
@end

@implementation IS_TextActionSheet
#define INPUT_VIEW_H 70
#define TEXT_VIEW_MARGIN 20
#define TEXT_HEIGHT 50
#define DONE_BTN_W  TEXT_HEIGHT
#define DONE_BTN_H  TEXT_HEIGHT
#define CREATE_SHEET_H 215




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color(0, 0, 0, 0);
        [self setupEditView];

    }
    return self;
}
- (void)setupActionSheet{
}
#pragma mark - 编辑

- (void)setupEditView{
    [self setupInputToolView];
    [self setupTextView];
    [self setupDoneBtn];
    [self addNotification];
    
}
#pragma mark - 生成
- (void)setupCreateView{

    [self addNotification];
    
}


#pragma mark - 输入背景
- (void)setupInputToolView{
    _inputToolView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, INPUT_VIEW_H)];
    _inputToolView.backgroundColor = IS_SYSTEM_WHITE_COLOR;
    _inputToolView.userInteractionEnabled = YES;
    [self addSubview:_inputToolView];

   
    
    
}

#pragma mark - 完成按钮
- (void)setupDoneBtn{
    
    _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(_textView.right, _textView.y, DONE_BTN_W, DONE_BTN_H)];
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [_inputToolView addSubview:_doneBtn];

}
#pragma mark - 上传图片


#pragma mark - 输入视图

- (UITextView*)textView{
    
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(TEXT_VIEW_MARGIN, TEXT_VIEW_MARGIN/2, ScreenWidth-DONE_BTN_W-TEXT_VIEW_MARGIN, TEXT_HEIGHT);
        _textView.userInteractionEnabled = YES;
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.textColor = [UIColor blackColor];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate =self;
    }
    return _textView;
}
- (void)setupTextView
{
    [_inputToolView addSubview:self.textView];
    
}
- (void)addNotification{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:_textView];

}
#pragma mark - 完成输入
- (void)doneAction:(id)sender{
    [self dismissActionSheet];
    if (self.inputDoneBlock) {
        self.inputDoneBlock(_textView.text);

    }

}
#pragma mark - 输入状态
- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification{
        UITextView *textView = (UITextView *)notification.object;
    if (self.inputIngBlock) {
        self.inputIngBlock(textView.text);

    }

    
}



#pragma mark -键盘状态

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger ainimation = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    ainimation= [self RDRAnimationOptionsForCurve:ainimation];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    
    [UIView animateWithDuration:duration-0.1
                          delay:0.0
                        options:ainimation
                     animations:^{
                         [_inputToolView setFrame:CGRectMake(0,  ScreenHeight-rect.size.height-INPUT_VIEW_H, ScreenWidth, INPUT_VIEW_H)];
                         
                         
                     }
                     completion:NULL];
    
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    
    
    [self dismissActionSheet];
}
-(UIViewAnimationOptions)RDRAnimationOptionsForCurve:(UIViewAnimationCurve)curve{
    
    return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
    
}
#pragma mark - 展示与消失
- (void)showActionSheetAtView:(UIView *)view
                    PlaceText:(NSString *)placeText
               inputDoneBlock:(IS_TextActionSheetInputDoneBlock)inputDoneBlock
                inputIngBlock:(IS_TextActionSheetInputIngBlock)inputIngBlock
             imageUploadBlock:(IS_TextActionSheetImageUploadBlock)imageUploadBlock{
    
    self.inputDoneBlock = inputDoneBlock;
    self.inputIngBlock = inputIngBlock;
    self.imageUploadBlock = imageUploadBlock;

    _contentView=view;
    self.textView.text = placeText;
    [self.textView becomeFirstResponder];
    [super showActionSheetAtView:view actonSheetBlock:nil];
    
    
}
- (void)dismissActionSheet{
    
    [UIView animateWithDuration:.25 animations:^{
        [_inputToolView setFrame:CGRectMake(0, ScreenHeight,ScreenWidth,INPUT_VIEW_H)];
        [_textView resignFirstResponder];
        _contentView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [[NSNotificationCenter defaultCenter]removeObserver:self];
        }
    }];
    
    [super dismissActionSheet];
    
}

@end
