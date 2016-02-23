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
extern vec3 camera;
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
	
	return gammaCorrect((color){static_cast<uint8_t>(col>>24),static_cast<uint8_t>((col>>16) &255),static_cast<uint8_t>((col>>8)&255),255});
}
color shade(vec2 uv, vec3 normal, vec3 pos){
	float f = -dot3(normal, lightdir);
	if(f<0)return (color){0,0,0,0};
	//float spec = dot3(normal3(sub3(camera,pos)), normal);
	//spec = powf(spec, 20);
	//color s = mulColor(.5*spec, (color){255,255,255,255});
	
	color c = texture2D(uv, head_diffuse);
	uint8_t temp = c.r;
	c.r = c.b;
	c.b = temp;
	c= mulColor(f+0.05, c);
	//c=addColor(c, s);
	return c;
}