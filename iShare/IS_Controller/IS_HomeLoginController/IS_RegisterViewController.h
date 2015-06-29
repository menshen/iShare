

@interface IS_RegisterViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *getSmsCodeBtn;


- (IBAction)registerBtnAction:(UIButton *)sender;
- (IBAction)smsCodeBtnAction:(UIButton *)sender;

@end
