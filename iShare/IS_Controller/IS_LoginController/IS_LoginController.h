

@interface IS_LoginController : UIViewController<UITextFieldDelegate>
@property (weak,nonatomic)IBOutlet UIScrollView * scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *companyIconView;
@property (weak, nonatomic) IBOutlet UIView *textFieldBackgroudView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatLoginBtn;
@property (weak ,nonatomic) IBOutlet UIButton * dismissBtn;

- (IBAction)forgetPasswordBtnAction:(UIButton *)sender;
- (IBAction)loginBtnAction:(UIButton *)sender;
- (IBAction)wechatBtnAction:(UIButton *)sender;


@property (nonatomic,strong)UITextField * curTextField;

@end
