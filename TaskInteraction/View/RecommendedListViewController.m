
#import "RecommendedListViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "PropertyViewController.h"
#import "MCSwipeTableViewCell.h"
#import "TaskListModel.h"
#import "MBProgressHUD.h"

@interface RecommendedListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MCSwipeTableViewCellDelegate>
{
    MBProgressHUD *hub;
}
@property (nonatomic,strong) UIButton *v_dateBtn ,*v_reshuffleBtn;
@property (nonatomic, assign) NSUInteger recListCount;
@property (nonatomic,strong) NSMutableArray * v_recommendArray , *v_fullArray;
@end
@implementation RecommendedListViewController
@synthesize v_dateBtn,v_reshuffleBtn;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0]];
    [self.v_rectableView setBackgroundView:backgroundView];
    [self addObserver];
}

- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setViewState)
                                                 name:@"ViewFullState"
                                               object:nil];
}

- (void) setViewState {
    self.v_ViewState = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.v_ViewState == YES) {
        self.title = @"Full List";
        UIButton *v_nonrecBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [v_nonrecBtn setImage:[UIImage imageNamed:@"nonrec.png"] forState:UIControlStateNormal];
        [v_nonrecBtn addTarget:self action:@selector(vnonrecommendedDisplay:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_nonRecommended = [[UIBarButtonItem alloc] initWithCustomView:v_nonrecBtn];
        [self.navigationItem setRightBarButtonItem:v_nonRecommended];
        [self vmakeTaskObject];
    }else{
        self.title = @"Recommended List";
        v_reshuffleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [v_reshuffleBtn setImage:[UIImage imageNamed:@"reshuffle.png"] forState:UIControlStateNormal];
        [v_reshuffleBtn addTarget:self action:@selector(vreshuffle) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_reshuffle = [[UIBarButtonItem alloc] initWithCustomView:v_reshuffleBtn];
        [self.navigationItem setRightBarButtonItem:v_reshuffle];
         [self vrecommendedDisplay];
    }
}

- (void)vrecommendedDisplay
{
    NSMutableArray *array =
    [NSMutableArray arrayWithArray:[[TaskListModel getAllTaskName] allKeys]];
    self.v_recommendArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [array count]; i ++) {
        NSString * key =  [array objectAtIndex:i];
        if ([[[TaskListModel getAllTaskImportantAttr]objectForKey:key]intValue] > 0 || [[[TaskListModel getAllTaskEffortAttr]objectForKey:key]intValue] > 0 || [[[TaskListModel getAllTaskSocialAttr]objectForKey:key]intValue] > 0 || [[[TaskListModel getAllTaskEnjoyAttr]objectForKey:key]intValue] > 0) {
            [self.v_recommendArray addObject:key];
            }else{
         }
    }
    self.recListCount = [self.v_recommendArray count];
    [self.v_rectableView reloadData];
}
- (void)vnonrecommendedDisplay:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if([button.currentImage isEqual:[UIImage imageNamed:@"nonrec.png"]])
    {
        [button setImage:[UIImage imageNamed:@"recom.png"] forState:UIControlStateNormal];
        NSInteger count = 0;
        NSMutableArray *norecArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [ self.v_fullArray count]; i ++) {
            NSString * key =  [self.v_fullArray objectAtIndex:i];
            if ([[[TaskListModel getAllTaskImportantAttr]objectForKey:key]intValue] <= 0 && [[[TaskListModel getAllTaskEffortAttr]objectForKey:key]intValue] <= 0 && [[[TaskListModel getAllTaskSocialAttr]objectForKey:key]intValue] <= 0 && [[[TaskListModel getAllTaskEnjoyAttr]objectForKey:key]intValue] <= 0) {
                count ++;
                [norecArray addObject:key];
            }else{
            }
        }
        NSLog(@"%@ \n",self.v_fullArray);
        self.v_fullArray = [NSMutableArray arrayWithArray:norecArray];
        self.recListCount = count;
        [self.v_rectableView reloadData];
    }else
    {   [button setImage:[UIImage imageNamed:@"nonrec.png"] forState:UIControlStateNormal];
        [self vmakeTaskObject];
        [self.v_rectableView reloadData];
    }
}
-(void) vreshuffle
{
    if([self.v_reshuffleBtn.currentImage isEqual:[UIImage imageNamed:@"range.png"]])
    {
        [self.v_reshuffleBtn setImage:[UIImage imageNamed:@"reshuffle.png"] forState:UIControlStateNormal];
        [self vrecommendedDisplay];
        [self.v_rectableView reloadData];
    }else
    {
        [self.v_reshuffleBtn setImage:[UIImage imageNamed:@"range.png"] forState:UIControlStateNormal];
        for (int i = 0; i < [self.v_recommendArray count]; i++) {
            int randInt = (arc4random() % ([self.v_recommendArray count] - i)) + i;
            [self.v_recommendArray exchangeObjectAtIndex:i withObjectAtIndex:randInt];
        }
        [self.v_rectableView reloadData];
    }
}
-(void)vmakeTaskObject
{
    self.v_fullArray =
    [NSMutableArray arrayWithArray:[[TaskListModel getAllTaskName] allKeys]];
    [self.v_fullArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSDate *)obj2 compare:(NSDate *)obj1];
    }];
    self.recListCount = self.v_fullArray.count;
    [self.v_rectableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.recListCount;
    return self.recListCount;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [revealViewController cellReveal];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[MCSwipeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
//    UIImageView *edit = [[UIImageView alloc]initWithFrame:CGRectMake(280, 20, 20, 20)];
//    edit.image = [UIImage imageNamed:@"edit.png"];
//    [cell addSubview:edit];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDataSource
- (void)configureCell:(MCSwipeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *checkView = [self viewWithImageName:@"complete.png"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    UIView *trashView = [self viewWithImageName:@"waste.png"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.v_rectableView.backgroundView.backgroundColor];
    [cell setDelegate:self];
    cell.shouldAnimateIcons = YES;

    if (self.v_ViewState == YES) {
        NSString *object = self.v_fullArray[indexPath.row];
        cell.textLabel.text = [[TaskListModel getAllTaskName] objectForKey:object];
    }else{
        NSString *object = self.v_recommendArray[indexPath.row];
        cell.textLabel.text = [[TaskListModel getAllTaskName]objectForKey:object];
    }
    
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Checkmark\" cell");
        [self deleteCell:cell];
    }];
    [cell setSwipeGestureWithView:trashView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self deleteCell:cell];
    }];
}

