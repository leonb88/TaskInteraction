//
//  RecommendedListViewController.h
//  TaskInteraction
//
//  Created by Vallis Durand on 14/02/15.
//  Copyright (c) 2015 Vallis Durand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendedListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *v_rectableView;
@property (nonatomic,readwrite) BOOL v_ViewState;

- (IBAction)vaddRecList:(UIButton *)sender;

@end
