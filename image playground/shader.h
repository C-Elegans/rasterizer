//
//  shader.h
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#ifndef shader_h
#define shader_h
#include "vector.h"

color shade(vec2 uv, vec3 normal);
typedef struct{
	int width;
	int height;
	int bytesperpixel;
	color* data;
}texture;
extern texture head_diffuse;
#endif /* shader_h */
