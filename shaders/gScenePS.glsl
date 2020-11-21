#version 330

in vec4 vNormal;

layout(location = 0) out vec4 rtFragColor;

void main()
{
	rtFragColor = normalize(vNormal);
}