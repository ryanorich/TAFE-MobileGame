extern float height = 0.0;
extern float time = 0.0;

vec4 colTop1 = vec4(0.1, 0.1, 0.9, 1.0);
vec4 colBottom1 = vec4(0.6, 0.6, 0.9, 1.0);

vec4 colTop2 = vec4(0.0, 0.0, 0.0, 1.0);
vec4 colBottom2 = vec4(0.15, 0.1, 0.3, 1.0);

vec4 effect(vec4 color, Image image, vec2 texCoords, vec2 scrCoords) 
    {
        vec4 col;

        vec4 colTop = mix(colTop1, colTop2, sin(time));
        vec4 colBottom = mix(colBottom1, colBottom2, sin(time));
        
        col = mix(colTop, colBottom, scrCoords.y / height);

        return col;
        
    }