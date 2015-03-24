#import "IS_LoginController.h"
#import "IS_RegisterViewController.h"
@interface IS_LoginController()

@end

@implementation IS_LoginController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view becomeFirstResponder];
    [self TransitionViewController:CGAffineTransformIdentity];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

   
        self.curTextField =textField;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, - self.loginBtn.height-(iPhone4_4S?90:20));
        [self TransitionViewController:transform];
        return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self TransitionViewController:CGAffineTransformIdentity];

    
    
}
-(void)TransitionViewController:(CGAffineTransform)transform{

    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.view.transform = transform;
                     }
                     completion:NULL];
    
}
- (IBAction)loginBtnAction:(UIButton *)sender {
}

- (IBAction)wechatBtnAction:(UIButton *)sender {
}
- (IBAction)forgetPasswordBtnAction:(UIButton *)sender{
    

//    IS_RegisterViewController * r = [[IS_RegisterViewController alloc]init];
//    [self.navigationController pushViewController:r animated:YES];
}
@end
