//**************************************************************************************************
//*****PROJET MUX101********************************************************************************
//*****réalisé par Julien Caubet********************************************************************
//*****Monitoring de klaxons************************************************************************
//**************************************************************************************************
//**************************************************************************************************

import processing.sound.*;


//variables coordonnees
float dTextX, dTextY, dTextW, dTextH;//fenetre text
float dPositionX, dPositionY, dPositionW, dPositionH;//fenetre position
float dAideX, dAideY, dAideW, dAideH;//fenetre aide
float dAmplitudeX, dAmplitudeY, dAmplitudeW, dAmplitudeH;//fenetre amplitude
float dFftX, dFftY, dFftW, dFftH;//fenetre fft
float dVumetreX, dVumetreY, dVumetreW, dVumetreH;//fenetre Vu metre
float dCompteurX, dCompteurY, dCompteurW, dCompteurH;//fenetre compteur
float dVolumeX, dVolumeY, dVolumeW, dVolumeH;//fenetre volume

//variables fenetre positions
color[] posCol = {color(0,0,255),color(0,255/4,255/2),color(0,255/3,255/3),color(0,255/2,255/4),color(255/4,255,255/4),color(255/4,255/2,255/4),color(255/4,255/3,0),color(255/3,255/4,0),color(255/2,0,0),color(255,0,0)};

//variables Text et export
boolean exportOk = false;
color exportCol = color(40);

//variables FFT
FFT fft;
int bands = 2048;
float[] spectrum = new float[bands];

//variables amplitude
Amplitude amp,amp2;
int i =0;
boolean clAmp = true;
color colAmp = color(100,100,100);

//variable slider volume
float volX = 0;

//variables Sound
Sound s;
float amplitude = 0.8;

//variables klaxons
KlaxonGenerator klaGen;
Klaxon klaxon;

//variables Aide
String aideTextIni ="\n\nSURVOLEZ avec le curseur une fenêtre pour connaitre sa fonction.\n\nAPPUYEZ sur la touche 'ESC' pour fermer l' application.";
String aideText = aideTextIni;

//variables Compteur
String compteur;
int compteurFlag = 0;
color select = color(0,100,255);
color unSelect = color(100);
color cBout1 = select;
color cBout2 = unSelect;

//***************************************************
//*******************SETUP***************************
//***************************************************

void setup(){
  
//fullScreen();
size(900,700);
background(100,100,100);

// Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  
// Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  amp2 = new Amplitude(this);
  
// Create a Sound object for globally controlling the output volume.
  s = new Sound(this);  
  
//definition des divers coordonnées des fenetres
dTextX=width*0.03; dTextY=height*0.03; dTextW=width*0.4; dTextH=height*0.4;
dPositionX=width*0.03; dPositionY=height*0.45; dPositionW=width*0.4; dPositionH=height*0.5;
dAideX=width*0.45; dAideY=height*0.70; dAideW=width*0.52; dAideH=height*0.25;
dAmplitudeX=width*0.45; dAmplitudeY=height*0.43; dAmplitudeW=width*0.52; dAmplitudeH=height*0.25;
dFftX=width*0.45; dFftY=height*0.16; dFftW=width*0.30; dFftH=height*0.25;//0.52
dVumetreX=width*0.77; dVumetreY=height*0.16; dVumetreW=width*0.20; dVumetreH=height*0.25;
dCompteurX=width*0.45; dCompteurY=height*0.03; dCompteurW=width*0.3; dCompteurH=height*0.11;
dVolumeX=width*0.77; dVolumeY=height*0.03; dVolumeW=width*0.2; dVolumeH=height*0.11;

volX = dVolumeX+(dVolumeW - ((dVolumeW/10)*2));
i=(int)dAmplitudeX;
klaGen = new KlaxonGenerator(this);
generer();


}
//***********************
//*******FIN SETUP*******
//***********************




//**************************************************************
//************************DRAW**********************************
//**************************************************************

void draw(){
  
//creation d un nouveau klaxon
delais();

//appel des methodes dessin 
dessinText();
dessinPosition();
dessinAide();
dessinAmplitude();
dessinFft();
dessinVumetre();
dessinCompteur();
dessinVolume();

//rollover
rollOver();

//exportCol
exportCol();

}
//********************************
//********FIN DRAW****************
//********************************


//************************************************
//**********Autres Méthodes***********************
//************************************************

