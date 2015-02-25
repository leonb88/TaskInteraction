//
//  PropertyViewController.m
//  TaskInteraction
//
//  Created by Vallis Durand on 14/02/15.
//  Copyright (c) 2015 Vallis Durand. All rights reserved.
//

#import "PropertyViewController.h"
#import "RecommendedListViewController.h"
#import "HSDatePickerViewController.h"
#import "MMPickerView.h"
#import "TaskListModel.h"

@interface PropertyViewController ()<HSDatePickerViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIButton *v_checkBtn;
@property (nonatomic,strong) UIBarButtonItem *cancelBtn, *doneBtn;
@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.v_scrollView setContentSize:CGSizeMake(5, 600)];
    [self.v_scrollView setFrame:CGRectMake(0, 0, 320, 568)];
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.v_dueTimeList = @[@"1 hour",@"2 hours",@"3 hours",@"4 hours",@"5 hours",@"6 hours",@"7 hours",@"8 hours",@"9 hours",@"10 hours",@"10 more hours"];
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
        
        
        UIButton *v_backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        [v_backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [v_backBtn addTarget:self action:@selector(vclose) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *v_closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:v_backBtn];
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
    [self.v_notesTxt setReturnKeyType:UIReturnKeyDone];
    [self.v_taskNameTxt setDelegate:self];
    [self.v_tagsTxt setDelegate:self];
    [self.v_notesTxt setDelegate:self];
    self.v_notesTxt.tag = 1;
    self.v_taskNameTxt.tag = 2;
    [self.v_repeatsettingView setHidden:YES];
}

-(void)setPropertyViewState
{
    self.v_taskNameTxt.text = [[TaskListModel getAllTaskName] objectForKey:self.v_selectedObject];
    self.v_tagsTxt.text = [[TaskListModel getAllTaskTags] objectForKey:self.v_selectedObject];
    self.v_notesTxt.text = [[TaskListModel getAllTaskNotes] objectForKey:self.v_selectedObject];
    self.v_duetimeLb.text = [[TaskListModel getAllTaskDueTime] objectForKey:self.v_selectedObject];
    
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    NSDate *deadlineDate = [[TaskListModel getAllTaskDeadlineDates]objectForKey:self.v_selectedObject];
    [self.v_datepickBtn setTitle:[dateFormater stringFromDate:deadlineDate] forState:UIControlStateNormal];

    BOOL importantAttr = [[[TaskListModel getAllTaskImportantAttr]objectForKey:self.v_selectedObject]boolValue];
    BOOL effortAttr = [[[TaskListModel getAllTaskEffortAttr]objectForKey:self.v_selectedObject]boolValue];
    BOOL enjoyAttr = [[[TaskListModel getAllTaskEnjoyAttr]objectForKey:self.v_selectedObject]boolValue];
    BOOL socialAttr = [[[TaskListModel getAllTaskSocialAttr]objectForKey:self.v_selectedObject]boolValue];
    
    if(importantAttr == NO)
    {
        [self.v_importantBtn setImage:[UIImage imageNamed:@"imp.png"] forState:UIControlStateNormal];
        [self.v_importantBtn setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.v_importantBtn setImage:[UIImage imageNamed:@"imp_select.png"] forState:UIControlStateNormal ];
        [self.v_importantBtn setBackgroundColor:[UIColor blackColor]];
        [self.v_importantBtn setAlpha:0.7f];
    }
    if(effortAttr == NO)
    {
        [self.v_effortBtn setImage:[UIImage imageNamed:@"effort.png"] forState:UIControlStateNormal];
        [self.v_effortBtn setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.v_effortBtn setImage:[UIImage imageNamed:@"effort_select.png"] forState:UIControlStateNormal ];
        [self.v_effortBtn setBackgroundColor:[UIColor blackColor]];
        [self.v_effortBtn setAlpha:0.7f];
    }
    if(enjoyAttr == NO)
    {
        [self.v_enjoyBtn setImage:[UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
        [self.v_enjoyBtn setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.v_enjoyBtn setImage:[UIImage imageNamed:@"smile_select.png"] forState:UIControlStateNormal ];
        [self.v_enjoyBtn setBackgroundColor:[UIColor blackColor]];
        [self.v_enjoyBtn setAlpha:0.7f];
    }
    if(socialAttr == NO)
    {
        [self.v_socialBtn setImage:[UIImage imageNamed:@"social.png"] forState:UIControlStateNormal];
        [self.v_socialBtn setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.v_socialBtn setImage:[UIImage imageNamed:@"social_select.png"] forState:UIControlStateNormal];
        [self.v_socialBtn setBackgroundColor:[UIColor blackColor]];
        [self.v_socialBtn setAlpha:0.7f];
    }
    
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0 && textField.tag == 2) {
        self.cancelBtn.enabled = NO;
        self.doneBtn.enabled = YES;
        
    }else{
        self.cancelBtn.enabled = YES;
        self.doneBtn.enabled = NO;
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
//    [self.v_taskNameTxt.text isEqualToString:@""] || [self.v_notesTxt.text isEqualToString:@""] || [self.v_tagsTxt.text isEqualToString:@""] || [self.v_datepickBtn.titleLabel.text isEqualToString:@""] || [self.v_duetimeLb.text isEqualToString:@""]
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
        [TaskListModel setTaskForCurrentKey:self.v_taskNameTxt.text importantAttr:self.v_ImportantState effortAttr:self.v_EffortState enjoyAttr:self.v_EnjoyState socialAttr:self.v_SocialState tags:self.v_tagsTxt.text deadlineDate:self.v_selectedDate dueTime:self.v_duetimeLb.text repeatType:self.v_RecurringType notes:self.v_notesTxt.text originTaskName:self.v_originTaskName];
        [TaskListModel saveTasks];
        [self dismissViewControllerAnimated:YES completion:nil];
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
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0.f, -180.f, self.view.frame.size.width, self.view.frame.size.height);
        }completion:nil] ;
    }
}

