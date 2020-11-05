#version 330

in vec2 vTexCoord;
in vec3 normal;
in vec4 position;
in float time;

uniform sampler2D uTex;

layout (location = 0) out vec4 rtFragColor;

struct sPL
{
	vec4 center;
	vec4 color;
	float intensity;
};

void main() {
	
	sPL pl;
	pl.center = vec4(5,5,5,1);
	pl.color = vec4(1,1,1,1);
	pl.intensity = 1000.0;
	
	vec3 lightVector = normalize(pl.center.xyz);
	float diffuseCoefficient = max(0.0,dot(normal,lightVector));
	
	float slDist = distance(pl.center.xyz,position.xyz);
	
	//Distance over intensity
    float dOi = (slDist/pl.intensity);
    
    float attenuatedIntensity = 1.0/(1.0 + dOi + (dOi * dOi));
    
    float diffuseIntensity = diffuseCoefficient * attenuatedIntensity;
    
    float specIntensity;   //Specular Intensity
    float specCo;          //Specular Coefficient
    vec3 viewVec;          //View Vector
    vec3 halfVec;          //Halfway Vector
    
    viewVec = normal;
        
    halfVec = normalize(lightVector + viewVec);
        
    specCo = max(0.0,dot(normal,halfVec));
    
    specIntensity = pow(specCo, 16.0 * 4.0);
	
	vec2 offset = vec2(time * 0.125,0);
	
	vec4 color = texture(uTex, vTexCoord + offset);//vec4(normal,1);
	
	vec4 globalAmbientColor = color;
	float globalAmbientIntensity = 0.15;
	
	vec4 finalColor = 
        globalAmbientColor * globalAmbientIntensity +
        (
            (diffuseIntensity * color) + 
            (specIntensity) 
        ) * pl.color;
    
    
	rtFragColor = finalColor;//texture(uTex, vTexCoord);
}