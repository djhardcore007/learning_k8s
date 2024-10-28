FROM debian:12.5
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      apt-utils \
      curl \
      dnsutils \
      dumb-init \
      expect \
      iputils-ping \
      ldap-utils \
      locales \
      man \
      mtr-tiny \
      nano \
      neovim \
      net-tools \
      netcat-openbsd \
      nmap \
      procps \
      strace \
      stress \
      sudo \
      traceroute \
      vim \
      wget \
      xclip- \
      xauth- \
      libx11-6- \
      zip && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    sed -i '/C.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/bash" ]