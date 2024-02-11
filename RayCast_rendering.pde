float windowSize = 720;
float sizeMultiplier;

float incrementAngle;
int precision = 256;
int fov = 60;
int halfFov = 30;
float playerX = 2;
float playerY = 2;
float playerAngle = 0;

float speed = 0.5;
int rotationSpeed = 5;

float middleRayDist = 100;

int[][] map = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ,1}
};


int textureSize = 8;
int[][] textureMap = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {0, 0, 1, 0, 1, 0, 1, 0, 1, 0},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};

color[] colors = {color(255, 241, 232), color(194, 195, 199)};

int[][] colorMap = {{255, 136, 77}, {153, 153, 153}};

void settings(){
    size(int(windowSize)*2, int(windowSize));    
}

void setup(){
    background(0,0,0);

    sizeMultiplier = windowSize / map.length;
    incrementAngle = fov / windowSize;
}

void drawTexture(int x, int wallHeight, int texturePositionX, int[][] c) {
    float yIncrementer = (wallHeight * 2) / textureSize;
    float y = windowSize/2 - wallHeight;

    for(int i = 0; i < textureSize; i++) {
        stroke(c[textureMap[i][texturePositionX]][0], c[textureMap[i][texturePositionX]][1], c[textureMap[i][texturePositionX]][2]);
        line(x, y, x, y+ (yIncrementer));
        y += yIncrementer;
    }
}

void rayCasting(){
    float rayAngle = playerAngle - halfFov; 
    for(int rayCount = 0; rayCount < windowSize; rayCount++){
        float rayX = playerX;
        float rayY = playerY;

        float rayCos = cos(radians(rayAngle)) / precision;
        float raySin = sin(radians(rayAngle)) / precision;

        // Wall checking
        int wall = 0;
        while(wall == 0) {
            rayX += rayCos*0.05;
            rayY += raySin*0.05;
            wall = map[floor(rayY)][floor(rayX)];
        }

        stroke(255,0,0);
        line(windowSize + playerX*sizeMultiplier, playerY*sizeMultiplier, windowSize + rayX*sizeMultiplier, rayY*sizeMultiplier);

        float distance = sqrt(pow(playerX - rayX, 2) + pow(playerY - rayY, 2));

        distance = distance * cos(radians(rayAngle - playerAngle));

        if(rayCount == floor(windowSize/2)){
            middleRayDist = distance;
        }

        int wallHeight = floor(height/2 / distance);

        int texturePositionX = floor((textureSize * (rayX + rayY)) % textureSize);

        float brightness = map(distance, 0, map.length + 2, 1, 0.2);

        int[][] adjustedColors = new int[2][3];

        for(int i = 0; i < adjustedColors.length; i++){
            for(int j = 0; j < adjustedColors[i].length; j++){
                adjustedColors[i][j] = floor(colorMap[i][j] * brightness);
            }
        }

        stroke(70);
        line(rayCount, 0, rayCount, height/2 - wallHeight);
        drawTexture(rayCount, wallHeight, texturePositionX,  adjustedColors);
        stroke(0, 50, 0);
        line(rayCount, height/2 + wallHeight - (wallHeight * 2) / textureSize, rayCount, height);

        rayAngle += incrementAngle;
    }
}

void keyPressed() {
  if (key == 'W' || key == 'w') {
        float playerCos = cos(radians(playerAngle)) * speed;
        float playerSin = sin(radians(playerAngle)) * speed;
        float newX = playerX + playerCos;
        float newY = playerY + playerSin;

        // Collision test
        if(map[floor(newY)][floor(newX)] == 0) {
            if(middleRayDist < speed) return;
            playerX = newX;
            playerY = newY;
        } 
    }
    if (key == 's' || key == 'S') {
        float playerCos = cos(radians(playerAngle)) * speed;
        float playerSin = sin(radians(playerAngle)) * speed;
        float newX = playerX - playerCos;
        float newY = playerY - playerSin;

        // Collision test
        if(map[floor(newY)][floor(newX)] == 0) {
            playerX = newX;
            playerY = newY;
        } 
    }
   if (key == 'a' || key == 'A') {
        float playerCos = cos(radians(playerAngle-90)) * speed;
        float playerSin = sin(radians(playerAngle-90)) * speed;
        float newX = playerX + playerCos;
        float newY = playerY + playerSin;

        // Collision test
        if(map[floor(newY)][floor(newX)] == 0) {
            if(middleRayDist < speed) return;
            playerX = newX;
            playerY = newY;
        } 
    }
    if (key == 'd' || key == 'D') {
        float playerCos = cos(radians(playerAngle-90)) * speed;
        float playerSin = sin(radians(playerAngle-90)) * speed;
        float newX = playerX - playerCos;
        float newY = playerY - playerSin;

        // Collision test
        if(map[floor(newY)][floor(newX)] == 0) {
            playerX = newX;
            playerY = newY;
        } 
    }
    if(key == 'q' || key == 'Q') {
        playerAngle -= rotationSpeed;
    }
    if(key == 'e' || key == 'E') {
        playerAngle += rotationSpeed;
    } 
}

void renderRayPanel(){
    for(int i = 0; i < map.length; i++){
        for(int j = 0; j < map.length; j++){
            if(map[i][j] == 1){
                stroke(0);
                fill(255);
                rect(windowSize + j * sizeMultiplier, i * sizeMultiplier, sizeMultiplier, sizeMultiplier);
            }
        }
    }
    noStroke();
    fill(255,0,0);
    ellipse(windowSize+playerX*sizeMultiplier, playerY*sizeMultiplier, 10,10);
}

void draw(){
    background(0,0,0);
    rayCasting();
    renderRayPanel();


    textSize(18);
    fill(255,0,0);
    text(frameRate, 40, 40);
}
