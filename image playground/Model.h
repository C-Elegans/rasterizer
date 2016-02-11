//
//  Model.h
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Vectors.h"
#import <GLKit/GLKit.h>

@interface Model : NSObject
@property NSArray<Vec3f*>* vertices;
@property NSArray<Face*>* faces;
@property NSArray<Vec2f*>* uvs;
@property NSArray<Vec3f*>* normals;
@property vec3 position;
@property vec3 rotation;
@property int numFaces;
@property int numVertices;
-(id)initFromFile:(NSString*)file position:(vec3)pos rotation:(vec3)rot;
-(GLKMatrix4)getModelMatrix;
@end
