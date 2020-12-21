#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pose : NSObject

@property CFTimeInterval secondsSincePriorPose;
@property CGFloat start;
@property CGFloat length;

- (instancetype) initWith:(CFTimeInterval)timeInterval start:(CGFloat)start length:(CGFloat)length;

@end

NS_ASSUME_NONNULL_END
