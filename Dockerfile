FROM      ubuntu:14.04
MAINTAINER Ryan Fowler <ryan.fowler@singlewire.com>

RUN apt-get update
RUN apt-get install -y aptitude
RUN aptitude install --without-recommends -y golang openjdk-7-jdk emacs24-nox git-core curl supervisor ruby-full openssh-server inotify-tools

RUN mkdir /gocode
ENV GOPATH /gocode
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/gocode/bin

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
RUN apt-get update
RUN apt-get install -y lxc-docker

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
EXPOSE 22 9001
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD watch_puppet.conf /etc/supervisor/conf.d/watch_puppet.conf
ADD watch_puppet.sh /watch_puppet.sh
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

RUN gem install puppet --no-rdoc --no-ri
VOLUME ["/var/lib/puppet"]
RUN sed -i.bak -e 's/session    required     pam_loginuid.so/session    optional     pam_loginuid.so/' /etc/pam.d/sshd
RUN echo '%adm ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers