

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

+(void)setTask:(NSString *)taskName importantAttr:(NSInteger)importantAttr effortAttr:(NSInteger)effortAttr enjoyAttr:(NSInteger)enjoyAttr socialAttr:(NSInteger)socialAttr tags:(NSString *)tags deadlineDate:(NSDate *)deadlineDate dueTime:(NSString *)dueTime repeatType:(NSInteger)repeatType notes:(NSString *)notes forKey:(NSString *)key originTaskName:(NSString *)originTaskName;

+(void)setTaskForCurrentKey:(NSString *)taskName importantAttr:(NSInteger)importantAttr effortAttr:(NSInteger)effortAttr enjoyAttr:(NSInteger)enjoyAttr socialAttr:(NSInteger)socialAttr tags:(NSString *)tags deadlineDate:(NSDate *)deadlineDate dueTime:(NSString *)dueTime repeatType:(NSInteger)repeatType notes:(NSString *)notes originTaskName:(NSString *)originTaskName;

+(void)saveTasks;
@end
