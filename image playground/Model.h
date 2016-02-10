//
//  Model.h
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Vectors.h"
@interface Model : NSObject
@property NSArray<Vec3f*>* vertices;
@property NSArray<Vec3i*>* faces;
@property int numFaces;
@property int numVertices;
@end
