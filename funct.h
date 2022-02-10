#ifndef FUNCT_H
#define FUNCT_H
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>


    void lire(int n,unsigned char * buff,char * file);
    int lire_n(char * code,char * temp, int i);
    void ecrir(int n,char * buff,char * file,int seek);
    void img(char * files,char * filed);
#endif
