#import "IS_LoginController.h"
#import "IS_RegisterViewController.h"
#import "WXApi.h"
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

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

   
        self.curTextField =textField;
//        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, - self.loginBtn.height-(iPhone4_4S?90:20));
//        [self TransitionViewController:transform];
        return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.scrollView endEditing:YES];
//    [self TransitionViewController:CGAffineTransformIdentity];

    
    
}
- (IBAction)dismissBtnAction:(id)sender {
    [self.scrollView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginBtnAction:(UIButton *)sender {
  //  [self sendAuthRequest];

}

#define WX_SCOPE @"snsapi_userinfo,snsapi_base"
- (IBAction)wechatBtnAction:(UIButton *)sender {
    
   [self sendAuthRequest];
    
}
-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope =WX_SCOPE;
    req.state = @"9999" ;
    [WXApi sendReq:req];
}

- (IBAction)forgetPasswordBtnAction:(UIButton *)sender{
    

//    IS_RegisterViewController * r = [[IS_RegisterViewController alloc]init];
//    [self.navigationController pushViewController:r animated:YES];
}
@end
