//
//  SlideMenuTableViewController.m
//  TaskInteraction
//
//  Created by Vallis Durand on 14/02/15.
//  Copyright (c) 2015 Vallis Durand. All rights reserved.
//

#import "SlideMenuTableViewController.h"
#import "RecommendedListViewController.h"

@interface SlideMenuTableViewController ()

@end

@implementation SlideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"title",@"recommended", @"full"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    UINavigationController *navController = segue.destinationViewController;
    RecommendedListViewController *recomendViewController = [navController childViewControllers].firstObject;

    if ([segue.identifier isEqualToString:@"fullList"]) {
        
        recomendViewController.v_ViewState = YES;
    }
    else{
        recomendViewController.v_ViewState = NO;
    }
}

@end
