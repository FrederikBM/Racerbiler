//populationSize: Hvor mange "controllere" der genereres, controller = bil & hjerne & sensorer
int       populationSize  = 100;    
int       generationalBorder = 40;
int       newPopulationSize = 100;

Car car = new Car();
CarController controller = new CarController();

//CarSystem: Indholder en population af "controllere" 
CarSystem carSystem       = new CarSystem(populationSize);

//trackImage: RacerBanen , Vejen=sort, Udenfor=hvid, Målstreg= 100%grøn 
PImage    trackImage;

void setup() {
  size(500, 600);
  trackImage = loadImage("track.png");
  car.pos = new PVector(60, 232);
  controller.varians = 2;
  for (int i=0; i<populationSize; i++) { 
    CarController controller = new CarController();
    carSystem.CarControllerList.add(controller);
  }
  
}

void draw() {
  clear();
  fill(255);
  rect(0, 50, 1000, 1000);
  image(trackImage, 0, 80);  
  text("Dette program er lavet til at lave den bedste mulige racerbil",10,10);
  text("Kriterierne er hvor hurtig den kører og om den ryger ud af banen",10,25);
  text("disse kriterier bliver opdateret så der til sidst kun er de bedste af bedste",10,40);
  
  carSystem.updateAndDisplay();

  //Sorterer bilerne så dem der ryger ud af banen fjernes
  //og dem der ikke er nået langt på banen.
  //Den bedste bil bliver klonet og kravene for at blive på banen bliver større.
  if (frameCount%200==0) {
    generationalBorder=generationalBorder+10;
    newPopulationSize=newPopulationSize-10;
    println("FJERN DEM DER KØRER UDENFOR BANEN frameCount: " + frameCount);
    for (int i = carSystem.CarControllerList.size()-1; i >= 0; i--) {
      SensorSystem s = carSystem.CarControllerList.get(i).sensorSystem;
      if (s.whiteSensorFrameCount > 0||s.clockWiseRotationFrameCounter<generationalBorder) {
        carSystem.CarControllerList.remove(carSystem.CarControllerList.get(i));
      }
      //println(s.lapTimeInFrames);
    }
    if (carSystem.CarControllerList.size()>0) {
      for (int i = 0; i<newPopulationSize; i++) {
        

        carSystem.CarControllerList.add(carSystem.CarControllerList.get(0));
        car.pos = new PVector(60, 232);
        car.vel = new PVector(0, 5);
        
      }
    }
  }

  if (carSystem.CarControllerList.size()==0) {
    setup();
    println(carSystem.CarControllerList.size());
  }
}

//
