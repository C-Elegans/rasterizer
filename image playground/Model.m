//
//  Model.m
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import "Model.h"
#import "OBJLoader.h"
@implementation Model
-(id)initFromFile:(NSString *)file position:(vec3)pos rotation:(vec3)rot{
	self = [super init];
	[OBJLoader createModelFromFile:file model:self];
	self.position = pos;
	self.rotation = rot;
	
	return self;
}
-(GLKMatrix4)getModelMatrix{
	GLKMatrix4 matrix = GLKMatrix4Identity;
	
	matrix = GLKMatrix4RotateX(matrix, self.rotation.x);
	matrix = GLKMatrix4RotateY(matrix, self.rotation.y);
	matrix = GLKMatrix4RotateZ(matrix, self.rotation.z);
	matrix = GLKMatrix4Translate(matrix, self.position.x, self.position.y, self.position.z);
	return matrix;
}
@end
