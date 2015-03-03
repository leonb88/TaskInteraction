

#import <UIKit/UIKit.h>

@interface RecommendedListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *v_rectableView;
@property (nonatomic,readwrite) BOOL v_ViewState;

- (IBAction)vaddRecList:(UIButton *)sender;

@end
