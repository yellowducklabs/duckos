package main

import  (
  "fmt"
  "net"
  "strings"
  "io/ioutil"
  "crypto/md5"
  "encoding/json"
  "encoding/hex"
)

type DuckStats struct {
  Secure  bool
  Version string
}

func main() {
  // Open up a socket and listen on tcp/10002
  ln, err := net.Listen("tcp", ":10002")
  if err != nil { /* Handle error */ }

  // Listen for connections
  for {
    conn, err := ln.Accept()
    if err != nil { /* Handle error continue */ }
    go handleRequest(conn)
  }

}

func prepareResponse() []byte {
  stats := DuckStats{isKeySecure(), getOsVersion()}
  // Marshal the response
  bMessage, _ := json.Marshal(stats)
  // Response for the request
  fmt.Println(string(bMessage))
  return bMessage
}

func handleRequest(conn net.Conn) {
  response := "insecure"
  if isKeySecure() {
    response = "secure"
  }
  conn.Write([]byte(response))
  conn.Close()
}

// Duck stats routines
func isKeySecure() bool {
  const authKeysFilePath = "quacker.go"
  // Read the file!
  b, err := ioutil.ReadFile(authKeysFilePath)
  if err != nil { return true }
  hash := md5Hash(b)
  // This is the default (insecure) authorized_keys md5 hash
  const defaultHash = "c389d9e99de6b7530cf26d7fb2b4af7f"
  if hash == defaultHash {
    return false
  } else {
    return true
  }
}

func getOsVersion() string {
  const filePath = "version"
  b, err := ioutil.ReadFile(filePath)
  if err != nil { return "Unknown" }
  return strings.TrimSpace(string(b))
}


// Utility functions
func md5Hash(text []byte) string {
  hasher := md5.New()
  hasher.Write(text)
  return hex.EncodeToString(hasher.Sum(nil))
}
