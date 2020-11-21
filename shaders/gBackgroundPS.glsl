#version 330

layout(location = 0) out vec4 rtFragColor;

uniform sampler2D uTex;

in vec2 vTexCoord;

void main()
{
	vec2 uv = vTexCoord;
	vec4 col = texture(uTex,uv);
	
	if(col == vec4(0.0,0.0,0.0,0.0))
	{
		col = mix(vec4(1.0,0.2,0.0,1.0),vec4(0.0,0.5,1.0,0.0),uv.y);	
	}
	
	rtFragColor = col;
}