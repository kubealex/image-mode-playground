FROM registry.redhat.io/rhel9/rhel-bootc:9.6
RUN dnf -y install tmux mkpasswd httpd cloud-init && dnf -y clean all

RUN pass=$(mkpasswd --method=SHA-512 --rounds=4096 redhat) && useradd -m -G wheel bootc-user -p $pass
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/wheel-sudo

RUN mv /var/www /usr/share/www && \
    sed -ie 's,/var/www,/usr/share/www,' /etc/httpd/conf/httpd.conf && \
    systemctl enable httpd
EXPOSE 80
