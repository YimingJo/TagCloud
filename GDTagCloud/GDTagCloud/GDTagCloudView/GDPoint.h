//
//  DBPoint.h
//  sphereTagCloud
//
//  Created by Xinbao Dong on 14/8/31.
//  Copyright (c) 2014年 Xinbao Dong. All rights reserved.
//

#ifndef sphereTagCloud_DBPoint_h
#define sphereTagCloud_DBPoint_h

struct GDPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
    CGFloat xd;
    CGFloat yd;
    CGFloat scale;
};

typedef struct GDPoint GDPoint;


GDPoint GDPointMake(CGFloat x, CGFloat y, CGFloat z) {
    GDPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif
