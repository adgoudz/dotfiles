
# Usage: set-proxy [-n] [-x] [-q] [-u USER] [-p PASSWORD]
#        unset-proxy [-q]
#        show-proxy
#        proxy-opts PROGRAM_NAME
#
#   Options:
#
#     -n, --non-interactive
#     -x, --no-file
#     -q, --quiet
#
#   These functions can be sourced into the current shell environment to simplify
#   managing proxy settings.
#
#   The proxy address is determined from $DEFAULT_PROXY_ADDRESS, if it exists (it must
#   contain a domain name and an optional port only). A common proxy address is used if
#   this variable isn't set.
#
#   Proxy credentials can be provided a few different ways:
#
#     1. As options
#     2. Stored in $DEFAULT_PROXY_CREDENTIALS_FILE (with the format user:password)
#     3. Interactively, via prompts
#
#   These methods will be tried in the order above for both the user and the password.
#   This means that the user can be provided via one method (e.g. ~/.webrpoxy) while the
#   password can be provided via another method (e.g. interactively).
#
#   ~/.webproxy will be used if $DEFAULT_PROXY_CREDENTIALS_FILE isn't set. Proxy
#   credentials are always saved to this file so that command-line options and
#   interactive prompts aren't needed for subsequent calls to set-proxy. All file
#   interaction can be disabled using -x.
#
#   Interactive prompts are disabled in non-interactive shells by default, however they
#   can be disabled in interactive shells using -n.
#
#   The set-proxy function will fail with an error message (or silently, if -q was
#   specifed) if the credentials couldn't be determined using any of the enabled methods.
#

set-proxy() {
  local usage="Usage: set-proxy [-n] [-q] [-x] [-u USER] [-p PASSWORD]"

  local proxy_address=${DEFAULT_PROXY_ADDRESS:-default}

  local user_Name
  local user_password
  local non_interactive
  local no_file
  local quiet

  while (( $# > 0 )); do
    case $1 in
      -u|--user)
        user_name=$2
        shift 2
        ;;
      -p|--password)
        user_password=$2
        shift 2
        ;;
      -n|--non-interactive)
        non_interactive=true
        shift
        ;;
      -x|--no-file)
        no_file=true
        shift
        ;;
      -q|--quiet)
        quiet=true
        shift
        ;;
      -*)
        echo $usage
        return 1
        ;;
    esac
  done

  # Copy stdout so that _get_credentials can write prompts
  # exec 3>&1

  local credentials=$(
    _get_credentials "$user_name" "$user_password" "$non_interactive" "$no_file"
  )

  # Close the copied descriptor
  # esec 3>&-

  if [[ -z "$credentials" ]]; then
    if [[ -z "$quiet" ]]; then
      echo "Unable to determine proxy credentials. Try running without -n." >&2
    fi
    return $?
  fi

  export ALL_PROXY="http://${credentials}@${proxy_address}"
  export all_proxy=$ALL_PROXY
  export HTTP_PROXY=$ALL_PROXY
  export http_proxy=$ALL_PROXY
  export HTTPS_PROXY=$ALL_PROXY
  export https_proxy=$ALL_PROXY

  export NO_PROXY="localhost,127.0.0.1,::1"
  export no_proxy=$NO_PROXY

  if [[ -z "$quiet" ]]; then
    echo "Using $proxy_address"
  fi
}

unset-proxy() {
  local usage="Usage: unset-proxy [-q]"

  local quiet

  while (( $# > 0 )); do
    case $1 in
      -q|--quiet)
        quiet=true
        shift
        ;;
      -*)
        echo $usage
        return 1
        ;;
    esac
  done

  unset ALL_PROXY
  unset all_proxy
  unset HTTP_PROXY
  unset http_proxy
  unset HTTPS_PROXY
  unset https_proxy

  unset NO_PROXY
  unset no_proxy

  if [[ -z "$quiet" ]]; then
    echo "Proxying disabled"
  fi
}

show-proxy() {
  env | grep -i proxy | sort
}

