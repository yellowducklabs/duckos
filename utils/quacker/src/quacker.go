package main

import  (
  "fmt"
  "net/http"
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
  http.HandleFunc("/", responseHandler)
  http.ListenAndServe(":10002", nil)
}

func responseHandler(w http.ResponseWriter, r *http.Request) {
  response := "insecure"
  if isKeySecure() {
    response = "secure"
  }
  fmt.Fprintf(w, "%s", response)
}

func prepareResponse() []byte {
  stats := DuckStats{isKeySecure(), getOsVersion()}
  // Marshal the response
  bMessage, _ := json.Marshal(stats)
  // Response for the request
  fmt.Println(string(bMessage))
  return bMessage
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
