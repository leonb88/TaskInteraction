//
//  TaskListModel.m
//  TaskInteraction
//
//  Created by Vallis Durand on 14/02/15.
//  Copyright (c) 2015 Vallis Durand. All rights reserved.
//

#import "TaskListModel.h"
#import <Parse/Parse.h>

@implementation TaskListModel

static NSMutableDictionary *allTaskNames;
static NSMutableDictionary *allTaskImportantAttrs;
static NSMutableDictionary *allTaskEffortAttrs;
static NSMutableDictionary *allTaskEnjoyAttrs;
static NSMutableDictionary *allTaskSocialAttrs;
static NSMutableDictionary *allTaskDueTimes;
static NSMutableDictionary *allTaskTags;
static NSMutableDictionary *allTaskDeadlineDates;
static NSMutableDictionary *allTaskRepeats;
static NSMutableDictionary *allTaskNotes;
static NSString *currentKey;

static TaskListModel *instanceOfTaskList = nil;

+(TaskListModel *)sharedTaskListModel
{
    if (!instanceOfTaskList) {
        instanceOfTaskList = [[TaskListModel alloc] init];
    }
    return instanceOfTaskList;
}

-(id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+(NSMutableDictionary *)getAllTaskName
{
    if ( allTaskNames == nil ) {
        allTaskNames = [[NSMutableDictionary alloc]
                    initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                        dictionaryForKey:kAllTaskName]];
    }
    return allTaskNames;
}

+(NSMutableDictionary *)getAllTaskImportantAttr{
    if ( allTaskImportantAttrs == nil ) {
        allTaskImportantAttrs = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskImportantAttr]];
    }
    return allTaskImportantAttrs;
}
+(NSMutableDictionary *)getAllTaskEffortAttr{
    if ( allTaskEffortAttrs == nil ) {
        allTaskEffortAttrs = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskEffortAttr]];
    }
    return allTaskEffortAttrs;
}
+(NSMutableDictionary *)getAllTaskEnjoyAttr{
    if ( allTaskEnjoyAttrs == nil ) {
        allTaskEnjoyAttrs = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskEnjoyAttr]];
    }
    return allTaskEnjoyAttrs;
}
+(NSMutableDictionary *)getAllTaskSocialAttr{
    if ( allTaskSocialAttrs == nil ) {
        allTaskSocialAttrs = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskSocialAttr]];
    }
    return allTaskSocialAttrs;
}
+(NSMutableDictionary *)getAllTaskDueTime{
    if ( allTaskDueTimes == nil ) {
        allTaskDueTimes = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskDueTime]];
    }
    return allTaskDueTimes;
}
+(NSMutableDictionary *)getAllTaskDeadlineDates{
    if ( allTaskDeadlineDates == nil ) {
        allTaskDeadlineDates = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskDeadlineDate]];
    }
    return allTaskDeadlineDates;
}
+(NSMutableDictionary *)getAllTaskRepeats{
    if ( allTaskRepeats == nil ) {
        allTaskRepeats = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskRepeat]];
    }
    return allTaskRepeats;
}
+(NSMutableDictionary *)getAllTaskNotes{
    if ( allTaskNotes == nil ) {
        allTaskNotes = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskNote]];
    }
    return allTaskNotes;
}
+(NSMutableDictionary *)getAllTaskTags{
    if ( allTaskTags == nil ) {
        allTaskTags = [[NSMutableDictionary alloc]
                        initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            dictionaryForKey:kAllTaskTag]];
    }
    return allTaskTags;
}

+(void)setCurrentKey:(NSString *)key {
    currentKey = key;
}