//methode "delais" qui bloque pas le draw
void delais(){
int o = (int)random(frameCount,frameCount+800);
if(o==frameCount+2)generer();
}

//methode generer un nouveau klaxon
void generer(){
if(klaGen.getOk()){
klaxon = klaGen.generer();
klaxon.getFile().play();
fft.input(klaxon.getFile());
amp.input(klaxon.getFile());
amp2.input(klaxon.getFile());
}
}

//methode exportCol
void exportCol(){
  if(exportOk){exportCol = color(150);}
  else{exportCol = color(40);}
  exportOk=false;
}


//*****************************************************
//*** methode affichage des informations en texte******
//*****************************************************

void dessinText(){
  
  //affichage grand rectangle arriere
  fill(255);
  rect(dTextX,dTextY,dTextW,dTextH);
  
  //affichage du bouton EXPORT
  fill(exportCol);
  rect(dTextX,dTextY+(dTextH-(dTextH/8)),dTextW,dTextH/8);
  
  //affichage text export
  fill(255);
  text("Cliquez ici pour exporter les informations sur un fichier .txt",dTextX+dTextW/12,dTextY+(dTextH-(dTextH/20)));
  
  //affichage text klaxons
  fill(100);
  String str = "";
  
  if(klaGen.infoTab().length<7){
    for(int i=0; i<klaGen.infoTab().length;i++){
      str += klaGen.infoTab()[i]+"\n\n";
    }
  }else{
    for(int i=0; i<7;i++){
      str += klaGen.infoTab()[i]+"\n\n";
    }
  }
  text(str,dTextX+dTextW/8,dTextY+20);

}

//******************************************
//*****methode affichage des positions******
//******************************************

void dessinPosition(){
  
fill(80);
rect(dPositionX, dPositionY, dPositionW, dPositionH);

  int i = 10;
  int j= 1;
  Stack<Klaxon> k = klaGen.getSaveKlaxon();
  
  while( i>=0 ){
    if(i<k.size() && j < 10){
      fill(posCol[j]);
      ellipse(dPositionX+k.elementAt(k.size()-j).getPositionX()+40,dPositionY+k.elementAt(k.size()-j).getPositionY()+40,35+random(-2,2),35+random(-2,2));
      j++;
    }
    i--; 
  }
}

//*****************************************************
//*******methode affichage de la fenetre d aide********
//*****************************************************

void dessinAide(){
  
fill(0,100,255);
rect(dAideX, dAideY, dAideW, dAideH);
fill(255);
textSize(13);
text(aideText, dAideX+(dAideW/16), dAideY+(dAideH/8)); 
textSize(11);

}

//********************************************************
//*******methode affichage de la fenetre Amplitude********
//********************************************************

void dessinAmplitude(){
  
  clearAmplitude();//appel de la methode pour effacer la fenetre
  int haut = (int)(dAmplitudeY + dAmplitudeH);
  int large = (int)(dAmplitudeX + dAmplitudeW);
  stroke(colAmp);
  
  if(i<large){
    line(i,haut,i,haut -(dAmplitudeH*amp.analyze()));
    i++;
  }if(i==large){i=(int)dAmplitudeX; colAmp = color(random(0,255),random(0,255),random(0,255));}
  stroke(0);
}

void clearAmplitude(){
  if(clAmp){
    fill(255);
    rect(dAmplitudeX, dAmplitudeY, dAmplitudeW, dAmplitudeH);
    clAmp = false;
  }
}

//***********************************************
//*******methode affichage de la FFT*************
//***********************************************

void dessinFft(){
  
  fill(255);
  rect(dFftX, dFftY, dFftW, dFftH);
  int barT = (int)dFftW/10;
  
  for(int i =0 ; i<10 ; i++){
    stroke(100);
    line(dFftX+barT,dFftY,dFftX+barT,dFftY+dFftH);
    stroke(0);
    barT += (int)dFftW/10;
  }
  
  fft.analyze(spectrum);
  
  for(int i = 0; i < bands/3; i++){
    // dessin des lignes fft
    stroke(0,100,255);
    line( map(i,0,bands/3,dFftX,dFftX+dFftW), dFftY+dFftH, map(i,0,bands/3,dFftX,dFftX+dFftW), (dFftY+dFftH) - constrain(spectrum[i],0,0.2)*dFftH*5 );
    stroke(0);
  } 
}

//*********************************************
//*******methode affichage du VU METRE*********
//*********************************************