proxy-opts() {
  local usage="Usage: proxy-opts PROGRAM"

  local -A program_opts

  # Provide a function for each program that accepts proxy options
  program_opts[java]=_java_proxy_opts

  if [[ -n $ZSH_NAME ]]; then
    local -a program_names=( ${(k)program_opts[*]} )
  else
    local -a program_names=( $(!program_opts[*]} )
  fi

  if [[ $# != 1 ]]; then
    printf "You must specify a program name (%s)\n" \
      $(IFS=\| ; echo "${program_names[*]}")
    echo $usage
    return 1
  fi

  if [[ "${program_opts[*]}" != *$1* ]]; then
    printf "%s isn't a supported program name (%s)\n" \
      $(IFS=\| ; echo "${program_names[*]}")
    echo $usage
    return 1
  fi
}

_get_credentials() {
  local credentials_file="${DEFAULT_PROXY_CREDENTIALS_FILE:-$HOME/.webproxy}"

  local non_interactive=$3
  local no_file=$4

  # Read the previously saved credentials if we can
  if [[ -f "$credentials_file" && -z "$no_file" ]]; then
    IFS=":" read -r user_name user_password < $credentials_file
  fi

  # Allow for overriding things via function arguments
  local user_name=${1:-$user_name}
  local user_password=${2:-$user_password}

  # Prompt for any credentials which are still missing, but only
  # if we're in an interactive shell, and only if prompting isn't
  # disabled
  if [[ $- == *i* && -z "$non_interactive" ]]; then
    local line_ending

    if [[ -z "$user_name" ]]; then
      if [[ -n $ZSH_NAME ]]; then
        read -r "user_name?> Proxy User: "
      else
        read -r -p "> Proxy User: " user_name
      fi
    fi
    if [[ -z "$user_password" ]]; then
      line_ending=$'\n'
      if [[ -n $ZSH_NAME ]]; then
        read -r -s "user_password?> Proxy Password: "
      else
        read -r -s -p "> Proxy Password: " user_name
      fi
    fi

    if [[ -t 3 ]]; then
      # Unfortunately we need to use a custom file descriptor
      # if we want to format stdout from within a subshell.
      # Assume that this descriptor has to connect to a terminal
      # if we were just able to prompt for user input.
      echo -n "$line_ending" >&3
    fi
  fi

  # If we're still missing a value, we need to give up silently
  if [[ -z $user_name || -z $user_password ]]; then
    return 1
  fi

  local credentials="${user_name}:${user_password}"

  # Save these for later and keep them private, but only if saving
  # is enabled, and only if we're interactive. We don't want non-
  # interactive processes to potentially block on the file system
  # (e.g., in the case that this function is called froma  shell
  # initialization script and several shells are created
  # simultaneously).
  if [[ $- == *i* && -z "$no_file" && -z "$non_interactive" ]]; then
    echo "$credentials" > "$credentials_file"
    chmod 600 "$credentials_file"
  fi

  echo -n "$credentials"
}

_current_proxy() {
  local proxy_regex="^https?://(.+@)?(.*)$"

  local primary_name=${1%_proxy}_proxy

  if [[ -n $ZSH_NAME ]]; then
    setopt localoptions ksharrays bashrematch
    local alternate_name=$(tr '[A-Za-z]' '[a-zA-Z]' <<< $primary_name)
    local current_proxy=${(P)primary_name:-${(P)alternate_name}}
  else
    local alternate_name=${primary_name~~}
    local current_proxy=${!primary_name:-${!alternate_name}}
  fi

  local proxy_segment=$2

  if [[ $current_proxy =~ $proxy_regex ]]; then
    if [[ -z $proxy_segment ]]; then
      echo $current_proxy
    elif [[ $proxy_segment == host ]]; then
      echo ${BASH_REMATCH[2]%:*}
    elif [[ $proxy_segment == port ]]; then
      echo ${BASH_REMATCH[2]##*:}
    fi
  else
    echo "Unable to determine $1. Try calling set-proxy"
  fi
}

_current_noproxy() {
  local delimiter=${1:- }

  if [[ -n $ZSH_NAME ]]; then
    IFS=, read -rA current_noproxy_hosts <<< ${NO_PROXY:-$no_proxy}
  else
    IFS=, read -ra current_noproxy_hosts <<< ${NO_PROXY:-$no_proxy}
  fi

  local IFS="$delimiter"
  echo "${current_noproxy_hosts[*]}"
}

_java_proxy_opts() {
  local -a nonproxy_hosts=( $(_current_noproxy) )

  # Add wildcards
  nonproxy_hosts=( "${nonproxy_hosts[@]/#./*.}" )

  local opts=(
    -Dhttp.proxyHost=$(_current_proxy http_proxy host)
    -Dhttp.proxyPort=$(_current_proxy http_proxy port)
    -Dhttps.proxyHost=$(_current_proxy httpsj_proxy host)
    -Dhttps.proxyPort=$(_current_proxy httpsj_proxy port)
    -Dhttp.nonProxyHosts=$(IFS=\| ; echo "${nonproxy_hosts[*]}"))
  )

  echo ${opts[*]}
}

