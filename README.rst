LiteGeoIP update
=================

Update script for GeoIP `GeoLite <http://dev.maxmind.com/geoip/legacy/geolite>`_ database.

Installation
------------

To install LiteGeoIP update, a single command necessary :

::

    wget https://raw.github.com/Mibou/litegeoipupdate/master/litegeoipupdate.sh -O /usr/local/bin/litegeoipupdate

You can then edit the ``GEOIPDIR`` variables to fit your needs in ``/usr/local/bin/litegeoipupdate``.

Execution
---------

To run the update manualy, you can launch the command ``/usr/local/bin/litegeoipupdate`` or directly  ``litegeoipupdate`` if ``/usr/local/bin`` is in your ``PATH`` environment variable.

Automatization
--------------

To fully automate this process on Linux or Unix, use a crontab file like :

::

    # Top of crontab
    MAILTO=your@email.com

    0 4 * * 3 /usr/local/bin/litegeoipupdate
    # End of crontab

This Cron will run the update every wednesday at 4:00 am and send an email to `MAILTO` if there is any problem.

