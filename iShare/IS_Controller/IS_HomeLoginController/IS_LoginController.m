#import "IS_LoginController.h"
#import "IS_RegisterViewController.h"
#import "KVNProgress.h"
#import "IS_AccountModel.h"

@interface IS_LoginController()

@end

@implementation IS_LoginController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"登录";

   
    
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.scrollView addGestureRecognizer:_tap];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height);
    
    
    
}
#pragma mark -键盘状态
-(UIViewAnimationOptions)RDRAnimationOptionsForCurve:(UIViewAnimationCurve)curve{
    
    return (curve << 16 | UIViewAnimationOptionBeginFromCurrentState);
    
}
- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger ainimation = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    ainimation= [self RDRAnimationOptionsForCurve:ainimation];
    
    [UIView animateWithDuration:duration-0.1
                          delay:0.0
                        options:ainimation
                     animations:^{
                         if (self.curTextField==self.passwordTextField&&ScreenHeight<=480&&self.scrollView.contentOffset.y==0) {
                             
                             self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y+65);
                         }
                     }
                     completion:NULL];
    
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    
    self.scrollView.contentOffset = CGPointZero;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

#pragma mark - 手动
- (void)tapAction:(id)tap{
    [self.scrollView endEditing:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.scrollView endEditing:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    self.curTextField =textField;
    return YES;
    
}

- (IBAction)loginBtnAction:(UIButton *)sender {

  

    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.view endEditing:YES];
    [self.scrollView endEditing:YES];
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    
  
    [KVNProgress showWithParameters:@{KVNProgressViewParameterSuperview:self.view,
                                      KVNProgressViewParameterStatus:@"正在登陆.."}];
//    [KVNProgress showWithStatus:@"正在登陆..."];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary * params = @{PHONE_KEY:self.phoneTextField.text,
                                  PWD_KEY:self.passwordTextField.text};
        
        
        [HttpTool postWithPath:LOGIN_API params:params success:^(id result) {
            
            NSLog(@"result:%@",result);
            if ([result[RET_MSG] boolValue]) {
                NSString * token = result[DATA_KEY][TOKEN];
                
                IS_AccountModel * account = [[IS_AccountModel alloc]init];
                account.token = token;
                account.account_id = [NSDate getTimeStampLong:[NSDate date]];
                [IS_AccountModel insertModelToDB:account condition:nil didInsertBlock:nil];
                [KVNProgress showSuccessWithStatus:@"成功登陆"];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else{
                [KVNProgress showErrorWithStatus:@"登陆失败"];

            }
            

//                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            [self dismissViewControllerAnimated:YES completion:^{
//                [self removeFromParentViewController];
//
//            }];
            
            
        } failure:^(NSError *error) {
            [KVNProgress showErrorWithStatus:@"登陆失败"];
        }];
    });
    
    

}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}


- (IBAction)forgetPasswordBtnAction:(UIButton *)sender{
    

}
@end
