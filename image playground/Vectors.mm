//
//  Vectors.m
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import "Vectors.h"

@implementation Vec3f : NSObject 
-(vec3f)toVec{
	return vec3f(_x,_y,_z);
}
@end
@implementation Vec2f : NSObject
-(vec3f)toVec{
	return vec3f(_x,_y,0);
}
@end
@implementation Vec3i :NSObject;

-(vec3i)toVec{
	return (vec3i){_x,_y,_z};
}

@end
@implementation Face:NSObject


@end