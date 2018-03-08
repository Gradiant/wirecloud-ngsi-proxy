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

FROM python:2

MAINTAINER Lorenzo García Cortiñas <lgcortinas@gradiant.org>

# Install wirecloud & dependencies
RUN pip install "wirecloud<0.10.0"

#RUN echo \
#   'deb ftp://ftp.us.debian.org/debian/ jessie main\n \
#    deb ftp://ftp.us.debian.org/debian/ jessie-updates main\n \
#    deb http://security.debian.org jessie/updates main\n' \
#    > /etc/apt/sources.list

RUN apt-get clean
RUN apt-get -y update
RUN apt-get install -y apache2 libapache2-mod-wsgi

COPY ["apache-config.conf", "/etc/apache2/sites-enabled/000-default.conf"]

RUN adduser --system --group --shell /bin/bash wirecloud

WORKDIR /opt

RUN wirecloud-admin startproject wirecloud_instance --quick-start
RUN chown -R wirecloud:wirecloud wirecloud_instance

WORKDIR /opt/wirecloud_instance
RUN sed -i "s/SECRET_KEY = '[^']\+'/SECRET_KEY = 'TOCHANGE_SECRET_KEY'/g" wirecloud_instance/settings.py

# The volume must be created after running the wirecloud-admin command
VOLUME /opt/wirecloud_instance

WORKDIR /opt/wirecloud_instance

EXPOSE 80

# NGSI proxy:
RUN apt-get install -y nodejs nodejs-legacy npm && \
        mkdir /home/ngsi && \
        cd /home/ngsi && \
        git clone git://github.com/conwetlab/ngsijs.git && \
        cd ngsijs/ngsi-proxy && \
        npm install

COPY ./docker-entrypoint.sh /
COPY ./runAll.sh /
RUN chmod +x /docker-entrypoint.sh
RUN chmod +x /runAll.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["/runAll.sh"]
