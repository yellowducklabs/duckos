#!/usr/bin/python
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

class httpHello(BaseHTTPRequestHandler):
  def do_GET(self):
    self.send_response(200)
    self.send_header('Content-type','text/plain')
    self.end_headers()
    self.wfile.write("Quack quack from Python!")
    return

server = HTTPServer(('', 80), httpHello)
server.serve_forever()
