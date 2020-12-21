#import "Pose.h"

@implementation Pose

- (instancetype) initWith:(CFTimeInterval)timeInterval start:(CGFloat)start length:(CGFloat)length {
    self = [super init];
    self.start = start;
    self.length = length;
    self.secondsSincePriorPose = timeInterval;
    return self;
}

@end
