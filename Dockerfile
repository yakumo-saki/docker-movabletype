FROM debian:buster

# CPAN prerequirement
#RUN apt-get update && apt-get install -y libgd-dev libmagickcore-dev libimage-magick-q16hdri-perl 

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y --no-install-recommends \ 
           apache2 \
           ca-certificates \
           curl \
           gnupg2 \
           lsb-release \
    &&  mv /etc/apache2/mods-available/cgi*.* /etc/apache2/mods-enabled/ 

# Perl modules
RUN apt-get install -y --no-install-recommends \
           perlmagick \
           libcgi-application-basic-plugin-bundle-perl \
           libimager-perl \
           libgd-perl \
           libxml-sax-expat-perl libxml-sax-expatxs-perl \
           libio-digest-perl libdigest-sha-perl libdigest-sha3-perl \
           libarchive-zip-perl \
           libplack-perl \
           libcrypt-dsa-perl \
           libauthen-sasl-cyrus-perl \
           libcgi-psgi-perl \
           libdbd-mysql-perl libdbd-sqlite2-perl libdbd-sqlite3-perl libdbd-pg-perl \
           libxml-parser-perl \
           libyaml-syck-perl \
           libcache-perl \
           libipc-run-perl \
           libcache-cache-perl libmemcached-libmemcached-perl libfile-cache-perl libcache-memcached-perl \
           libcgi-emulate-psgi-perl \
           libxml-libxml-perl \
    && apt-get install -y --no-install-recommends build-essential \
    && echo yes | cpan install Mozilla:CA Digest::SHA1 
 
#       needs apache source  
#    && cpan install XMLRPC::Transport::HTTP::Plack 

COPY ./mt/ /var/www/html/
COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]  
