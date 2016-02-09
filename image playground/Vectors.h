//
//  Vectors.h
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "vector.h"
@interface Vec3f : NSObject
@property float x;
@property float y;
@property float z;
-(vec3) toVec;
@end
@interface Vec3i : NSObject
@property int x;
@property int y;
@property int z;
-(vec3i) toVec;
@end
