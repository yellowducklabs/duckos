#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>

typedef struct sockaddr_in sin;

/**
 * Tiny structure to store cli arguments
 */
typedef struct cli_arguments {
  int port_number;
} cli_arguments_t;

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

/**
 * Creates a AF_INET socket (SOCK_STREAM type) and
 * binds it to a port specified.
 *
 * @param   int port    - Port to bind a socket to
 * @return  int socket  - Socket file descriptor
 */
int make_socket(uint16_t port) {
  int sock;
  struct sockaddr_in name;

  /* Create the socket. */
  sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0) {
    perror("socket");
    exit(EXIT_FAILURE);
  }

  /* Give the socket a name */
  name.sin_family      = AF_INET;
  name.sin_port        = htons(port);
  name.sin_addr.s_addr = htonl(INADDR_ANY);

  /* Bind the socket */
  if (bind(sock, (struct sockaddr*)&name, sizeof (name)) < 0) {
    perror("bind");
    exit(EXIT_FAILURE);
  }

  return sock;
}


/**
 * Main function
 */
int main(int argc, char *argv[])
{
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