//------LIBRERIA - x suoni------
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
//------LIBRERIA - x gif animate------
import gifAnimation.*;

//------Variabili globali------
float minX, minY, minX2, minY2;
float secX, secY, secX2, secY2;
float oreX, oreY, oreX2, oreY2;
float quadX, quadY;
//------Cordinate bottoni------
float minPlusX, minPlusY, orePlusX, orePlusY;
float minLessX, minLessY, oreLessX, oreLessY;
float resetX, resetY;
float button_w, button_h;
//------Angoli lancette------
float angMin, angSec, angOre;   //Angoli lancette - ora di sistema
int setMin, setSec, setHour;
int sec, minu, ora;
//Conta frame - x gestione animazione e lo scoccare dell'ora
int frameCont=0, frameCont2=120;
//------Immagini e gif animate------
PImage quadrante;
PImage lancMin, lancSec, lancOre;
PImage sfondo;
Gif fight;
//------Audio------
Minim minim;
AudioPlayer spadeFight;
void setup() {
  size(500, 700);
  //Carico immagini
  quadrante = loadImage("./img/quadrante2.gif");
  lancMin = loadImage("./img/Minuti.gif");
  lancSec = loadImage("./img/Secondi.gif");
  lancOre = loadImage("./img/ore.gif");
  sfondo = loadImage("./img/galassia.gif");
  background(sfondo);
  //Carico suoni
  minim = new Minim(this);
  spadeFight = minim.loadFile("./music/spadeFight.wav");
  fight = new Gif(this, "./img/fight.gif");
  fight.jump(3);
  fight.pause();
  //Cordinate e dimensioni bottoni x settaggio ora.
  minPlusX= 400;
  minPlusY= 100;
  orePlusX= 400;
  orePlusY= 120;

  minLessX= 450;
  minLessY= 100;
  oreLessX= 450;
  oreLessY= 120;

  resetX=425;
  resetY=140;

  button_w = 40;
  button_h=13;
  //Cordinate quadrante e lancette
  quadX=(width/2)-quadrante.width/2;
  quadY=130;

  secX=width/2-(lancSec.width/2);
  secY=quadY+120-(lancSec.height-5);
  angSec = (TWO_PI/60)*second();

  minX=width/2-(lancMin.width/2);
  minY=quadY+120-(lancMin.height-5);
  angMin = (TWO_PI/60)*minute();

  oreX=width/2-(lancOre.width/2);
  oreY=quadY+120-(lancOre.height-5);
  angOre = (TWO_PI/12)*hour();

  //Variabili x la modifica manuale dell'ora.
  setMin=0;
  setSec=0;
  setHour=0;

  textSize(10);
}
void draw() {
  background(sfondo);
  sec = second();
  minu = minute();
  ora = hour();
  angSec = (TWO_PI/60)*(sec+setSec);
  angMin = (TWO_PI/60)*(minu+setMin);
  angOre = (TWO_PI/12)*(ora+setHour);
  if (setSec!=0 || setMin!=0 || setHour!=0) {//Ora modificata manualmente
    if ((minu+setMin)%60==0 && frameCont==0) {//Scocca l'ora.
      setHour++;
      frameCont++;
    } else if ((minu+setMin)%60!=0)frameCont=0;
  }
  //println("frameCont2: "+frameCont2);
  image(fight, 200, height-fight.height);//Gif animata/non animata
  if ((sec+setSec)%60==0 && (minu+setMin)%60==0) {//Allo scoccare dell'ora parte il suono e la animazione della gif.
    if (fight.isPlaying()==false) {
      fight.play();//Parte l'animazione
      spadeFight.play();//Parte il suono
    }
    frameCont2=60;
  } else {
    if (fight.isPlaying()==true)frameCont2--;
    if (fight.isPlaying()==true && frameCont2==0) { //Stoppa l'animazione e il suono dopo 60 ripetizioni della draw (1 sec)
      fight.pause();
      fight.stop();
      fight.jump(3);
      spadeFight.pause();
      spadeFight.rewind();
      frameCont2=0;
    }
  }

  //ellipse(width/2, height/2, 100, 100);  //Quadrante
  image(quadrante, quadX, quadY);  //Quadrante

  rect(minPlusX, minPlusY, button_w, button_h, 7);//Button minuti++
  rect(orePlusX, orePlusY, button_w, button_h, 7);//Button ore++
  rect(minLessX, minLessY, button_w, button_h, 7);//Button minuti--
  rect(oreLessX, oreLessY, button_w, button_h, 7);//Button ore--
  rect(resetX, resetY, button_w, button_h, 7);//Button rest ora di sistema
  fill(0);
  text("m++", minPlusX+10, minPlusY+10);
  text("m--", minLessX+10, minLessY+10);
  text("h++", orePlusX+10, orePlusY+10);
  text("h--", oreLessX+10, oreLessY+10);
  text("reset", resetX+7, resetY+10);
  fill(255);

  pushMatrix();     //MINUTI
  translate(minX+lancMin.width/2, minY+lancMin.height);    //In alto a sinistra per rotazione.
  rotate(angMin); //Rotazione
  translate(-(minX+lancMin.width/2), -(minY+lancMin.height)); //traslazione al punto originario.
  image(lancMin, minX, minY);//minuti
  popMatrix();

  pushMatrix();  //SECONDI
  translate(secX+lancSec.width/2, secY+lancSec.height);    //In alto a sinistra per rotazione.
  rotate(angSec); //Rotazione
  translate(-(secX+lancSec.width/2), -(secY+lancSec.height)); //traslazione al punto originario.
  image(lancSec, secX, secY);//secondi
  popMatrix();

  pushMatrix();  //ORE
  translate(oreX+lancOre.width/2, oreY+lancOre.height);    //In alto a sinistra per rotazione.
  rotate(angOre); //Rotazione
  translate(-(oreX+lancOre.width/2), -(oreY+lancOre.height)); //traslazione al punto originario.
  image(lancOre, oreX, oreY);//ore
  popMatrix();
}
void mousePressed() {
  if (mouseX>=minPlusX && mouseX<=minPlusX+button_w && mouseY>=minPlusY && mouseY<=minPlusY+button_h) {//Minuti++
    println("m++");
    //println("setMin: "+setMin);
    //println("angMin: "+angMin);
    //angMin = angMin+((6*PI)/180);
    //println("sec: "+sec);
    //println("min: "+min);
    //println("ora: "+ora);
    //println("setSec: "+setSec);
    //println("setMin: "+setMin);
    //println("setHour: "+setHour);
    //println(" ");
    setMin++;
    if ((minu+setMin)%60==0) {
      setHour=setHour-1;
    }
    //println("sec: "+sec);
    //println("min: "+min);
    //println("ora: "+ora);
    //println("setSec: "+setSec);
    //println("setMin: "+setMin);
    //println("setHour: "+setHour);
  }
  if (mouseX>=minLessX && mouseX<=minLessX+button_w && mouseY>=minLessY && mouseY<=minLessY+button_h) {//Minuti--
    println("m--");
    //angMin = angMin-((6*PI)/180);
    setMin--;
    if ((minu+setMin)%60==0) {
      setHour=setHour-1;
    }
  }
  if (mouseX>=orePlusX && mouseX<=orePlusX+button_w && mouseY>=orePlusY && mouseY<=orePlusY+button_h) {//Ore++
    println("h++");
    //angOre = angOre+((30*PI)/180);
    setHour++;
  }
  if (mouseX>=oreLessX && mouseX<=oreLessX+button_w && mouseY>=oreLessY && mouseY<=oreLessY+button_h) {//Ore--
    println("h--");
    //angOre = angOre-((30*PI)/180);
    setHour--;
  }
  if (mouseX>=resetX && mouseX<=resetX+button_w && mouseY>=resetY && mouseY<=resetY+button_h) {//Ore--
    println("reset");
    setSec=0;
    setMin=0;
    setHour=0;
  }
}
