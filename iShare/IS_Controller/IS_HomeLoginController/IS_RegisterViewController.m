

#import "IS_RegisterViewController.h"

@interface IS_RegisterViewController ()

@end

@implementation IS_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    
   

}
- (void)setupSubTextField{
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view becomeFirstResponder];

}
- (IBAction)registerBtnAction:(UIButton *)sender {
}
- (IBAction)smsCodeBtnAction:(UIButton *)sender{
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    if([textField isEqual:self.passwordTextField]){
    
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                             self.view.transform = CGAffineTransformMakeTranslation(0, - self.registerBtn.height-5);
                         }
                         completion:NULL];
        return YES;

    }
    return YES;
        //        [_curTextField becomeFirstResponder];
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.view.transform = CGAffineTransformIdentity;;
                     }
                     completion:NULL];

    
}
@end
