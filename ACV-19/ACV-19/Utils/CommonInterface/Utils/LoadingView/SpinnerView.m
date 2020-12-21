#import "SpinnerView.h"
#import "Pose.h"

@implementation SpinnerView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (CAShapeLayer*) layer {
    return (CAShapeLayer*)super.layer;
}

- (CAShapeLayer*) getLayer {
    return (CAShapeLayer*)super.layer;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self getLayer].fillColor = nil;
    [self getLayer].strokeColor = [UIColor blackColor].CGColor;
    [self getLayer].lineWidth = 3;
    [self setPath];
}

- (void) didMoveToWindow {
    [self animate];
}

- (void) setPath {
    UIBezierPath* bezierPath = ([UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds,  [self getLayer].lineWidth/2,  [self getLayer].lineWidth/2)]);
    [self getLayer].path = bezierPath.CGPath;
}

- (NSArray*) poses {
    NSMutableArray* poses = [[NSMutableArray alloc] init];
    [poses addObject:[[Pose alloc] initWith:0.0 start:0.000 length:0.7]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:0.500 length:0.5]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:1.000 length:0.3]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:1.500 length:0.1]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:1.875 length:0.1]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:2.250 length:0.3]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:2.625 length:0.7]];
    [poses addObject:[[Pose alloc] initWith:0.4 start:3.000 length:0.5]];

    return poses;
}

- (void) animate {
    CFTimeInterval time = 0;
    NSMutableArray* times = [NSMutableArray new];;
    CGFloat start = 0;
    NSMutableArray* rotations = [NSMutableArray new];
    NSMutableArray* strokeEnds  = [NSMutableArray new];

    NSArray* posses = [self poses];
    double totalSeconds = [[posses valueForKeyPath:@"@sum.secondsSincePriorPose"] doubleValue];

    for(Pose* pose in posses){
        time += pose.secondsSincePriorPose;
        [times addObject:[NSNumber numberWithDouble:time/totalSeconds]];
        start = pose.start;
        [rotations addObject:[NSNumber numberWithDouble:start*2*M_PI]];
        [strokeEnds addObject:[NSNumber numberWithDouble:pose.length]];
    }

    [times addObject:[times lastObject]];
    [rotations addObject:[rotations firstObject]];
    [strokeEnds addObject:[strokeEnds firstObject]];

    [self animateKeyPath:@"strokeEnd" duration:totalSeconds times:times values:strokeEnds];
    [self animateKeyPath:@"transform.rotation" duration:totalSeconds times:times values:rotations];

    [self animateStrokeHueWithDuration:totalSeconds * 5];
}

- (void) animateKeyPath:(NSString*)keyPath duration:(CFTimeInterval)duration times:(NSArray*)times values:(NSArray*)values {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.keyTimes = times;
    animation.values = values;
    animation.calculationMode = kCAAnimationLinear;
    animation.duration = duration;
    animation.repeatCount = FLT_MAX;
    [[self getLayer] addAnimation:animation forKey:animation.keyPath];
}

- (void) animateStrokeHueWithDuration:(CFTimeInterval)duration {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    NSMutableArray *keyTimes = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];

    for (NSInteger i = 0; i < 36; i++) {
        [keyTimes addObject: [NSNumber numberWithDouble:(CFTimeInterval)i/(CFTimeInterval)36]];
        [values addObject:(id)[UIColor orangeColor].CGColor];
    }

    animation.keyTimes = keyTimes;
    animation.values = values;
    animation.calculationMode = kCAAnimationLinear;
    animation.duration = duration;
    animation.repeatCount = FLT_MAX;
    [[self getLayer] addAnimation:animation forKey:animation.keyPath];
}

@end
