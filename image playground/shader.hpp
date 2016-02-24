//
//  shader.h
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#ifndef shader_h
#define shader_h
#include "newVector.hpp"

color shade(vec3f uv, vec3f normal, vec3f pos);
typedef struct{
	int width;
	int height;
	int bytesperpixel;
	color* data;
}texture;
extern texture head_diffuse;
#endif /* shader_h */
