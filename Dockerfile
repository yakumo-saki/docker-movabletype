FROM debian:buster

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y --no-install-recommends \ 
           apache2 \
           libapache2-mod-fcgid \
           ca-certificates \
           curl \
           gnupg2 \
           lsb-release \
    && apt-get clean \ 
    && mv /etc/apache2/mods-available/cgi*.* /etc/apache2/mods-enabled/ \
    && mv /etc/apache2/mods-available/fcgid.* /etc/apache2/mods-enabled/

# Perl modules
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
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
           build-essential \
    && apt-get clean \ 
    && echo yes | cpan install Mozilla:CA Digest::SHA1 
 
#       needs apache source  
#    && cpan install XMLRPC::Transport::HTTP::Plack 

COPY --chown=www-data:www-data ./mt/ /var/www/html/
RUN chmod 755 /var/www/html/*.cgi
COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]  
