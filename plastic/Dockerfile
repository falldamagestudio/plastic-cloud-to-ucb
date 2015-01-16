FROM ubuntu:trusty

MAINTAINER Miguel González <mgonzalez@codicefactory.com>

RUN apt-get update
RUN apt-get install -y wget

RUN mkdir /logs
RUN mkdir /conf
RUN mkdir -p /db/sqlite

RUN echo "deb http://www.plasticscm.com/plasticrepo/5.0/Ubuntu_14.04/ ./" >> /etc/apt/sources.list.d/plastic.list
RUN echo "deb http://www.plasticscm.com/plasticrepo/5.4/Ubuntu_14.04/ ./" >> /etc/apt/sources.list.d/plastic.list
RUN wget http://www.plasticscm.com/plasticrepo/5.0/Ubuntu_14.04/Release.key -O - | apt-key add -
RUN wget http://www.plasticscm.com/plasticrepo/5.4/Ubuntu_14.04/Release.key -O - | apt-key add -

RUN DEBIAN_FRONTEND=noninteractive apt-get -q update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q plasticscm-client plasticscm-server 

RUN clconfigureserver --language=en --port=8087 --workingmode=UPWorkingMode
RUN umtool cu root root
RUN umtool cg administrators
RUN umtool autg root administrators

RUN mv /opt/plasticscm5/server/users.conf /conf
RUN mv /opt/plasticscm5/server/groups.conf /conf
RUN ln -s /conf/users.conf /opt/plasticscm5/server/users.conf
RUN ln -s /conf/groups.conf /opt/plasticscm5/server/groups.conf

ADD loader.log.conf /opt/plasticscm5/server/
ADD db.conf /opt/plasticscm5/server/

EXPOSE 8087

VOLUME ["/db/sqlite"]
VOLUME ["/conf"]
VOLUME ["/logs"]

CMD ["/opt/plasticscm5/server/plasticd", "--daemon"]
