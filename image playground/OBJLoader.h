//
//  OBJLoader.h
//  image playground
//
//  Created by Michael Nolan on 2/9/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "vector.hpp"
#import "Vectors.h"
#import "Model.h"
@interface OBJLoader : NSObject
+(void)createModelFromFile:(NSString *)file model:(Model*)model;
@end
