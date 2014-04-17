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


@interface AssignmentsTVC () <MCSwipeTableViewCellDelegate>
@property (strong,nonatomic) NSMutableArray* doIt;
@property (strong,nonatomic) NSMutableArray* allCourseName;
@property (strong,nonatomic) NSMutableDictionary* assignmentsForCourse;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmenttedControl;



@end

@implementation AssignmentsTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentTVCState = DoIT;
    self.segmenttedControl.selectedSegmentIndex = 1;
    [self getData];
    UIColor *darkB = [AppUtilities darkerColorForColor:[UIColor blueColor]];
    self.tableView.editing = NO;
    [self.segmenttedControl setTintColor:darkB];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getData{
    self.doIt = [[NSMutableArray alloc]init];
    NSDictionary *dic1  = [[NSDictionary alloc] initWithObjectsAndKeys:@"OS", @"course", @1, @"number",@"2014-09-27T00:00:00.000Z",@"due", nil];
    [self.doIt addObject:dic1];
    
  //  GET /exercises?token=TOKEN
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *s = [NSString stringWithFormat:@"http://doitapi.herokuapp.com/me?token=%@",[User localUser].token];
    [manager GET:s parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

        [self parseUserData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    

}

-(void)parseUserData:(NSDictionary *)dic {
    
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

    
    MCSwipeTableViewCell *cell =  nil;[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // iOS 7 separator
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.currentTVCState == DoneIT) {
        NSString *result = [ NSString stringWithFormat:@"Assignment In %@",[self.allCourseName objectAtIndex:section]];
        return result;
    }
    return nil;
}


#pragma mark BEVSliderCell actions

- (void)cellReachedLeftEdge:(id)sender
{
    NSLog(@"Cell reached left edge: %@", sender);
}

- (void)cellReachedRightEdge:(id)sender
{
    NSLog(@"Cell reached right edge: %@", sender);
}

#pragma mark Button action

- (void)buttonBehindCellPressed:(id)sender
{
    NSLog(@"Button pressed: %@", sender);
}




-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}




- (IBAction)segmentControlChange:(id)sender {
    if (self.currentTVCState == DoIT) {
        self.currentTVCState = DoneIT;
    }else {
        self.currentTVCState = DoIT;
    }
    [self.tableView reloadData];
}



- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}


- (void)deleteCell:(MCSwipeTableViewCell *)cell {
    
    NSParameterAssert(cell);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)assignmentComplited{
    NSLog(@"yes");
    
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
            [self assignmentComplited];
        }];
        
        [cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            
            [self deleteCell:cell];
        }];
 }
@end
