//
//  AssignmentsTVC.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "AssignmentsTVC.h"
#import "Assignment.h"
#import "AFHTTPRequestOperationManager.h"
#import "User.h"
#import "constants.h"
#import "AppUtilities.h"
#import "MCSwipeTableViewCell.h"
#define NO_MORE_ASSIGMMENTS @"all is done ;^)"

@interface AssignmentsTVC () <MCSwipeTableViewCellDelegate>
@property (strong,nonatomic) NSMutableArray* doIt;
@property (strong,nonatomic) NSMutableArray* allCourseName;
@property (strong,nonatomic) NSMutableDictionary* assignmentsForCourse;
@property (strong,nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmenttedControl;



@end

@implementation AssignmentsTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startSpinner];
    self.currentTVCState = DoIT;
    self.segmenttedControl.selectedSegmentIndex = 1;
    [self getDataDoIt];
    [self getDataDoneIt];
    UIColor *darkB = [AppUtilities darkerColorForColor:[UIColor blueColor]];
    self.tableView.editing = NO;
    [self.segmenttedControl setTintColor:darkB];
    
    
    
}
#pragma mark - get data from server

-(void)getDataDoneIt{
    
       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *s = [NSString stringWithFormat:@"%@/me?token=%@",SERVER_ADDRESS,[User localUser].token];
    [manager GET:s parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parseUserDataDoneIt:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void)parseUserDataDoneIt:(NSDictionary *)dic {
    
    //    {
    //    _id: "534e95022e7c06ee6ac06339",
    //    email: "gil.silas2@gmail.com",
    //    major: "CS",
    //    university: "IDC",
    //    year: 2,
    //    history: [ {
    //    exercise: {
    //    course: "Graphics",
    //    number: 3,
    //    due: "2014-04-16T00:00:00Z",
    //    submittedCount: 7,
    //    dismissedCount: 2
    //    },
    //    createdAt: "2014-04-15T00:00:00Z",
    //    isSubmitted: true
    //    } ],
    //    createdAt: "2014-04-16T14:34:42.350Z",
    //    token: "21uheu12heuh13h1rh9889r3"
    //    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSMutableArray *allCourseName = [[NSMutableArray alloc]init];
    NSArray * arr = [dic objectForKey:@"history"];
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *cureentDic  = [arr objectAtIndex:i];
        Assignment *cureentAssignmet = [[Assignment alloc]initWithDic:[cureentDic objectForKey:@"exercise" ]];
        if ([[cureentDic objectForKey:@"isSubmitted"]  isEqual: @1]){
            cureentAssignmet.didSubmit = YES;
        }
        NSString* course = cureentAssignmet.course;
        if ([result objectForKey:course]) {
            NSMutableArray* mutArr = [result objectForKey:course];
            [mutArr addObject:cureentAssignmet];
        }else {
            [allCourseName addObject:course];
            NSMutableArray* mutrr = [[NSMutableArray alloc]init];
            [mutrr addObject:cureentAssignmet];
            [result setObject:mutrr forKey:course];
        }
        
    }
    self.allCourseName = allCourseName;
    self.assignmentsForCourse = result;
    [self stopSpinner];
    [self.tableView reloadData];

    
}


