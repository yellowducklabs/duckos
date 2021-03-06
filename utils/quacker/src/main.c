#include <stdio.h>
#include <stdlib.h>

#include "quacker.h"

/**
 * Tiny structure to store cli arguments
 */
typedef struct cli_arguments {
  int port_number;
} cli_arguments_t;

/* Utility functions signature declarations */
cli_arguments_t parse_arguments(int, char**);

int main(int argc, char *argv[]) {
  /* Get the arguments & parse to settings */
  cli_arguments_t settings;
  settings = parse_arguments(argc, argv);

  /* Socket & Connection file descriptors */
  int listenfd;
  int connfd;

  /* Socket initialization */
  listenfd = make_socket(settings.port_number);
  if (listen(listenfd, 10) < 0) {
    perror("listen");
    exit(EXIT_FAILURE);
  }

  while(1) {
    /* Accept connections and close them immediatelly */
    connfd = accept(listenfd, (struct sockaddr*) NULL, NULL);
    close(connfd);
    sleep(1);
  }

  return EXIT_SUCCESS;
}

/**
 * Parses CLI arguments into a structure
 * @param  int argc         - Number of arguments supplied
 * @param  char** argv      - Array of argument strings
 * @return cli_arguments_t  - CLI Arguments
 */
cli_arguments_t parse_arguments(int argc, char *argv[]) {
  cli_arguments_t arguments;
  if (argc == 2) {
    // Convert the first argument (port number)
    //  to an integer
    arguments.port_number = atoi(argv[1]);
  } else {
    printf("%s\n", "\nUsage: quacker <port>");
    exit(EXIT_FAILURE);
  }
  return arguments;
}