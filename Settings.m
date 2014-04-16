//
//  Settings.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "Settings.h"
#import "constants.h"
#import "PickerDS.h"
#import "AFHTTPRequestOperationManager.h"
@interface Settings ()
@property (strong,nonatomic) UIButton *majorButton;
@property (strong,nonatomic) UIButton *yearButton;
@property (strong,nonatomic) UIButton *uniButton;
@property (strong,nonatomic) UINavigationBar *VCnavigationBar;
@property (strong,nonatomic) NSMutableArray *dataArr;
@property (strong,nonatomic) UIPickerView *UniPicker;
@property (strong,nonatomic) UIPickerView *majorPicker;
@property (strong,nonatomic) UIPickerView *yearPicker;
@property (strong,nonatomic) UIPickerView *currentPicker;
@property (strong,nonatomic)  UIToolbar *pickertoolbar;
@property (strong,nonatomic) UIBarButtonItem *doneButton;




@end

@implementation Settings

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
    [self createButtons];
    [self createNavigiyonBar];
    [self getDataFromServer];
    
    // Do any additional setup after loading the view.
}
#pragma data handling
#define NAME @"name"
#define MAJORS @"majors"
-(void)getDataFromServer {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://doitapi.herokuapp.com/universities" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:responseObject];
        self.dataArr = arr;

        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
  //  NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:re];
    
//    NSArray * subjectArr = [[NSArray alloc]initWithObjects:@"CS",@"law",@"arts", nil];
//    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"IDC", NAME, subjectArr, @"majors", nil];
//    [arr addObject:dict1];
//    
//    NSArray * subjectArr2 = [[NSArray alloc]initWithObjects:@"one",@"two",@"3", nil];
//    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"TEL-AVIV", NAME, subjectArr2, @"majors", nil];
//    
//    [arr addObject:dict2];
  //  self.dataArr = arr;
    
    
}

-(NSArray *)getUniverstyArr{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.dataArr count]; i ++) {
        NSDictionary *cureentDict = [self.dataArr objectAtIndex:i];
        NSString *cureentUni = [cureentDict objectForKey:NAME];
        [result addObject:cureentUni];
    }
    
    return result;
}

-(NSArray *)getArryOfSubjectsFromCureentUni{
    for (int i = 0; i < [self.dataArr count]; i++) {
        NSDictionary *cureentDict = [self.dataArr objectAtIndex:i];
        NSString *cureentUni = [cureentDict objectForKey:NAME];
        if ([cureentUni isEqualToString:self.currentUserUni]) {
            return [cureentDict objectForKey:MAJORS];
        }
        
    }
    return nil;
}

-(NSArray *)getArrOfyers {
    NSArray * years = [[NSArray alloc]initWithObjects:@"First year",@"Second year",@"Third year",@"Fourth year",@"Fifth year", nil];
    return years;
}
#pragma mark - create Buttons
#define BUTTON_WIDTH 200
#define BUTTON_HEIGHT 60
#define BUTTON_SPACE 30
-(void)createButtons {
    [self createUniButton];
    [self createMajorButton];
    [self createYear];
}


-(void)createMajorButton {
    float x = (self.view.bounds.size.width - BUTTON_WIDTH) * 0.5;
    float y = self.uniButton.frame.origin.y + self.uniButton.frame.size.height + BUTTON_SPACE;
    CGRect frame = CGRectMake(x, y,BUTTON_WIDTH , BUTTON_HEIGHT);
    UIButton *majorButton =[[UIButton alloc]initWithFrame:frame];
    
    [majorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [majorButton setTitle:@"Selset Your major" forState:UIControlStateNormal];
    //[badgeButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 0.f, 0.0f, 0.0f)];
    majorButton.titleLabel.numberOfLines = 1;
    [majorButton addTarget:self action:@selector(majorButtonHadBeenClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:majorButton];
    majorButton.layer.cornerRadius = 5.0f;
    self.majorButton = majorButton;
    self.majorButton.backgroundColor = [UIColor whiteColor];
    self.majorButton.enabled = NO;
    self.majorButton.alpha = 0.7;
}

#define Picker_HEIGHT 200
-(void)majorButtonHadBeenClicked:(UIButton *)button {
    
    self.majorPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - Picker_HEIGHT, 320, Picker_HEIGHT + 20)];
    
    
    PickerDS *pickerDs = [[PickerDS alloc]initWithArr:[self getArryOfSubjectsFromCureentUni]];
    self.majorPicker.delegate = self;
    self.majorPicker.dataSource = pickerDs;
    self.majorPicker.backgroundColor = [UIColor whiteColor];
    self.currentPicker = self.majorPicker;
    
    [self.view addSubview:self.majorPicker];
    [self showTollBar];
    
    [self disableAllViewsExceptFromCurrentViews];
    
}

