
    #include "funct.h"
    #include "string.h"
void lire(int n,unsigned char * buff,char * file){
    int f;
    f= open(file,O_RDONLY);
    if(f==-1){
    exit(1);
    }
    if(read(f,buff,n)==0){
        perror("ERREUR");
        exit(1);
    }
    buff[n]='\0';
    return;

}
int lire_n(char * code,char * temp,int i){
    int k=0;
    while(temp[i]<58&&temp[i]>=48){
    code[k]=temp[i];
    k++;
    i++;
    }
    i++;
    code[k]=='\0';
    return code[0]=='\0'? -1:i;
}
void ecrir(int n,char * buff,char * file,int seek){
    int fd=open(file,O_RDWR|O_CREAT,0666);
    lseek(fd,0,seek);
    printf("%d",fd);
    if(fd==NULL){
        exit(1);
    }
    if(write(fd,buff,n)==-1){
    exit(1);
    }
    printf("bonjour");
}
void img(char * files,char * filed){
    int nb=0;
    int fs=open(files,O_RDONLY);
    int fd=open(filed,O_RDWR);
    if(fd==NULL||fs==NULL){
    exit(1);
    }
    while(nb!=4&&read(fs,c,1)!=-1){
    if(c=='\n'||c==' '||c=='\t'){
        nb++;
    }
    }






}
