import java.util.*;

//*****************************************************
//***classe générant des objets Klaxon aléatoirement***
//*****************************************************

class KlaxonGenerator{
  
//**attributs**
private int nbKlaxons = 0;//comptabilise le nombre de klaxons
private String[] link = {"0226.mp3","0228.mp3","0256.mp3","0258.mp3","0261.mp3","0262.mp3","0679.mp3","0969.mp3"};//,"1086.mp3"};//
private SoundFile[] files = new SoundFile[link.length];
private PApplet orig;
private int h,m,s,millis;
private int posX = (int)dPositionW-80; 
private int posY = (int)dPositionH-80; 
private Stack<Klaxon> saveKlaxon;
private boolean ok = true;
private Klaxon klaxon1;

//**constructeur**
public KlaxonGenerator(PApplet orig){
  this.orig = orig;
  this.init();
  this.h = hour(); this.m = minute(); this.s = second();
  this.saveKlaxon = new Stack<Klaxon>();
  this.millis = millis();

  }

//**méthodes de class**

//initialise le tableau de sons
public void init(){
  for(int i =0; i< link.length; i++){
    files[i] = new SoundFile(orig,link[i]);
  }
  }
  
//retourne un objet Klaxon
public Klaxon generer(){  
  ok = false;
  //delay((int)random(10000));
  int index = (int)random(files.length);
  nbKlaxons ++;//incrémente la variable
  
  klaxon1 = new Klaxon(files[index],
                  (int)random(posX),
                  (int)random(posY),
                  link[index],
                  hour(),
                  minute(),
                  second());
                  
  this.saveKlaxon.push(klaxon1);
  ok = true;
  
return klaxon1;  
}

//retourne le nombre de seconds depuis le debut
public int compteSeconds(){
  return (millis()-millis)/1000;
}

//retourne un tableau de string contenant les informations texte
public String[] infoTab(){
  String[] tab = new String[saveKlaxon.size()];
  int i = saveKlaxon.size()-1;
  for(Klaxon kla: saveKlaxon){
    String h,m,s;
    if(kla.getH()<10){h="0"+kla.getH();}else{h=""+kla.getH();}
    if(kla.getM()<10){m="0"+kla.getM();}else{m=""+kla.getM();}
    if(kla.getS()<10){s="0"+kla.getS();}else{s=""+kla.getS();}
    tab[i]=h+":"+m+":"+s+"  -  "+kla.getKlaxonName()+"  -  Width: "+kla.getPositionX()+" - Height: "+kla.getPositionY();
    i--;
  }  
return tab;
}

//*getters*
public int getNbKlaxons(){return this.nbKlaxons;}
public int getH(){return this.h;}
public int getM(){return this.m;}
public int getS(){return this.s;}
public Stack<Klaxon> getSaveKlaxon(){return this.saveKlaxon;}
public boolean getOk(){return ok;}

}