-(void)createYear {
    float x = (self.view.bounds.size.width - BUTTON_WIDTH) * 0.5;
    float y = self.majorButton.frame.origin.y + self.majorButton.frame.size.height + BUTTON_SPACE;
    CGRect frame = CGRectMake(x, y,BUTTON_WIDTH , BUTTON_HEIGHT);
    UIButton *yearButton =[[UIButton alloc]initWithFrame:frame];
    
    [yearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yearButton setTitle:@"Year in Uni" forState:UIControlStateNormal];
    //[badgeButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 0.f, 0.0f, 0.0f)];
    yearButton.titleLabel.numberOfLines = 1;
    [yearButton addTarget:self action:@selector(yearButtonHadBeenClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:yearButton];
    yearButton.layer.cornerRadius = 5.0f;
    self.yearButton = yearButton;
    self.yearButton.backgroundColor = [UIColor whiteColor];
    self.yearButton.enabled = NO;
    self.yearButton.alpha = 0.7;
}

-(void)yearButtonHadBeenClicked:(UIButton *)button {
    
    
    self.yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - Picker_HEIGHT, 320, Picker_HEIGHT + 20)];
    
    PickerDS *pickerDs = [[PickerDS alloc]initWithArr:[self getArrOfyers]];
    self.yearPicker.dataSource = pickerDs;
    self.yearPicker.delegate = self;
    self.yearPicker.backgroundColor = [UIColor whiteColor];
    self.currentPicker = self.yearPicker;
    
    [self.view addSubview:self.yearPicker];
    [self showTollBar];
    
    [self disableAllViewsExceptFromCurrentViews];

    
}

-(void)createUniButton{
    float x = (self.view.bounds.size.width - BUTTON_WIDTH) * 0.5;
    float y = 100;
    CGRect frame = CGRectMake(x, y,BUTTON_WIDTH , BUTTON_HEIGHT);
    UIButton *uniButton =[[UIButton alloc]initWithFrame:frame];
    
    [uniButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uniButton setTitle:@"Select your university" forState:UIControlStateNormal];
    //[badgeButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0f, 0.f, 0.0f, 0.0f)];
    uniButton.titleLabel.numberOfLines = 1;
    [uniButton addTarget:self action:@selector(uniButtonHadBeenClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:uniButton];
    uniButton.layer.cornerRadius = 5.0f;
    self.uniButton = uniButton;
    self.uniButton.backgroundColor = [UIColor whiteColor];
    
}

-(void)uniButtonHadBeenClicked:(UIButton *)button {
    
    self.UniPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - Picker_HEIGHT, 320, Picker_HEIGHT + 20)];
    
    PickerDS *pickerDs = [[PickerDS alloc]initWithArr:[self getUniverstyArr]];
    self.UniPicker.dataSource = pickerDs;
    self.UniPicker.delegate = self;
    self.UniPicker.backgroundColor = [UIColor whiteColor];
    self.currentPicker = self.UniPicker;
    
    [self.view addSubview:self.UniPicker];
    [self showTollBar];
    
    [self disableAllViewsExceptFromCurrentViews];
}




