FROM ubuntu:latest

ADD conf/gicpass /
ADD conf/key.pub /
ADD resource/usr.tar.gz / 
ADD tars/shellinabox-2.14.tar.gz /tmp/usercontainer/
RUN apt-get update && apt-get install -y openssh-server apache2 docker.io python python-pip \
    && ln -sf /usr/bin/docker.io /usr/local/bin/docker \ 
    && sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io \
    && pip install docker-py \
    && useradd -d /home/gic -s /bin/entercontainer gic \
    && passwd gic < gicpass \
    && mkdir /home/gic/.ssh /usr/share/docker/data -p \
    && cat /key.pub > /home/gic/.ssh/authorized_keys 

RUN chmod 700 /home/gic/.ssh/ \ 
    && chmod 400 /home/gic/.ssh/authorized_keys \
    && chown -R gic:gic /home/gic/ \
    && chmod 777 /usr/share/docker/data \ 
    && chmod 755 /usr/local/bin/nsenter /usr/local/bin/docker-enter \
    && a2enmod proxy_http

 
WORKDIR /tmp/usercontainer/shellinabox-2.14/
RUN ./configure \
    && make \
    && make install

ADD conf/config /home/gic/.ssh/config
ADD resource/bin.tar.gz /
ADD conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN chmod 777 /bin/initUserCtnEnv /bin/entercontainer 
VOLUME /var/lib/docker
EXPOSE 22 80 443 2375  

ADD conf/docker.io /etc/default/docker.io
RUN echo 'gic	 ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
# Clean temp files start
WORKDIR /
RUN rm -rf /tmp/usercontainer/* gicpass key.pub

CMD ["initUserCtnEnv"]
