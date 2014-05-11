function confirm {
  # call with a prompt string or use a default
  read -r -p "${1:-Are you sure?} [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
  esac
}

function answer {
  read -r -p "$1" response
  case $response in
    "")
      echo $2
      ;;
    *)
      echo $response
      ;;
  esac
}
