//
//  Vectors.h
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "newVector.hpp"
#include "vector.hpp"
@interface Vec3f : NSObject
@property float x;
@property float y;
@property float z;
-(vec3f) toVec;
@end
@interface Vec2f : NSObject
@property float x;
@property float y;

-(vec3f) toVec;
@end
@interface Vec3i : NSObject
@property int x;
@property int y;
@property int z;
-(vec3i) toVec;
@end

@interface Face: NSObject
@property int v1;
@property int v2;
@property int v3;
@property int n1;
@property int n2;
@property int n3;
@property int uv1;
@property int uv2;
@property int uv3;
@end

