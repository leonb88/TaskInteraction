

#import "PropertyViewController.h"
#import "RecommendedListViewController.h"
#import "HSDatePickerViewController.h"
#import "MMPickerView.h"
#import "TaskListModel.h"

@interface PropertyViewController ()<HSDatePickerViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIButton *v_checkBtn, *v_backBtn;
@property (nonatomic,strong) UIBarButtonItem *cancelBtn, *doneBtn;
@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.v_scrollView setContentSize:CGSizeMake(5, 630)];
    [self.v_scrollView setFrame:CGRectMake(0, 0, 320, 568)];
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.v_importantSlider.backgroundColor = [UIColor clearColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"imp" ofType:@"png"];
    [self.v_importantSlider setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath] scale:4.0f] forState:UIControlStateNormal];
  
    self.v_dueTimeList = @[@"1 hour",@"2 hours",@"3 hours",@"4 hours",@"5 hours",@"6 hours",@"7 hours",@"8 hours",@"9 hours",@"10 hours",@"10+ hours"];
    self.v_selectedDueTime = [self.v_dueTimeList objectAtIndex:0];
    if (self.v_pViewState) {
        UIButton *v_bellBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [v_bellBtn setImage:[UIImage imageNamed:@"bell.png"] forState:UIControlStateNormal];
        [v_bellBtn addTarget:self action:@selector(vbell) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_bellBarBtn = [[UIBarButtonItem alloc] initWithCustomView:v_bellBtn];
        
        UIButton *v_trashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [v_trashBtn setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        [v_trashBtn addTarget:self action:@selector(vtrash) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_trashBarBtn = [[UIBarButtonItem alloc] initWithCustomView:v_trashBtn];
        
        self.v_checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self.v_checkBtn setImage:[UIImage imageNamed:@"check_non.png"] forState:UIControlStateNormal];
        [self.v_checkBtn addTarget:self action:@selector(vcheck) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_checkBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.v_checkBtn];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:v_checkBarBtn, v_trashBarBtn, v_bellBarBtn, nil]];
        
        self.v_backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [self.v_backBtn setImage:[UIImage imageNamed:@"back_en.png"] forState:UIControlStateNormal];
        [self.v_backBtn addTarget:self action:@selector(vclose) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.v_backBtn];
        [self.navigationItem setLeftBarButtonItem:v_closeBarBtn];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@"Cancel"
                                                  style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
        self.cancelBtn = self.navigationItem.rightBarButtonItem;
        self.cancelBtn.enabled = YES;
        self.doneBtn = self.navigationItem.leftBarButtonItem;
        self.doneBtn.enabled = NO;
        [self.v_taskNameTxt becomeFirstResponder];
    }
    [self setPropertyViewState];
    [self.v_taskNameTxt setReturnKeyType:UIReturnKeyDone];
    [self.v_tagsTxt setReturnKeyType:UIReturnKeyDone];
    [self.v_taskNameTxt setDelegate:self];
    [self.v_tagsTxt setDelegate:self];
    [self.v_notesTxt setDelegate:self];
    self.v_tagsTxt.tag = 1;
    self.v_tagsTxt.delegate = self;
    self.v_taskNameTxt.tag = 2;
    [self.v_repeatsettingView setHidden:YES];
}

