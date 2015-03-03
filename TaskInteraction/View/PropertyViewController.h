

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
@property (weak, nonatomic) IBOutlet UITextView *v_notesTxt;
@property (weak, nonatomic) IBOutlet UITextField *v_taskNameTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *v_scrollView;
@property (weak, nonatomic) IBOutlet UITextField *v_tagsTxt;
@property (weak, nonatomic) IBOutlet UIButton *v_datepickBtn;
@property (weak, nonatomic) IBOutlet UILabel *v_duetimeLb;
@property (weak, nonatomic) IBOutlet UIView *v_repeatsettingView;
@property (weak, nonatomic) IBOutlet UIImageView *v_repeatframeLineImg;
@property (weak, nonatomic) IBOutlet UIButton *v_repeatcontrollBtn;
@property (weak, nonatomic) IBOutlet UISlider *v_importantSlider;
@property (weak, nonatomic) IBOutlet UISlider *v_effortSlider;
@property (weak, nonatomic) IBOutlet UISlider *v_enjoySlider;
@property (weak, nonatomic) IBOutlet UISlider *v_socialSlider;

- (IBAction)vclock:(UIButton *)sender;
- (IBAction)vdatepick:(UIButton *)sender;
- (IBAction)vrepeat:(UIButton *)sender;
- (IBAction)vselectRepeat:(UISegmentedControl *)sender;


@end
