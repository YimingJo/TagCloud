//
//  DBSphereView.m
//  sphereTagCloud
//
//  Created by Xinbao Dong on 14/8/31.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#import "GDTagCloudView.h"
#import "GDPoint.h"

@interface GDTagCloudView() <UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat sin_mAngleX;
@property (nonatomic, assign) CGFloat cos_mAngleX;
@property (nonatomic, assign) CGFloat sin_mAngleY;
@property (nonatomic, assign) CGFloat cos_mAngleY;
@property (nonatomic, assign) CGFloat sin_mAngleZ;
@property (nonatomic, assign) CGFloat cos_mAngleZ;
@property (nonatomic, assign) CGFloat mAngleX;
@property (nonatomic, assign) CGFloat mAngleY;

@property (nonatomic, assign) CGFloat distance;
@end

@implementation GDTagCloudView
{
    NSMutableArray *tags;
    NSMutableArray *coordinate;
    CGPoint last;
    CADisplayLink *timer;
}

- (void)setup {
    self.mAngleX = 0.5;
    self.mAngleY = 0.5;
    self.distance = 1.6;
    self.speed = 0.2;
    self.radius = (NSInteger)(self.frame.size.width/2 * (self.distance/2.0));
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:gesture];
    
    timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoTurnRotation)];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark - initial set

- (void)setCloudTags:(NSArray *)array {
    tags = [NSMutableArray arrayWithArray:array];
    coordinate = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < tags.count; i ++) {
        UIView *view = [tags objectAtIndex:i];
        view.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    }
    
    double phi = 0;
    double theta = 0;
    NSInteger max = tags.count;
    CGFloat p1 = sqrt(max * M_PI);
    for (NSInteger i = 1; i < tags.count+1; i ++) {
        phi = acos(-1.0 + (2.0 * i - 1.0) / max);
        theta = p1 * phi;
        CGFloat x = self.radius*cos(theta)*sin(phi);
        CGFloat y = self.radius*sin(theta)*sin(phi);
        CGFloat z = self.radius*cos(phi);
        
        GDPoint point = GDPointMake(x, y, z);
        NSValue *value = [NSValue value:&point withObjCType:@encode(GDPoint)];
        [coordinate addObject:value];
    }
    [self sineCosineAngleX:self.mAngleX AngleY:self.mAngleY AngleZ:0];
    [self updateAll];
    [self timerStart];
}

#pragma mark - autoTurnRotation

- (void)timerStart
{
    timer.paused = NO;
}

- (void)timerStop
{
    timer.paused = YES;
}

- (void)timerInvalid {
    [timer invalidate];
}

- (void)autoTurnRotation {
    CGFloat originX = self.mAngleX;
    CGFloat originY = self.mAngleY;
    //改变速度
    if (self.mAngleX > self.speed) {
        self.mAngleX -= self.speed/2;
    }
    if (self.mAngleY > self.speed) {
        self.mAngleY -= self.speed/2;
    }
    if (self.mAngleX < -self.speed) {
        self.mAngleX += self.speed/2;
    }
    if (self.mAngleY < -self.speed) {
        self.mAngleY += self.speed/2;
    }
    if (originX == self.mAngleX && originY == self.mAngleY) {
        
    } else {
        [self sineCosineAngleX:self.mAngleX AngleY:self.mAngleY AngleZ:0];
    }
    [self updateAll];
}

#pragma mark - gesture selector

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        last = [gesture locationInView:self];
        [self timerStop];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [gesture locationInView:self];
        CGFloat dx = current.x - last.x;
        CGFloat dy = current.y - last.y;
        last = current;
        CGFloat originX = self.mAngleX;
        CGFloat originY = self.mAngleY;
        self.mAngleX = (dy/self.radius)*2.0*8.0;
        self.mAngleY = (-dx/self.radius)*2.0*8.0;
        if (self.mAngleX == 0 && self.mAngleY == 0) {
            self.mAngleX = originX;
            self.mAngleY = originY;
        }
        [self sineCosineAngleX:self.mAngleX AngleY:self.mAngleY AngleZ:0];
        [self updateAll];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint current = [gesture locationInView:self];
        CGFloat dx = current.x - last.x;
        CGFloat dy = current.y - last.y;
        last = current;
        CGFloat originX = self.mAngleX;
        CGFloat originY = self.mAngleY;
        self.mAngleX = (dy/self.radius)*2.0*8.0;
        self.mAngleY = (-dx/self.radius)*2.0*8.0;
        if (self.mAngleX == 0 && self.mAngleY == 0) {
            self.mAngleX = originX;
            self.mAngleY = originY;
        }
        [self sineCosineAngleX:self.mAngleX AngleY:self.mAngleY AngleZ:0];
        [self updateAll];
        [self timerStart];
    }
}

- (void)sineCosineAngleX:(CGFloat)mAngleX
                  AngleY:(CGFloat)mAngleY
                  AngleZ:(CGFloat)mAngleZ {
    double degToRad = (M_PI / 180.0);
    self.sin_mAngleX = sin(mAngleX * degToRad);
    self.cos_mAngleX = cos(mAngleX * degToRad);
    self.sin_mAngleY = sin(mAngleY * degToRad);
    self.cos_mAngleY = cos(mAngleY * degToRad);
    self.sin_mAngleZ = sin(mAngleZ * degToRad);
    self.cos_mAngleZ = cos(mAngleZ * degToRad);
}

- (void)updateAll {
    //update transparency/scale for all tags:
    NSInteger max = tags.count;
    for (int j = 0; j < max; j++) {
        NSValue *value = [coordinate objectAtIndex:j];
        GDPoint point;
        [value getValue:&point];
        
        CGFloat rx1 = point.x;
        CGFloat ry1 = point.y * self.cos_mAngleX +
        point.z * -self.sin_mAngleX;
        CGFloat rz1 = point.y * self.sin_mAngleX +
        point.z * self.cos_mAngleX;
        // multiply new positions by a y-rotation matrix
        CGFloat rx2 = rx1 * self.cos_mAngleY + rz1 * self.sin_mAngleY;
        CGFloat ry2 = ry1;
        CGFloat rz2 = rx1 * -self.sin_mAngleY + rz1 * self.cos_mAngleY;
        // multiply new positions by a z-rotation matrix
        CGFloat rx3 = rx2 * self.cos_mAngleZ + ry2 * -self.sin_mAngleZ;
        CGFloat ry3 = rx2 * self.sin_mAngleZ + ry2 * self.cos_mAngleZ;
        CGFloat rz3 = rz2;
        // set arrays to new positions
        GDPoint rPoint = GDPointMake(rx3, ry3, rz3);
        CGFloat diameter = self.distance*self.radius;
        CGFloat per = diameter / 1.0f / (diameter + rz3);
        // let's set position, scale, alpha for the tag;
        rPoint.xd = rx3 * per;
        rPoint.yd = ry3 * per;
        rPoint.scale = per/2;
        
        value = [NSValue value:&rPoint withObjCType:@encode(GDPoint)];
        coordinate[j] = value;
        [self setTagOfPoint:rPoint andIndex:j];
    }
}


- (void)setTagOfPoint:(GDPoint)point
             andIndex:(NSInteger)index {
    UIView *view = [tags objectAtIndex:index];
    CGFloat transfrom = pow(point.scale*0.8,2);
    if (transfrom < 0.15) {
        transfrom = 0.15;
    }
    view.center = CGPointMake(self.frame.size.width/2.0+point.xd, self.frame.size.width/2.0+point.yd);
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, transfrom, transfrom);
    view.alpha = transfrom;
}

@end