-(void)setPropertyViewState{
    self.v_taskNameTxt.text = [[TaskListModel getAllTaskName] objectForKey:self.v_selectedObject];
    self.v_tagsTxt.text = [[TaskListModel getAllTaskTags] objectForKey:self.v_selectedObject];
    self.v_notesTxt.text = [[TaskListModel getAllTaskNotes] objectForKey:self.v_selectedObject];
    self.v_duetimeLb.text = [[TaskListModel getAllTaskDueTime] objectForKey:self.v_selectedObject];
    
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    NSDate *deadlineDate = [[TaskListModel getAllTaskDeadlineDates]objectForKey:self.v_selectedObject];
    [self.v_datepickBtn setTitle:[dateFormater stringFromDate:deadlineDate] forState:UIControlStateNormal];

    self.v_importantSlider.backgroundColor = [UIColor clearColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"imp" ofType:@"png"];
    [self.v_importantSlider setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath] scale:4.0f] forState:UIControlStateNormal];
    
    self.v_effortSlider.backgroundColor = [UIColor clearColor];
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"effort" ofType:@"png"];
    [self.v_effortSlider setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath1] scale:4.0f] forState:UIControlStateNormal];

    self.v_enjoySlider.backgroundColor = [UIColor clearColor];
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"smile" ofType:@"png"];
    [self.v_enjoySlider setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2] scale:4.0f] forState:UIControlStateNormal];

    self.v_socialSlider.backgroundColor = [UIColor clearColor];
    NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"social" ofType:@"png"];
    [self.v_socialSlider setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath3] scale:4.0f] forState:UIControlStateNormal];

    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    self.v_importantSlider.transform = trans;
    self.v_effortSlider.transform = trans;
    self.v_enjoySlider.transform = trans;
    self.v_socialSlider.transform = trans;
    
    NSInteger importantAttr = [[[TaskListModel getAllTaskImportantAttr]objectForKey:self.v_selectedObject]intValue];
    NSInteger effortAttr = [[[TaskListModel getAllTaskEffortAttr]objectForKey:self.v_selectedObject]intValue];
    NSInteger enjoyAttr = [[[TaskListModel getAllTaskEnjoyAttr]objectForKey:self.v_selectedObject]intValue];
    NSInteger socialAttr = [[[TaskListModel getAllTaskSocialAttr]objectForKey:self.v_selectedObject]intValue];
    
    self.v_importantSlider.value = importantAttr;
    self.v_effortSlider.value = effortAttr;
    self.v_enjoySlider.value = enjoyAttr;
    self.v_socialSlider.value = socialAttr;
    
    NSInteger repeateType = [[[TaskListModel getAllTaskRepeats]objectForKey:self.v_selectedObject]integerValue];
    switch (repeateType) {
        case 0:
            [self.v_repeatcontrollBtn setTitle:@"Never" forState:UIControlStateNormal];
            break;
        case 1:
            [self.v_repeatcontrollBtn setTitle:@"Every day" forState:UIControlStateNormal];
            break;
        case 2:
            [self.v_repeatcontrollBtn setTitle:@"Every week" forState:UIControlStateNormal];
            break;
        case 3:
            [self.v_repeatcontrollBtn setTitle:@"Every month" forState:UIControlStateNormal];
            break;
        case 4:
            [self.v_repeatcontrollBtn setTitle:@"Every year" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >= 30 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0 && textField.tag == 2) {
        self.cancelBtn.enabled = NO;
        self.doneBtn.enabled = YES;
        [self.v_backBtn setImage:[UIImage imageNamed:@"back_en.png"] forState:UIControlStateNormal];
        self.v_backBtn.enabled = YES;
    }else{
        self.cancelBtn.enabled = YES;
        self.doneBtn.enabled = NO;
        [self.v_backBtn setImage:[UIImage imageNamed:@"back_dis.png"] forState:UIControlStateNormal];
        self.v_backBtn.enabled = NO;
    }
}