//ParseCom Add Operation
+(void)setTask:(NSString *)taskName importantAttr:(BOOL)importantAttr effortAttr:(BOOL)effortAttr enjoyAttr:(BOOL)enjoyAttr socialAttr:(BOOL)socialAttr tags:(NSString *)tags deadlineDate:(NSDate *)deadlineDate dueTime:(NSString *)dueTime repeatType:(NSInteger)repeatType notes:(NSString *)notes forKey:(NSString *)key originTaskName:(NSString *)originTaskName{
    
    [allTaskNames setObject:taskName forKey:key];
    [allTaskImportantAttrs setObject:[NSNumber numberWithBool:importantAttr] forKey:key];
    [allTaskEffortAttrs setObject:[NSNumber numberWithBool:effortAttr] forKey:key];
    [allTaskEnjoyAttrs setObject:[NSNumber numberWithBool:enjoyAttr] forKey:key];
    [allTaskSocialAttrs setObject:[NSNumber numberWithBool:socialAttr] forKey:key];
    [allTaskTags setObject:tags forKey:key];
    [allTaskDeadlineDates setObject:deadlineDate forKey:key];
    [allTaskDueTimes setObject:dueTime forKey:key];
    [allTaskRepeats setObject:[NSNumber numberWithInt:repeatType] forKey:key];
    [allTaskNotes setObject:notes forKey:key];
    //ParseCom Edit
    PFQuery *edit = [PFQuery queryWithClassName:@"TaskInteraction"];
    [edit findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                if ([object[@"task_name"] isEqualToString:originTaskName]) {
                    object[@"task_name"] = taskName;
                    object[@"important_attribute"] = [NSNumber numberWithBool:importantAttr];
                    object[@"effort_attribute"] = [NSNumber numberWithBool:effortAttr];
                    object[@"enjoy_attribute"] = [NSNumber numberWithBool:enjoyAttr];
                    object[@"social_attribute"] = [NSNumber numberWithBool:socialAttr];
                    object[@"tags"] = tags;
                    object[@"due_deadline"] = deadlineDate;
                    object[@"estimate_due"] = dueTime;
                    object[@"task_recurring_type"] = [NSNumber numberWithInt:repeatType];
                    object[@"note_str"] = notes;
                    [object saveEventually];
                }
            }
        }
    }];
}

+(NSString *)getCurrentKey{
    return currentKey;
}

+(void)saveTasks{
    
    [[NSUserDefaults standardUserDefaults] setObject:allTaskNames forKey:kAllTaskName];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskImportantAttrs forKey:kAllTaskImportantAttr];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskEffortAttrs forKey:kAllTaskEffortAttr];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskEnjoyAttrs forKey:kAllTaskEnjoyAttr];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskSocialAttrs forKey:kAllTaskSocialAttr];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskDueTimes forKey:kAllTaskDueTime];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskDeadlineDates forKey:kAllTaskDeadlineDate];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskRepeats forKey:kAllTaskRepeat];
    [[NSUserDefaults standardUserDefaults] setObject:allTaskNotes forKey:kAllTaskNote];
}

+(void)setTaskForCurrentKey:(NSString *)taskName importantAttr:(BOOL)importantAttr effortAttr:(BOOL)effortAttr enjoyAttr:(BOOL)enjoyAttr socialAttr:(BOOL)socialAttr tags:(NSString *)tags deadlineDate:(NSDate *)deadlineDate dueTime:(NSString *)dueTime repeatType:(NSInteger)repeatType notes:(NSString *)notes originTaskName:(NSString *)originTaskName
{
    [self setTask:taskName importantAttr:importantAttr effortAttr:effortAttr enjoyAttr:enjoyAttr socialAttr:socialAttr tags:tags deadlineDate:deadlineDate dueTime:dueTime repeatType:repeatType notes:notes forKey:currentKey originTaskName:originTaskName];
  //ParseCom ADD
    PFObject *addObj = [PFObject objectWithClassName:@"TaskInteraction"];
    addObj[@"task_name"] = taskName;
    addObj[@"important_attribute"] = [NSNumber numberWithBool:importantAttr];
    addObj[@"effort_attribute"] = [NSNumber numberWithBool:effortAttr];
    addObj[@"enjoy_attribute"] = [NSNumber numberWithBool:enjoyAttr];
    addObj[@"social_attribute"] = [NSNumber numberWithBool:socialAttr];
    addObj[@"tags"] = tags;
    addObj[@"due_deadline"] = deadlineDate;
    addObj[@"estimate_due"] = dueTime;
    addObj[@"task_recurring_type"] = [NSNumber numberWithInt:repeatType];
    addObj[@"note_str"] = notes;
    [addObj saveEventually];
}

//ParseCom Delete Operation
+(void)removeObjectForKey:(NSString *)key taskName:(NSString *)name{
    [allTaskNames removeObjectForKey:key];
    PFQuery *del = [PFQuery queryWithClassName:@"TaskInteraction"];
    [del findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                if ([object[@"task_name"] isEqualToString:name]) {
                    [object deleteEventually];
                }
            }
        }
    }];
}
@end
