//
//  TaskListModel.h
//  TaskInteraction
//
//  Created by Vallis Durand on 14/02/15.
//  Copyright (c) 2015 Vallis Durand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface TaskListModel : NSObject

+(TaskListModel *)sharedTaskListModel;

+(NSMutableDictionary *)getAllTaskName;
+(NSMutableDictionary *)getAllTaskImportantAttr;
+(NSMutableDictionary *)getAllTaskEffortAttr;
+(NSMutableDictionary *)getAllTaskEnjoyAttr;
+(NSMutableDictionary *)getAllTaskSocialAttr;
+(NSMutableDictionary *)getAllTaskDueTime;
+(NSMutableDictionary *)getAllTaskDeadlineDates;
+(NSMutableDictionary *)getAllTaskRepeats;
+(NSMutableDictionary *)getAllTaskNotes;
+(NSMutableDictionary *)getAllTaskTags;

+(void)setCurrentKey:(NSString *)key;
+(NSString *)getCurrentKey;
+(void)removeObjectForKey:(NSString *)key taskName:(NSString *)name;

+(void)setTask:(NSString *)taskName importantAttr:(BOOL)importantAttr effortAttr:(BOOL)effortAttr enjoyAttr:(BOOL)enjoyAttr socialAttr:(BOOL)socialAttr tags:(NSString *)tags deadlineDate:(NSDate *)deadlineDate dueTime:(NSString *)dueTime repeatType:(NSInteger)repeatType notes:(NSString *)notes forKey:(NSString *)key originTaskName:(NSString *)originTaskName;

+(void)setTaskForCurrentKey:(NSString *)taskName importantAttr:(BOOL)importantAttr effortAttr:(BOOL)effortAttr enjoyAttr:(BOOL)enjoyAttr socialAttr:(BOOL)socialAttr tags:(NSString *)tags deadlineDate:(NSDate *)deadlineDate dueTime:(NSString *)dueTime repeatType:(NSInteger)repeatType notes:(NSString *)notes originTaskName:(NSString *)originTaskName;

+(void)saveTasks;
@end