- (void)deleteCell:(MCSwipeTableViewCell *)cell {
    NSParameterAssert(cell);
    self.recListCount--;
    NSIndexPath *indexPath = [self.v_rectableView indexPathForCell:cell];
    if (self.v_ViewState == YES) {
        NSString *object = self.v_fullArray[indexPath.row];
        [TaskListModel removeObjectForKey:object taskName:cell.textLabel.text];
        [TaskListModel saveTasks];
        [self.v_rectableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self vmakeTaskObject];
    }else
    {
        NSString *object = self.v_recommendArray[indexPath.row];
        [TaskListModel removeObjectForKey:object taskName:cell.textLabel.text];
        [TaskListModel saveTasks];
        [self.v_rectableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self vrecommendedDisplay];
    }
    
}
- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PropertyViewController *destViewController;
    if ([segue.identifier isEqualToString:@"recproperty"]) {
        
        destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.v_rectableView indexPathForSelectedRow];
        if (self.v_ViewState == YES) {
            destViewController.v_selectedObject = self.v_fullArray[indexPath.row];
            destViewController.v_originTaskName = [[TaskListModel getAllTaskName]objectForKey:self.v_fullArray[indexPath.row]];
        }else{
            destViewController.v_selectedObject = self.v_recommendArray[indexPath.row];
            destViewController.v_originTaskName = [[TaskListModel getAllTaskName]objectForKey:self.v_recommendArray[indexPath.row]];
        }
        destViewController.v_pViewState = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)vaddRecList:(UIButton *)sender {
    NSString *key = [[NSDate date] description];//current date
    [TaskListModel setCurrentKey:key];
    [self.v_fullArray insertObject:key atIndex:0];
    [self performSegueWithIdentifier:kRecListItem sender:self];
}

@end