void dessinVumetre(){
  
  fill(255);
  rect(dVumetreX, dVumetreY, dVumetreW, dVumetreH);
  fill(100);
  rect(dVumetreX, dVumetreY +dVumetreH - (dVumetreH/4), dVumetreW, dVumetreH/4);
  
  //quelques variables en +
  float o = dVumetreW/2;
  float p = dVumetreY + dVumetreH - (dVumetreH/4);
  float ty = map(amp2.analyze(),0.0,1.0,PI,2*PI);  
  float x = (dVumetreX+o)+o*cos(ty);
  float y = p+o*sin(ty);
  
    
  //dessin camemberts de couleur
  fill(0,255,0);
  arc(dVumetreX + dVumetreW/2,p, dVumetreW, dVumetreW,PI, PI+QUARTER_PI);
  fill(255,255,0);
  arc(dVumetreX + dVumetreW/2,p, dVumetreW, dVumetreW,PI+QUARTER_PI, PI+HALF_PI);
  fill(255,150,0);
  arc(dVumetreX + dVumetreW/2,p, dVumetreW, dVumetreW,PI+HALF_PI, PI+HALF_PI+QUARTER_PI);
  fill(255,0,0);
  arc(dVumetreX + dVumetreW/2,p, dVumetreW, dVumetreW,PI+HALF_PI+QUARTER_PI, TWO_PI);
  
  fill(100);

  strokeWeight(2);
  line(dVumetreX + dVumetreW/2,p,x,y);
  strokeWeight(1);
  ellipse(dVumetreX + dVumetreW/2,p,10,10);
  
}

//*****************************************
//*****methode affichage du compteur*******
//*****************************************

void dessinCompteur(){
  
  fill(255);
  rect(dCompteurX, dCompteurY, dCompteurW, dCompteurH);
  fill(50);
  rect(dCompteurX, dCompteurY, dCompteurW/2, dCompteurH);
  fill(cBout1);
  rect(dCompteurX+(dCompteurW/2),dCompteurY,dCompteurW/2,dCompteurH/2);
  fill(255);
  text("nbr total de klaxon",dCompteurX+(dCompteurW/2)+(dCompteurW/12),dCompteurY+(dCompteurH/3.5));
  fill(cBout2);
  rect(dCompteurX+(dCompteurW/2),dCompteurY+(dCompteurH/2),dCompteurW/2,dCompteurH/2);
  fill(255);
  text("nbr de seconds\ndepuis le debut:\n",dCompteurX+(dCompteurW/2)+(dCompteurW/12),dCompteurY+(dCompteurH/2)+(dCompteurH/5.8));
  
  //test du Flag
  if(compteurFlag == 0){
    if(klaGen.getNbKlaxons()<9999){
    fill(255);
    textSize(36);
    text(klaGen.getNbKlaxons(),dCompteurX+(dCompteurW/5),dCompteurY+(dCompteurH/1.5));//
    textSize(11);}

  }
  if(compteurFlag == 1){
    if(klaGen.compteSeconds()<9999){
    fill(255);
    textSize(36);
    text(klaGen.compteSeconds(),dCompteurX+(dCompteurW/7),dCompteurY+(dCompteurH/1.5));
    textSize(11);}

  }
}

//***********************************************
//*******methode affichage du Volume*************
//***********************************************

void dessinVolume(){
  
  fill(255);
  rect(dVolumeX, dVolumeY, dVolumeW, dVolumeH);
  fill(50);
  rect(dVolumeX, dVolumeY, dVolumeW, dVolumeH/2);
  line(dVolumeX,dVolumeY+(dVolumeH/4),dVolumeX+dVolumeW,dVolumeY+(dVolumeH/4));
  fill(100);
  rect(volX, dVolumeY, dVolumeW/10, dVolumeH/2);
  s.volume(amplitude);
  text("Volume audio: "+(int)(amplitude*100)+"%",dVolumeX+(dVolumeW/6),dVolumeY+dVolumeH-(dVolumeH/4.5));
}

//*************************************************
//***************methodes MOUSE********************
//*************************************************