-(void)cancel:(id)sender
{
    self.view.frame = CGRectMake(0.f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [self.v_tagsTxt resignFirstResponder];
    [self.v_taskNameTxt resignFirstResponder];
    [self.v_notesTxt resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)done:(id)sender
{
    if (self.v_taskNameTxt.text.length == 0 || [self.v_taskNameTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Task name is blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        if (self.v_duetimeLb.text == nil) {
            [self.v_duetimeLb setText:@"none"];
        }
        if (self.v_selectedDate == nil) {
            self.v_selectedDate = [NSDate date];
            NSLog(@"Date = %@",self.v_selectedDate);
        }
        [TaskListModel setTaskForCurrentKey:self.v_taskNameTxt.text importantAttr:(int)self.v_importantSlider.value effortAttr:(int)self.v_effortSlider.value enjoyAttr:(int)self.v_enjoySlider.value socialAttr:(int)self.v_socialSlider.value tags:self.v_tagsTxt.text deadlineDate:self.v_selectedDate dueTime:self.v_duetimeLb.text repeatType:self.v_RecurringType notes:self.v_notesTxt.text originTaskName:self.v_originTaskName];
        [TaskListModel saveTasks];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewFullState"
                                                            object:nil];
        [self dismissViewControllerAnimated:YES completion: nil];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0.f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    }completion:nil] ;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0.f, -250.f, self.view.frame.size.width, self.view.frame.size.height);
    }completion:nil] ;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0.f, -30.f, self.view.frame.size.width, self.view.frame.size.height);
        }completion:nil] ;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 1){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0.f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        }completion:nil] ;
    }
    return YES;
}
-(void)dismissKeyboard {
    
    self.view.frame = CGRectMake(0.f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [self.v_tagsTxt resignFirstResponder];
    [self.v_taskNameTxt resignFirstResponder];
    [self.v_notesTxt resignFirstResponder];
    if (self.v_taskNameTxt.text.length > 0) {
        self.doneBtn.enabled = YES;
    }
}
//Repeat Controll
- (IBAction)vrepeat:(UIButton *)sender {

    [self dismissKeyboard];
    if (self.v_repeatsettingView.hidden == YES) {
        [self.v_repeatsettingView setHidden:NO];
        self.v_notesTxt.frame = CGRectMake(10.f, 520, self.v_notesTxt.frame.size.width, self.v_notesTxt.frame.size.height);
        self.v_repeatframeLineImg.frame = CGRectMake(20.f,510, self.v_repeatframeLineImg.frame.size.width,1);
    }else{
        [self.v_repeatsettingView setHidden:YES];
        self.v_notesTxt.frame = CGRectMake(10.f, 450, self.v_notesTxt.frame.size.width, self.v_notesTxt.frame.size.height);
        self.v_repeatframeLineImg.frame = CGRectMake(20.f,440, self.v_repeatframeLineImg.frame.size.width,1);
    }
}

- (IBAction)vselectRepeat:(UISegmentedControl *)sender {

    [self dismissKeyboard];
    [self.v_repeatsettingView setHidden:YES];
    self.v_notesTxt.frame = CGRectMake(10.f, 470, self.v_notesTxt.frame.size.width, self.v_notesTxt.frame.size.height);
    self.v_repeatframeLineImg.frame = CGRectMake(20.f,440, self.v_repeatframeLineImg.frame.size.width,1);
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    self.v_RecurringType = segment.selectedSegmentIndex;
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self.v_repeatcontrollBtn setTitle:@"Never" forState:UIControlStateNormal];
            break;
        case 1:
            [self.v_repeatcontrollBtn setTitle:@"Every day" forState:UIControlStateNormal];
            break;
        case 2:
            [self.v_repeatcontrollBtn setTitle:@"Every week" forState:UIControlStateNormal];
            break;
        case 3:
            [self.v_repeatcontrollBtn setTitle:@"Every month" forState:UIControlStateNormal];
            break;
        case 4:
            [self.v_repeatcontrollBtn setTitle:@"Every year" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
- (void)vbell{

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1 && buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
        [TaskListModel removeObjectForKey:self.v_selectedObject taskName:self.v_originTaskName];
        [TaskListModel saveTasks];
    }
}

- (void)vtrash {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag = 1;
    [alert show];
}
- (void)vcheck {
    [self.v_checkBtn setImage:[UIImage imageNamed:@"check_complete.png"] forState:UIControlStateNormal];
    [TaskListModel removeObjectForKey:self.v_selectedObject taskName:self.v_originTaskName];
    [TaskListModel saveTasks];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)vclose {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    date = [dateFormatter dateFromString:self.v_datepickBtn.titleLabel.text];
    
    if ([self.v_repeatcontrollBtn.titleLabel.text isEqualToString:@"Never"]) {
        self.v_RecurringType = 0;
    }else if ([self.v_repeatcontrollBtn.titleLabel.text isEqualToString:@"Every day"])
    {
        self.v_RecurringType = 1;
    }else if ([self.v_repeatcontrollBtn.titleLabel.text isEqualToString:@"Every week"])
    {
        self.v_RecurringType = 2;
    }else if ([self.v_repeatcontrollBtn.titleLabel.text isEqualToString:@"Every month"])
    {
        self.v_RecurringType = 3;
    }else if ([self.v_repeatcontrollBtn.titleLabel.text isEqualToString:@"Every year"])
    {
        self.v_RecurringType = 4;
    }

    if (self.v_duetimeLb.text == nil) {
        [self.v_duetimeLb setText:@"none"];
    }
    if (self.v_datepickBtn.titleLabel.text == nil) {
        date = [NSDate date];
    }
    if (self.v_taskNameTxt.text.length == 0 || [self.v_taskNameTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Task name is blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];}else{
            [TaskListModel setTask:self.v_taskNameTxt.text importantAttr:(int)self.v_importantSlider.value effortAttr:(int)self.v_effortSlider.value enjoyAttr:(int)self.v_enjoySlider.value socialAttr:(int)self.v_socialSlider.value tags:self.v_tagsTxt.text deadlineDate:date dueTime:self.v_duetimeLb.text repeatType:self.v_RecurringType notes:self.v_notesTxt.text forKey:self.v_selectedObject originTaskName:self.v_originTaskName];
            [TaskListModel saveTasks];
            [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)vclock:(UIButton *)sender {

    [self dismissKeyboard];
    [MMPickerView showPickerViewInView:self.view
                           withStrings:self.v_dueTimeList
                           withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                         MMtextColor: [UIColor blackColor],
                                         MMtoolbarColor: [UIColor whiteColor],
                                         MMbuttonColor: [UIColor blueColor],
                                         MMfont: [UIFont systemFontOfSize:18],
                                         MMvalueY: @1,
                                         MMselectedObject:self.v_selectedDueTime,
                                         MMtextAlignment:@1}
                            completion:^(NSString *selectedString) {
                                self.v_duetimeLb.text = selectedString;
                                self.v_selectedDueTime = selectedString;
                            }];
}

- (IBAction)vdatepick:(UIButton *)sender {
//    [self dismissKeyboard];
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    if (self.v_selectedDate) {
        hsdpvc.date = self.v_selectedDate;
    }
    [self presentViewController:hsdpvc animated:YES completion:nil];
    [self dismissKeyboard];
}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    [self.v_datepickBtn setTitle:[dateFormater stringFromDate:date] forState:UIControlStateNormal];
    self.v_selectedDate = date;
}

- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    [self dismissKeyboard];
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    [self dismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
