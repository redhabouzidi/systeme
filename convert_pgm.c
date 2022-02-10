#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include "funct.h"

int main(int argv,char * argc[]){
    if (argv!=3){
    printf("\nErreur\n");
    exit(1);
    }
    unsigned char temp[255];
    lire(254,temp,argc[1]);
    char code[255]="";
    int i=0,k=0;
    while(temp[i]!='\n'){
    code[k]=temp[i];
    k++;
    i++;
    }

    i++;
    if(strcmp(code,"P5")){
    return 2;
    }
    i=lire_n(code,temp,i);
    if(strcmp(code,"400")>0){
    printf("ERREUR DIMX");
    }
    while(){

    }
    if(i==-1){
    exit(1);
    }
    i=lire_n(code,temp,i);
    if(strcmp(code,"400")>0){
    printf("ERREUR DIMY");
    }
    if(i==-1){
    exit(1);
    }
    i=lire_n(code,temp,i);
    if(strcmp(code,"400")>0){
    printf("ERREUR TAILLE CHAR");
    }
    if(i==-1){
    exit(1);
    }
    //partie écriture
    i=0;
    k=0;
    int nb=0;
    while(nb<4){
    if(temp[i]=='\n'||temp[i]==' '||temp[i]=='\t'){
    i++;
    if(nb!=1){
    code[k]='\n';
    }else{
    code[k]=' ';
    }
    k++;
    nb++;
    while(temp[i]=='\n'||temp[i]==' '||temp[i]=='\t'){
    i++;
    }
    }else{
    code[k]=temp[i];
    i++;
    k++;
    }

    }
    code[k]='\0';
    printf("%s",code);
    printf("%s",argc[2]);
    ecrir(strlen(code),code,argc[2],SEEK_SET);
    img(argc[1],argc[2])


return 0;
}