void mouseClicked() {

  //boutons compteur
  if(mouseX > dCompteurX+(dCompteurW/2)&& mouseY > dCompteurY && mouseX < dCompteurX+(dCompteurW) && mouseY < dCompteurY+(dCompteurH/2)){
     cBout1 = select;
     cBout2 = unSelect;
     compteurFlag = 0;
  }
  if(mouseX > dCompteurX+(dCompteurW/2)&& mouseY > dCompteurY+(dCompteurH/2) && mouseX < dCompteurX+(dCompteurW) && mouseY < (dCompteurY+(dCompteurH/2))+ dCompteurH){
     cBout1 = unSelect;
     cBout2 = select;      
     compteurFlag = 1;
  }
  
  //effacement fenetre amplitude
  if(mouseX > dAmplitudeX && mouseX < dAmplitudeX + dAmplitudeW && mouseY > dAmplitudeY && mouseY < dAmplitudeY + dAmplitudeH){
  clAmp=true;
  }
  
  //export des informations texte
  if(mouseX > dTextX && mouseY > dTextY+(dTextH-(dTextH/8)) && mouseX < dTextX+dTextW && mouseY < dTextY+dTextH){ 
    saveStrings("export.txt",klaGen.infoTab());
  }
}

void mouseDragged(){  
  if(mouseX < dVolumeX+(dVolumeW - (dVolumeW/10)) && mouseX > dVolumeX){
    volX = mouseX; 
    float d = mouseX-dVolumeX;
    amplitude = map(d,0,dVolumeW- (dVolumeW/10),0.0,1.0);
  }
}

//rollover
void rollOver(){
  if(mouseX > dTextX && mouseY > dTextY && mouseX < dTextX+dTextW && mouseY < dTextY+(dTextH-(dTextH/8))){aideText = "FENETRE INFORMATIONS:\n\nAffiche pour chaque klaxon généré\nson heure d' émission, son nom, et ses coordonnées\nl' affichage part du plus récent( en haut) au plus ancien (en bas).\nUn bouton permet d' exporter la totalité des informations \ndes klaxons générés depuis le début sur un fichier .txt";}
  else if(mouseX > dTextX && mouseY > dTextY+(dTextH-(dTextH/8)) && mouseX < dTextX+dTextW && mouseY < dTextY+dTextH){aideText = "BOUTON EXPORT:\n\nPermet d' exporter sur un fichier 'export.txt' la totalité\ndes informations des klaxons générés depuis le \nlancement de l' application."; exportOk = true;}
  else if(mouseX > dPositionX && mouseY > dPositionY && mouseX < dPositionX + dPositionW && mouseY < dPositionY + dPositionH){aideText = "FENETRE POSITION:\n\nAffiche la position des klaxons avec des cercles de couleur\nla couleur varie du rouge au bleu (à partir de 10 klaxons)\nindiquant le plus récent au plus ancien.";}
  else if(mouseX > dAmplitudeX && mouseX < dAmplitudeX + dAmplitudeW && mouseY > dAmplitudeY && mouseY < dAmplitudeY + dAmplitudeH){aideText = "FENETRE AMPLITUDE:\n\nAffiche l' amplitude sur une échelle de temps de chaque\nklaxon généré. \nA chaque retour à la ligne, la couleur change.\n\nUn CLICK sur la fenêtre permet de l' effacer.";}
  else if(mouseX > dFftX && mouseY > dFftY && mouseX < dFftX+dFftW && mouseY < dFftY+dFftH){aideText = "FENETRE FFT:\n\nAffiche les fréquences de chaque klaxon généré.";}
  else if(mouseX > dVumetreX && mouseY > dVumetreY && mouseX < dVumetreX+dVumetreW && mouseY < dVumetreY+dVumetreH){aideText = "FENETRE VU-METRE:\n\nAffiche l' amplitude des klaxons, sur une échelle allant\ndu vert au rouge.";}
  else if(mouseX > dCompteurX && mouseY > dCompteurY && mouseX < dCompteurX+dCompteurW && mouseY < dCompteurY+dCompteurH){aideText = "FENETRE COMPTEUR:\n\nPropose 2 boutons permettant d' afficher au choix:\n   -Le nombre total de klaxon générés.\n   -Le nombre de secondes écoulées depuis le lancement du \n   premier klaxon.";}
  else if(mouseX > dVolumeX && mouseY > dVolumeY && mouseX < dVolumeX+dVolumeW && mouseY < dVolumeY+dVolumeH){aideText = "FENETRE VOLUME:\n\nPermet de régler le volume de sortie audio à l' aide d' un slider.\nIl fonctionne avec un 'CLICK and DRAG'.";}
  else{aideText = aideTextIni; }
}