//Repeat Controll
- (IBAction)vrepeat:(UIButton *)sender {

    [self dismissKeyboard];
    if (self.v_repeatsettingView.hidden == YES) {
        [self.v_repeatsettingView setHidden:NO];
        self.v_notesTxt.frame = CGRectMake(10.f, 470, self.v_notesTxt.frame.size.width, self.v_notesTxt.frame.size.height);
        self.v_repeatframeLineImg.frame = CGRectMake(20.f,450, self.v_repeatframeLineImg.frame.size.width,1);
    }else{
        [self.v_repeatsettingView setHidden:YES];
        self.v_notesTxt.frame = CGRectMake(10.f, 390, self.v_notesTxt.frame.size.width, self.v_notesTxt.frame.size.height);
        self.v_repeatframeLineImg.frame = CGRectMake(20.f,370, self.v_repeatframeLineImg.frame.size.width,1);
    }
}

- (IBAction)vselectRepeat:(UISegmentedControl *)sender {

    [self dismissKeyboard];
    [self.v_repeatsettingView setHidden:YES];
    self.v_notesTxt.frame = CGRectMake(10.f, 390, self.v_notesTxt.frame.size.width, self.v_notesTxt.frame.size.height);
    self.v_repeatframeLineImg.frame = CGRectMake(20.f,370, self.v_repeatframeLineImg.frame.size.width,1);
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

- (void)vbell
{

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
    
    if([self.v_importantBtn.currentImage isEqual:[UIImage imageNamed:@"imp_select.png"]])
    {
        self.v_ImportantState = YES;
    }else
        {
        self.v_ImportantState = NO;
    }
    
    if([self.v_effortBtn.currentImage isEqual:[UIImage imageNamed:@"effort_select.png"]])
    {
        self.v_EffortState = YES;
    }else
    {
        self.v_EffortState = NO;
    }
    
    if([self.v_enjoyBtn.currentImage isEqual:[UIImage imageNamed:@"smile_select.png"]])
    {
        self.v_EnjoyState = YES;
    }else
    {
        self.v_EnjoyState = NO;
    }
    
    if([self.v_socialBtn.currentImage isEqual:[UIImage imageNamed:@"social_select.png"]])
    {
        self.v_SocialState = YES;
    }else
    {
        self.v_SocialState = NO;
    }
    
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
    
    [TaskListModel setTask:self.v_taskNameTxt.text importantAttr:self.v_ImportantState effortAttr:self.v_EffortState enjoyAttr:self.v_EnjoyState socialAttr:self.v_SocialState tags:self.v_tagsTxt.text deadlineDate:date dueTime:self.v_duetimeLb.text repeatType:self.v_RecurringType notes:self.v_notesTxt.text forKey:self.v_selectedObject originTaskName:self.v_originTaskName];
    [TaskListModel saveTasks];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)vimport:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.tag = 0;
    [self dismissKeyboard];
    if([button.currentImage isEqual:[UIImage imageNamed:@"imp_select.png"]])
    {
        [button setImage:[UIImage imageNamed:@"imp.png"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        self.v_ImportantState = NO;
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"imp_select.png"] forState:UIControlStateNormal ];
        [button setBackgroundColor:[UIColor blackColor]];
        [button setAlpha:0.7f];
        self.v_ImportantState = YES;
    }
}

- (IBAction)veffort:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.tag = 1;
    [self dismissKeyboard];
    if([button.currentImage isEqual:[UIImage imageNamed:@"effort_select.png"]])
    {
        [button setImage:[UIImage imageNamed:@"effort.png"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        self.v_EffortState = NO;
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"effort_select.png"] forState:UIControlStateNormal ];
        [button setBackgroundColor:[UIColor blackColor]];
        [button setAlpha:0.7f];
        self.v_EffortState = YES;
    }
}

- (IBAction)vsmile:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.tag = 2;
    [self dismissKeyboard];
    if([button.currentImage isEqual:[UIImage imageNamed:@"smile_select.png"]]) {
        [button setImage:[UIImage imageNamed:@"smile.png"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        self.v_EnjoyState = NO;
    }
    else{
        [button setImage:[UIImage imageNamed:@"smile_select.png"] forState:UIControlStateNormal ];
        [button setBackgroundColor:[UIColor blackColor]];
        [button setAlpha:0.7f];
        self.v_EnjoyState = YES;
    }
}

- (IBAction)vsocial:(UIButton *)sender {
    
    UIButton *button = (UIButton *)sender;
    button.tag = 3;
    [self dismissKeyboard];
    if([button.currentImage isEqual:[UIImage imageNamed:@"social_select.png"]])
    {
        [button setImage:[UIImage imageNamed:@"social.png"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        self.v_SocialState = NO;
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"social_select.png"] forState:UIControlStateNormal ];
        [button setBackgroundColor:[UIColor blackColor]];
        [button setAlpha:0.7f];
        self.v_SocialState = YES;
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
//    self.v_datepickBtn.titleLabel.text = [dateFormater stringFromDate:date];
    [self.v_datepickBtn setTitle:[dateFormater stringFromDate:date] forState:UIControlStateNormal];
    self.v_selectedDate = date;
}

- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    [self dismissKeyboard];
//    NSLog(@"Picker did dismiss with %d", method);
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    [self dismissKeyboard];
//    NSLog(@"Picker will dismiss with %d", method);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
