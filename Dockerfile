FROM      ubuntu:13.10
MAINTAINER Ryan Fowler <ryan.fowler@singlewire.com>

RUN apt-get update
RUN apt-get install -y aptitude
RUN aptitude install --without-recommends -y golang openjdk-7-jdk emacs24-nox git-core

RUN mkdir /gocode
ENV GOPATH /gocode
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/gocode/bin

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
RUN apt-get update
RUN apt-get install -y lxc-docker
