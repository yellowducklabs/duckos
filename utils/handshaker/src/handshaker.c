#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <time.h>

typedef struct sockaddr_in sin;

/**
 * Tiny structure to store cli arguments
 */
typedef struct cli_arguments {
  int port_number;
} cli_arguments_t;

/**
 * Parses CLI arguments into a structure
 * @param  argc Number of arguments supplied
 * @param  argv Array of argument strings
 * @return      cli_arguments_t
 */
cli_arguments_t parse_arguments(int argc, char *argv[]) {
  cli_arguments_t arguments;
  if (argc == 2) {
    // Convert the first argument (port number)
    //  to an integer
    arguments.port_number = atoi(argv[1]);
  } else {
    printf("%s\n", "\nUsage: handshaker <port>");
    exit(EXIT_FAILURE);
  }
  return arguments;
}

/**
 * Creates a socket and binds it to a port
 * @param int port - Port to bind a socket to
 */
void create_socket(int port) {
  int listenfd = 0;
  int connfd = 0;
  sin serv_addr;
  char sendBuff[1025];
  time_t ticks;

  printf("Creating a socket...\n");
  listenfd = socket(AF_INET, SOCK_STREAM, 0);
  memset(&serv_addr, '0', sizeof(serv_addr));
  memset(sendBuff, '0', sizeof(sendBuff));

  // Define a socket
  serv_addr.sin_family      = AF_INET;
  serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
  serv_addr.sin_port        = htons(port);

  printf("Binding...\n");
  // Bind the socket
  bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr));

  // Listen
  listen(listenfd, 10);
  printf("Listening on port %d\n", port);

  while(1) {
    // Accept connections and print the data sent
    connfd = accept(listenfd, (struct sockaddr*)NULL, NULL);
    ticks = time(NULL);
    snprintf(sendBuff, sizeof(sendBuff), "%.24s\r\n", ctime(&ticks));
    write(connfd, sendBuff, strlen(sendBuff));
    close(connfd);
    sleep(1);
   }
}

/**
 * Main function
 */
int main(int argc, char *argv[])
{
  // Get the arguments & parse
  cli_arguments_t arguments;
  arguments = parse_arguments(argc, argv);

  // Simple socket creation
  create_socket(arguments.port_number);

  return EXIT_SUCCESS;
}