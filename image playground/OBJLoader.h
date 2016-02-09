//
//  OBJLoader.h
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "vector.h"

@interface OBJLoader : NSObject
@property vec3* vertices;
@property face* faces;
@property int numFaces;
@property int numVertices;
-(id) init:(NSString*) file;
@end
