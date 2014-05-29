/**
 * Quacker function implementations
 */
#include "quacker.h"

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