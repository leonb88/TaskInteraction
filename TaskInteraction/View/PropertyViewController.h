//
//  PropertyViewController.h
//  TaskInteraction
//
//  Created by Vallis Durand on 14/02/15.
//  Copyright (c) 2015 Vallis Durand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyViewController : UIViewController
@property (nonatomic, strong) NSDate *v_selectedDate;
@property (nonatomic, strong) NSString *v_selectedDueTime;
@property (nonatomic, strong) NSArray *v_dueTimeList;
@property (nonatomic, strong) NSString *v_selectedObject, *v_selectTaskName;
@property (nonatomic,readwrite) BOOL v_pViewState;
@property (nonatomic,strong) NSString *v_originTaskName;

//TaskProperty
@property (nonatomic,readwrite) BOOL v_ImportantState, v_EffortState, v_EnjoyState, v_SocialState;
@property (nonatomic,readwrite) NSInteger v_RecurringType;

//Controll
@property (weak, nonatomic) IBOutlet UITextField *v_taskNameTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *v_scrollView;
@property (weak, nonatomic) IBOutlet UITextField *v_tagsTxt;
@property (weak, nonatomic) IBOutlet UIButton *v_datepickBtn;
@property (weak, nonatomic) IBOutlet UILabel *v_duetimeLb;
@property (weak, nonatomic) IBOutlet UITextField *v_notesTxt;
@property (weak, nonatomic) IBOutlet UIView *v_repeatsettingView;
@property (weak, nonatomic) IBOutlet UIImageView *v_repeatframeLineImg;
@property (weak, nonatomic) IBOutlet UIButton *v_repeatcontrollBtn;
@property (weak, nonatomic) IBOutlet UIButton *v_importantBtn;
@property (weak, nonatomic) IBOutlet UIButton *v_effortBtn;
@property (weak, nonatomic) IBOutlet UIButton *v_enjoyBtn;
@property (weak, nonatomic) IBOutlet UIButton *v_socialBtn;

- (IBAction)vimport:(UIButton *)sender;
- (IBAction)veffort:(UIButton *)sender;
- (IBAction)vsmile:(UIButton *)sender;
- (IBAction)vsocial:(UIButton *)sender;
- (IBAction)vclock:(UIButton *)sender;
- (IBAction)vdatepick:(UIButton *)sender;
- (IBAction)vrepeat:(UIButton *)sender;
- (IBAction)vselectRepeat:(UISegmentedControl *)sender;


@end
