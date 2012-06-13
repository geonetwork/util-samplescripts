
geonetwork.sh - a rudimentary command-line client for geonetwork

USAGE

  $ geonetwork.sh servicename [filename]


EXAMPLES

  $ geonetwork.sh metadata.admin.index.rebuild
  $ geonetwork.sh user.login credentials.xml

  When the filename is omitted, a GET request is executed; When the
  filename is given, its contents will be POSTed to the service
  name. The contents of the file are expected to be application/xml.

  The service names are defined in geonetwork/WEB-INF/lib/config.xml
  (and in the include files named there).

  The output of the request is the xml returned by
  the service, filtered to show only the <response> part.


CONFIGURATION

  The first few lines of the script should be edited to provide the
  correct url for the geonetwork server, and the username and
  password to use for the non-public services.


DEPENDENCIES

  The script uses the GET and POST commands provided by the
  libwww-perl package (also known as LWP or perl-libwww-perl).

  Also it uses the xpath command provided by the perl-xml-xpath package.

  Both are available for most linux distributions.


AUTHOR

  Pieter Verbaarschott <pieter@geocat.net>



