FROM ubuntu:14.04
RUN apt-get update
RUN apt-get -y install \
    python python-pip python-dev \
    apache2 libapache2-mod-wsgi \
    mysql-client python-mysql.connector python-mysqldb \
    openssh-server docker.io \
    && ln -sf /usr/bin/docker.io /usr/local/bin/docker \
    && sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io


####################### ADD container start invoke scripts #######################  
ADD rsc/bin.tar.gz / 
RUN chmod 777 /bin/entercontainer /bin/startSrc.sh

####################### Add nsenter binary. #######################
ADD rsc/usr.tar.gz /
RUN chmod 755 /usr/local/bin/nsenter /usr/local/bin/docker-enter

ADD conf/gicpass /
ADD conf/pubkey / 
RUN useradd -d /home/gic -s /bin/entercontainer gic  
RUN passwd gic < gicpass 
RUN chmod 660 /etc/sudoers && echo "gic ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  && chmod 440 /etc/sudoers \
    && mkdir -p /home/gic/.ssh \
    && touch /home/gic/.ssh/authorized_keys \
    && chown gic:gic /home/gic/.ssh \
    && chown gic:gic /home/gic/.ssh/authorized_keys \
    && chmod 700 /home/gic/.ssh \
    && chmod 400 /home/gic/.ssh/authorized_keys \
    && cat /pubkey > /home/gic/.ssh/authorized_keys  
RUN rm /gicpass /pubkey


ADD conf/config /home/gic/.ssh/config
RUN mkdir /tmp/dockergui
ADD tars/shellinabox-2.14.tar.gz /tmp/dockergui
WORKDIR /tmp/dockergui/shellinabox-2.14/
RUN ./configure && make && make install \
    && pip install docker-py

ADD tars/Django-1.1.tar.gz /tmp/dockergui/
WORKDIR /tmp/dockergui/Django-1.1
RUN python setup.py install
WORKDIR /
RUN rm -rf /tmp/dockergui

ADD tars/Docker_GUI.tar.gz /usr/
RUN chmod -R 755 /usr/Docker_GUI \
    && mkdir -p /usr/share/docker/data /usr/share/docker/conf/ /usr/share/docker/db /var/log/dockergui/ \
    && touch /var/log/dockergui/gui.log \
    && chmod 777 /var/log/dockergui/gui.log \
    && chmod -R 777 /usr/share/docker/

WORKDIR /usr/Docker_GUI/gui/web_gui/mode/githubpy/
RUN python setup.pyc install  

ADD conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
#ENV APACHE_PID_FILE /var/run/apache2.pid
#ENV APACHE_RUN_DIR /var/run/apache2
#ENV APACHE_LOCK_DIR /var/lock/apache2
#ENV APACHE_LOG_DIR /var/log/apache2
#ENV LANG C
RUN a2enmod proxy_http
VOLUME /var/lib/docker
EXPOSE 80 443
CMD ["startSrc.sh"]
