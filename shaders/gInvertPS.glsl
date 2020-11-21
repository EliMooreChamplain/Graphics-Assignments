#version 330

layout(location = 0) out vec4 rtFragColor;

uniform sampler2D uTex;

in vec2 vTexCoord;

void main()
{
	vec2 uv = vTexCoord;
	vec4 col = texture(uTex,uv);
	
	
	
	rtFragColor = 1.0 - col;
}