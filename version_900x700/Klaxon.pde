
//***classe Klaxon***
class Klaxon{
  
//**attributs**
private SoundFile file;
private int positionX,positionY;
private String klaxonName;
private int h,m,s;

//**constructeur**
public Klaxon(SoundFile file,
                int positionX,
                int positionY,
                String klaxonName,
                int h,
                int m,
                int s){
this.file = file;
this.positionX = positionX;
this.positionY = positionY;
this.klaxonName = klaxonName;
this.h = h; this.m = m; this.s = s;
}

//**méthodes de class**

//*getter*
public SoundFile getFile(){return this.file;}
public int getPositionX(){return this.positionX;}
public int getPositionY(){return this.positionY;}
public String getKlaxonName(){return this.klaxonName;}
public int getH(){return this.h;}
public int getM(){return this.m;}
public int getS(){return this.s;}




}
