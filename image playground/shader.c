//
//  shader.c
//  image playground
//
//  Created by Michael Nolan on 2/10/16.
//  Copyright © 2016 Michael Nolan. All rights reserved.
//

#include "shader.h"
#include <math.h>
extern vec3 lightdir;
texture head_diffuse;
color gammaCorrect(color c){
	c.r = powf((c.r/255.0),1/2.5);
	c.g = powf((c.r/255.0),1/2.5);
	c.b = powf((c.r/255.0),1/2.5);
	return c;
}
color texture2D(vec2 coords, texture t){
	int x = coords.x * t.width;
	int y = t.height-(coords.y * t.height);
	if(t.bytesperpixel == 4){
		return t.data[y*t.height + x];
	}
	uint8_t* data = (uint8_t*)t.data;
	
	int col= (int)(data[t.bytesperpixel*(y*t.height + x)]);
	
	return gammaCorrect((color){col>>24,(col>>16) &255,(col>>8)&255,255});
}
color shade(vec2 uv, vec3 normal){
	float f = -dot3(normal, lightdir);
	if(f<0)return (color){0,0,0,0};
	
	color c = texture2D(uv, head_diffuse);
	uint8_t temp = c.r;
	c.r = c.b;
	c.b = temp;
	c= mulColor(f, c);
	return c;
}