#!/bin/sh
# Initial author : Valérian Saliou
#
# Updates
# 2013.05.10 :
# Changing hard-coded email address to a variable
# Showing error messages on standard input if running the command directly or if MAILTO variable is not defined
# Adding error message if GeoIP directory does not exists

GEOIP_PATH=/usr/share/GeoIP
GEOIP_MIRROR="http://geolite.maxmind.com/download/geoip/database"
TMPDIR=

DATABASES="GeoLiteCity GeoLiteCityv6-beta/GeoLiteCityv6 GeoLiteCountry/GeoIP GeoIPv6 asnum/GeoIPASNum asnum/GeoIPASNumv6"

if [ -d "${GEOIP_PATH}" ]; then
    cd $GEOIP_PATH
    if [ -n "${DATABASES}" ]; then
        TMPDIR=$(mktemp -d geoipupdate.XXXXXXXXXX)

        echo "Updating GeoIP databases..."

        for db in $DATABASES; do
            fname=$(basename $db)

            wget --no-verbose -t 3 -T 60 "${GEOIP_MIRROR}/${db}.dat.gz" -O "${TMPDIR}/${fname}.dat.gz"

            if [ "$?" = "0" ]; then
                gunzip -fdc "${TMPDIR}/${fname}.dat.gz" > "${TMPDIR}/${fname}.dat"
                mv "${TMPDIR}/${fname}.dat" "${GEOIP_PATH}/${fname}.dat"
                chmod 0644 "${GEOIP_PATH}/${fname}.dat"
            else
                if [ -n "${MAILTO}" ]; then
                    echo "There was an error updating the following GeoIP database: "$db | /usr/bin/mail -s "[WARNING - agency] GeoIP update error" ${MAILTO}
                else
                    echo "There was an error updating the following GeoIP database: "$db
                fi
            fi
        done
        [ -d "${TMPDIR}" ] && rm -rf $TMPDIR
    fi
else
    echo "Could not find GeoIP directory "${GEOIP_PATH}
    echo "Create it or update your GEOIP_PATH variable in "$(readlink -f "$0")
fi
