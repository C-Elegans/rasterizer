//
//  shader.c
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#include "shader.h"
extern vec3 lightdir;
int shade(vec2 uv, vec3 normal){
	return ((int)(0xFFFFFF* dot3(normal, lightdir)))<<8 | 0xFF;
}