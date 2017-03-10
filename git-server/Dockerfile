FROM alpine:3.4

MAINTAINER Mikael Kalms "mikael@kalms.org"

# "--no-cache" is new in Alpine 3.3 and it avoid using
# "--update + rm -rf /var/cache/apk/*" (to remove cache)
RUN apk add --no-cache \
# openssh=7.2_p2-r1 \
  openssh \
# git=2.8.3-r0
  git

# SSH autorun
# RUN rc-update add sshd

WORKDIR /git-server/

# -D flag avoids password generation
# -s flag changes user's shell
RUN mkdir /keys \
  && adduser -D -s /usr/bin/git-shell git \
  && echo git:12345 | chpasswd \
  && mkdir /home/git/.ssh

# Set up repositories folder; these repos will be accessible as git@<host>:repos/<reponame>.git 
RUN mkdir /repos \
  && chown git:git /repos \
  && ln -s /repos /home/git/repos
  
# This is a login shell for SSH accounts to provide restricted Git access.
# It permits execution only of server-side Git commands implementing the
# pull/push functionality, plus custom commands present in a subdirectory
# named git-shell-commands in the user’s home directory.
# More info: https://git-scm.com/docs/git-shell
COPY git-shell-commands /home/git/git-shell-commands

RUN chown -R git:git /home/git/git-shell-commands \
	&& chmod 755 /home/git/git-shell-commands/*

# sshd_config file is edited for enable access key and disable access password
COPY sshd_config /etc/ssh/sshd_config
COPY start.sh start.sh

EXPOSE 22

VOLUME /keys
VOLUME /repos

CMD ["sh", "start.sh"]
