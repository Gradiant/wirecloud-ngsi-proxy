#!/bin/bash
#
# Copyright (C) 2017  Gradiant <https://www.gradiant.org/>
#
# This file is part of WIRECLOUD-NGSI_PROXY 
#
# WIRECLOUD-NGSI_PROXY is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# WIRECLOUD-NGSI_PROXY is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

sed -i "s/SECRET_KEY = 'TOCHANGE_SECRET_KEY'/SECRET_KEY = '$(python -c "from django.utils.crypto import get_random_string; import re; print(re.escape(get_random_string(50, 'abcdefghijklmnopqrstuvwxyz0123456789%^&*(-_=+)')))")'/g" /opt/wirecloud_instance/wirecloud_instance/settings.py

# Check if there are any pending migration
python manage.py migrate --fake-initial

# Collect static files so we take into account custom themes and configurations
python manage.py collectstatic --noinput

# NGSI proxy
cd /home/ngsi/ngsijs/ngsi-proxy; npm run start &

# Apache (wirecloud)
/usr/sbin/apache2ctl graceful-stop
exec /usr/sbin/apache2ctl -D FOREGROUND
