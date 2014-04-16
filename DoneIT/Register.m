//
//  Register.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "Register.h"
#import "constants.h"
#import "AFHTTPRequestOperationManager.h"
#import "User.h"


@interface Register ()
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextFiled;

@end

@implementation Register

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = APP_LIGHT_GREEN_COLOR;
    [self createEmailView];
    self.sendButton.layer.cornerRadius = 5.0f;
    self.sendButton.backgroundColor = APP_LIGHT_GREEN_COLOR;
    [self.sendButton setTitleColor:APP_YELLOW_COLOR forState:UIControlStateNormal];
    self.emailTextFiled.layer.cornerRadius = 5.0f;
}
- (IBAction)sendButtonPressed:(id)sender {
    BOOL isEmailValied = [self validateEmail:self.emailTextFiled.text];
    if (isEmailValied) {
        Settings *settings = [[Settings alloc]init];
        settings.delegate = self;
        [self presentViewController:settings animated:NO completion:nil];
        
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invaled Email"
                                                        message:@"please check your email address"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}



-(void)createEmailView {
    self.emailView.layer.cornerRadius = 5.0f;
}



- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)SettingsViewControllerDidPressedOnDoneButton:(Settings *)controller{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    email": "gilsilas@gmail.com",
//    "university": "IDC",
//    "major": "CS",
//year: 2
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailTextFiled.text, @"email", controller.currentUserUni, @"university",controller.currentUserMajor,@"major",controller.currentUserYear,@"year", nil];
    [manager POST:@"http://doitapi.herokuapp.com/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        User *user = [[User alloc]init];
        user.token = [responseObject objectForKey:@"token"];
        [user save];
        [controller dismissViewControllerAnimated:NO completion:nil];
        [self performSegueWithIdentifier:@"StartApp" sender:self];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

-(void)SettingsViewControllerDidPressedOnCancelButton:(Settings *)controller{
    
}
@end
