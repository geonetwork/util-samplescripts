#!/bin/sh

# ################# config #######################
url="http://localhost:8080/geonetwork"
username=admin
password=admin


################### functions ####################
login () {
  u=$1
  p=$2

  # try logging in once
  echo "username=$u&password=$p" | POST -sUe $url/srv/nl/user.login%21 | grep -q 'User login failed' && { echo login as $u failed ; exit 1 ; }

  # if we get here, the username/password is correct, so acquire actual session id
  session=$(echo "username=$u&password=$p" | POST -dsUe "$url/srv/en/user.login%21" | awk -F: '/Set-Cookie/ {print $2}')
}


get () {
  service=$1
  GET -H "Cookie: $session" "$url/srv/en/$service%21" | xpath -e '/root/response' 2>/dev/null
}

post () {
  service=$1
  file=$2
  cat $file | POST -c 'application/xml' -H "Cookie: $session" "$url/srv/en/$service%21" | xpath -e '/root/response' 2>/dev/null

}

######################### MAIN ############################

# check dependencies
which lwp-request > /dev/null || { echo 'ERROR: missing lwp-request, see readme.txt for dependencies' ; exit 4 ;  }
which xpath > /dev/null || { echo 'ERROR: missing lwp-request, see readme.txt for dependencies' ; exit 4 ;  }


# get commandline arguments
service=$1
postdata=$2     # filename with xml to POST

[ -n $service"" ] || {
  echo
  echo "usage:   `basename $0` servicename [filename]"
  echo
  echo "example: `basename $0` metadata.admin.index.rebuild"
  echo "         `basename $0` user.login credentials.xml"
  echo
  echo "see geonetwork/WEB-INF/lib/config.xml for service names"
  echo
  echo
  exit 2
}


# login
login $username $password

if [ $postdata"" ] ; then
  [ -r $postdata ] || { echo "could not read file $postdata" ; exit 3 ; }
  post $service $postdata
else
  get $service
fi