-(void)getDataDoIt{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *s = [NSString stringWithFormat:@"%@/exercises?token=%@",SERVER_ADDRESS,[User localUser].token];
    [manager GET:s parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [self parseUserDataDoIt:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}

-(void)parseUserDataDoIt:(NSArray *)arr {
    self.doIt = [[NSMutableArray alloc]init];
        
    for (int i = 0; i <  [arr count]; i++) {
        [self.doIt addObject:arr[i]];
    }
    
    [self stopSpinner];
    [self.tableView reloadData];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentTVCState == DoIT) {
        return 1;
    }else {
        return [self.allCourseName count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentTVCState == DoIT) {
        return [self.doIt count];
    }else {
        NSString* course = [self.allCourseName objectAtIndex:section];
        NSMutableArray* result = [self.assignmentsForCourse objectForKey:course];
        return [result count];
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UpdatesCell";
    static NSString *CellIdentifier2 = @"DoneItCell";
    
    
    MCSwipeTableViewCell *cell = nil;
    
    
    if (self.currentTVCState == DoIT) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
    }
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // iOS 7 separator
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    
    if (self.currentTVCState == DoIT) {
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.userInteractionEnabled = YES;
    Assignment *currentAssignment = nil;
    if (self.currentTVCState == DoIT) {
        currentAssignment = [[Assignment alloc]initWithDic:[self.doIt objectAtIndex:indexPath.row]];
    } else {
        NSString* course = [self.allCourseName objectAtIndex:indexPath.section];
        NSMutableArray* assignmentForCourse = [self.assignmentsForCourse objectForKey:course];
        currentAssignment = [assignmentForCourse objectAtIndex:indexPath.row];
        if (currentAssignment.didSubmit) {
            UIColor * c =[AppUtilities darkerColorForColor:[UIColor greenColor]];
            c = [AppUtilities darkerColorForColor:c];
            cell.textLabel.textColor = c;
        }else {
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    
    if ([currentAssignment.course isEqualToString:NO_MORE_ASSIGMMENTS]) {
        cell.textLabel.text = NO_MORE_ASSIGMMENTS;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = NO;
    }else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ Exercise %d",[currentAssignment.course capitalizedString],[currentAssignment.numberOfExe intValue ]];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM"];
    NSString* dueDateInString = [formatter stringFromDate:currentAssignment.dueDate];
    cell.detailTextLabel.text = dueDateInString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.currentTVCState == DoneIT) {
        NSString *result = [ NSString stringWithFormat:@"Assignment In %@",[self.allCourseName objectAtIndex:section]];
        return result;
    }
    return nil;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

#pragma mark - sliding cell avents 
- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}


- (void)deleteCell:(MCSwipeTableViewCell *)cell {
    
    
}


//will b called if the assiment was submited or was not submitted
-(void)removeAssignmentFromDoIt:(MCSwipeTableViewCell *)cell AssignmentWasSubmittes:(BOOL)submitetStatus  {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *toDlet = [self.doIt objectAtIndex:indexPath.row];
    [self moveAssignmentToDoneIT:toDlet didSubmit:submitetStatus];
    
    [self.doIt removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.doIt.count == 0) {
        NSDictionary *dic1  = [[NSDictionary alloc] initWithObjectsAndKeys:NO_MORE_ASSIGMMENTS, @"course",  nil];
        [self.doIt addObject:dic1];
        [self.tableView reloadData];
    }

}

-(void)moveAssignmentToDoneIT:(NSDictionary*)dic didSubmit:(BOOL)didSubmit {
    Assignment *assignment = [[Assignment alloc]initWithDic:dic];
//    {
//        "exerciseId": "1212ieijoidi31412",
//        "isSubmitted": true
//    }
    
    NSLog(@"%@",[User localUser].token);
    NSString* didSubmitString;
    if (didSubmit) {
        didSubmitString = @"true";
    } else {
        didSubmitString = @"false";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString* post = [NSString stringWithFormat:@"%@/mark?token=%@",SERVER_ADDRESS,[User localUser].token];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:assignment.assignmentID, @"exerciseId", didSubmitString, @"isSubmitted", nil];
    
    [manager POST:post parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    UIView *crossView = [self viewWithImageName:@"cross"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    [cell setDelegate:self];
    
    
    cell.shouldAnimateIcons = YES;
    
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self removeAssignmentFromDoIt:cell AssignmentWasSubmittes:YES];
        cell.backgroundColor = greenColor;
    }];
    
    [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [self removeAssignmentFromDoIt:cell AssignmentWasSubmittes:NO];
    }];
}



#pragma mark - segmentControl

- (IBAction)segmentControlChange:(id)sender {
    if (self.currentTVCState == DoIT) {
        self.currentTVCState = DoneIT;
        [self.tableView reloadData];
        [self getDataDoneIt];
    }else {
        self.currentTVCState = DoIT;
        [self.tableView reloadData];
        [self getDataDoIt];
    }
    
}




#pragma mark - spinner 
#define SPINNER_WIDTH 30
#define SPINNER_HEIGHT 30
-(void)startSpinner {
    self.view.alpha = 0.7;
    CGRect spinnerFrame = CGRectMake(self.tableView.frame.size.width/2 -(SPINNER_WIDTH / 2),
                                     self.tableView.frame.size.height/2 - (SPINNER_HEIGHT /2) - self.navigationController.navigationBar.frame.size.height,
                                     30,
                                     30);
    UIActivityIndicatorView * activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:spinnerFrame];
    [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityindicator1 setColor:[UIColor purpleColor]];
    [self.view addSubview:activityindicator1];
    [activityindicator1 startAnimating];
    self.spinner = activityindicator1;
    
}

-(void)stopSpinner {
    self.view.alpha = 1;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    [self.tableView reloadData];

    
}
#pragma mark - settings vc handling
- (IBAction)PressedOnSettingsbutton:(id)sender {
    Settings *settingsVC = [[Settings alloc]init];
    settingsVC.delegate = self;
    [self presentViewController:settingsVC animated:YES completion:nil];
}

-(void)SettingsViewControllerDidPressedOnCancelButton:(Settings *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];

}

-(void)SettingsViewControllerDidPressedOnDoneButton:(Settings *)controller{
    User *cureentUser = [User localUser];
    cureentUser.majorSubject = controller.currentUserMajor;
    cureentUser.uni = controller.currentUserUni;
    cureentUser.year = controller.currentUserYear;
    [cureentUser save];
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self updateUserData];
    [self stopSpinner];
    [self getDataDoIt];
    
}

-(void)updateUserData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    User *localUser = [User localUser];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                localUser.email, @"email",
                                localUser.uni,@"university",
                                localUser.majorSubject,@"major",
                                localUser.year,@"year",
                                nil];
    NSString * toPosst = [NSString stringWithFormat:@"%@/register",SERVER_ADDRESS];
    
    [manager POST:toPosst parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


@end
