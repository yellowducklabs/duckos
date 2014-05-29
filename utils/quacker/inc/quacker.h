#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/socket.h>
#include <sys/types.h>

#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#ifndef QUCKER_H
#define QUCKER_H

typedef struct sockaddr_in sin;

/* Quaker function signatire declarations */
int make_socket(uint16_t);

# endif