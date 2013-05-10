#!/bin/sh
# Author : Valérian Saliou
#
# Updates
# 2013.05.10 09:52 : Changing hard-coded email address to a variable

EMAIL=""
GEOIPDIR=/usr/share/GeoIP
GEOIP_MIRROR="http://geolite.maxmind.com/download/geoip/database"
TMPDIR=

DATABASES="GeoLiteCity GeoLiteCityv6-beta/GeoLiteCityv6 GeoLiteCountry/GeoIP GeoIPv6 asnum/GeoIPASNum asnum/GeoIPASNumv6"

if [ -d "${GEOIPDIR}" ]; then
    cd $GEOIPDIR
    if [ -n "${DATABASES}" ]; then
        TMPDIR=$(mktemp -d geoipupdate.XXXXXXXXXX)

        echo "Updating GeoIP databases..."

        for db in $DATABASES; do
            fname=$(basename $db)

            wget --no-verbose -t 3 -T 60 "${GEOIP_MIRROR}/${db}.dat.gz" -O "${TMPDIR}/${fname}.dat.gz"

            if [ "$?" = "0" ]; then
                gunzip -fdc "${TMPDIR}/${fname}.dat.gz" > "${TMPDIR}/${fname}.dat"
                mv "${TMPDIR}/${fname}.dat" "${GEOIPDIR}/${fname}.dat"
                chmod 0644 "${GEOIPDIR}/${fname}.dat"
            else
                echo "There was an error updating the following GeoIP database: "$db | /usr/bin/mail -s "[WARNING - agency] GeoIP update error" ${EMAIL}
            fi
        done
        [ -d "${TMPDIR}" ] && rm -rf $TMPDIR
    fi
fi
