//
//  Vectors.m
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import "Vectors.h"

@implementation Vec3f : NSObject 
-(vec3)toVec{
	return (vec3){_x,_y,_z};
}
@end
@implementation Vec2f : NSObject
-(vec2)toVec{
	return (vec2){_x,_y};
}
@end
@implementation Vec3i :NSObject;

-(vec3i)toVec{
	return (vec3i){_x,_y,_z};
}

@end
@implementation Face:NSObject


@end