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

void settings(){
    size(int(windowSize)*2, int(windowSize));    
}

void setup(){
    background(0,0,0);

    sizeMultiplier = windowSize / map.length;
    incrementAngle = fov / windowSize;
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

        float brightness = map(distance, 0, map.length + 2, 50, 255);

        stroke(70);
        line(rayCount, 0, rayCount, height/2 - wallHeight);
        stroke(brightness);
        line(rayCount, height/2 - wallHeight, rayCount, height/2 + wallHeight);
        stroke(0, 50, 0);
        line(rayCount, height/2 + wallHeight, rayCount, height);

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
