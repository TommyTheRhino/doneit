//
//  AssignmentsTVC.m
//  DoneIT
//
//  Created by Tommy Benshaul on 4/16/14.
//  Copyright (c) 2014 tommy. All rights reserved.
//

#import "AssignmentsTVC.h"
#import "Assignment.h"
#import "BEVSliderCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "User.h"


@interface AssignmentsTVC ()
@property (strong,nonatomic) NSMutableArray* doIt;
@property (strong,nonatomic) NSMutableArray* doneIt;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmenttedControl;



@end

@implementation AssignmentsTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentTVCState = DoIT;
    self.segmenttedControl.selectedSegmentIndex = 1;
    [self getData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getData{
    self.doIt = [[NSMutableArray alloc]init];
    NSDictionary *dic1  = [[NSDictionary alloc] initWithObjectsAndKeys:@"OS", @"course", @1, @"number",[NSDate date],@"due", nil];
    [self.doIt addObject:dic1];
    
  //  GET /exercises?token=TOKEN
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *s = [NSString stringWithFormat:@"http://doitapi.herokuapp.com/me?token=%@",[User localUser].token];
    [manager GET:s parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseUserData:responseObject];
        
        NSLog(@"JSON: %@", responseObject);
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
    NSArray * arr = [dic objectForKey:@"history"];
    for (int i = 0; i < arr.count; i ++) {
        NSDictionary *cureentDic  = [arr objectAtIndex:i];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentTVCState == DoIT) {
        return 1;
    }else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentTVCState == DoIT) {
        return [self.doIt count];
    }else {
        return 2;
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"UpdatesCell";
//    BEVSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.allowPanningLeft = YES;
//     cell.allowPanningRight = YES;
//    
//  if (cell.allowPanningLeft) {
//      [cell addTarget:self action:@selector(cellReachedLeftEdge:) atMinimumWidthForDirection:BEVDirectionLeft];
//   }
// 
//    if (cell.allowPanningRight) {
//        [cell addTarget:self action:@selector(cellReachedRightEdge:) atMinimumWidthForDirection:BEVDirectionRight];
//    }
//    
//    cell.bgColorDuringPan = [UIColor greenColor];
//    cell.backgroundColor = [UIColor orangeColor];
//    cell.frontLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];

   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.currentTVCState == DoIT) {
        Assignment *currentAssignment = [[Assignment alloc]initWithDic:[self.doIt objectAtIndex:indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ Exercise %d",currentAssignment.course,[currentAssignment.numberOfExe intValue ]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM"];
        NSString* dueDateInString = [formatter stringFromDate:currentAssignment.dueDate];
        cell.detailTextLabel.text = dueDateInString;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        
        
    } else {
        
    }
    
    
    
    
    
    return cell;
    
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



- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (IBAction)segmentControlChange:(id)sender {
    if (self.currentTVCState == DoIT) {
        self.currentTVCState = DoIT;
    }else {
        self.currentTVCState = DoIT;
    }
    [self.tableView reloadData];
}
//-(void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^
//    {
//        [cell setHighlighted:YES animated:YES];
//    } completion:^(BOOL finished)
//    {
//        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^
//         {
//             [cell setHighlighted:NO animated:YES];
//         } completion: NULL];
//    }];
//    
//    [UIView animateWithDuration:2.0 animations:^{
//        cell.textLabel.layer.backgroundColor = [UIColor greenColor].CGColor;
//    } completion:NULL];
//    
//
//}
@end