#pragma mark - NavigiyonBar
-(void)createNavigiyonBar {
    self.navigationController.navigationBar.tintColor = [UIColor redColor];

    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0,0.0,self.view.frame.size.width,60)];
    [navigationBar setBackgroundColor: [UIColor whiteColor]];
    
    [navigationBar setBarStyle:UIBarStyleDefault];
    [navigationBar setTranslucent:YES];
    
    UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@"Settings"];
    
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:
                                  @selector(DoneButtonPressed)];
    
    setButton.enabled = NO;
    self.doneButton = setButton;
    
    UIBarButtonItem *CancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:
                                     @selector(cancelButtonPressed)];
    
    CancelButton.tintColor = [UIColor blackColor];
    [aNavigationItem setLeftBarButtonItem:CancelButton];
    [aNavigationItem setRightBarButtonItem:setButton];
    
    [navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
    
    
    [[self view] addSubview:navigationBar];
    self.VCnavigationBar = navigationBar;
    
}

-(void)DoneButtonPressed {
    NSString *result = [NSString stringWithFormat:@" %@\n %@\n %@\n",self.currentUserUni,self.currentUserMajor,self.currentUserYear];
    NSLog(@" %@",result);
    [self.delegate SettingsViewControllerDidPressedOnDoneButton:self];
}


-(void)cancelButtonPressed {
    [self.delegate SettingsViewControllerDidPressedOnCancelButton:self];
    
}


#pragma Picker view avents
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *result;
    if (pickerView == self.UniPicker) {
        NSArray * a = [self getUniverstyArr];
        result =  [a objectAtIndex:row];
    }else if(pickerView == self.majorPicker){
        NSArray *a = [self getArryOfSubjectsFromCureentUni];
        result =  [a objectAtIndex:row];
    }else if (pickerView == self.yearPicker) {
        NSArray *a = [self getArrOfyers];
        result =  [a objectAtIndex:row];

    }
    
    return result;
}

-(void)donePicking{
    [self.pickertoolbar removeFromSuperview];
    [self.currentPicker removeFromSuperview];
    [self parsePickerData];
    [self enableAllviews];
    
    if (self.currentUserMajor && self.currentUserUni && self.currentUserYear) {
        self.doneButton.enabled = YES;
    }
}

-(void)parsePickerData {
    if (self.currentPicker == self.UniPicker) {
        self.majorButton.enabled = YES;
        self.majorButton.alpha = 1.0;
        
        NSInteger row = [self.UniPicker selectedRowInComponent:0];
        self.currentUserUni = [[self getUniverstyArr]objectAtIndex:row];
        
        [self.uniButton setTitle:self.currentUserUni forState:UIControlStateNormal];
        
    }else if (self.currentPicker == self.majorPicker) {
        NSInteger row = [self.majorPicker selectedRowInComponent:0];
        self.currentUserMajor = [[self getArryOfSubjectsFromCureentUni]objectAtIndex:row];
        
        self.yearButton.enabled = YES;
        self.yearButton.alpha = 1.0;
        
        [self.majorButton setTitle:self.currentUserMajor forState:UIControlStateNormal];

    }else if (self.currentPicker == self.yearPicker) {
        NSInteger row = [self.yearPicker selectedRowInComponent:0];
        self.currentUserYear = [NSString stringWithFormat:@"%d",row + 1];
        NSString* yearForButton = [[self getArrOfyers]objectAtIndex:row];
        [self.yearButton setTitle:yearForButton  forState:UIControlStateNormal];
    }
}


#pragma mark - toolBar
-(void)showTollBar{
    CGFloat toolbarHight = 44;
    self.pickertoolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - Picker_HEIGHT - toolbarHight, 320, toolbarHight)];
    self.pickertoolbar.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(donePicking)] ;
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] ;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [items addObject:flex];
    
    [items addObject:nextButton];
    [self.pickertoolbar setItems:items animated:YES];
    [self.view addSubview:self.pickertoolbar];
}




#pragma mark - enable and disable all views

/*disable All view to user gesture Except From the current view and the cuurent tool bar */
-(void)disableAllViewsExceptFromCurrentViews {
    
    NSArray *allSubView = [self.view subviews];
    for (UIView *view in allSubView) {
        if (view != self.currentPicker && view != self.pickertoolbar) {
            [view setUserInteractionEnabled:NO];
        }
    }
    
}

/*enable All view to user gesture  */
-(void)enableAllviews {
    
    NSArray *allSubView = [self.view subviews];
    for (UIView *view in allSubView) {
        [view setUserInteractionEnabled:YES];
    }
    
}


@end

