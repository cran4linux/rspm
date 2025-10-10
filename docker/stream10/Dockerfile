FROM quay.io/centos/centos:stream10

LABEL org.opencontainers.image.licenses="GPL-2.0" \
      org.opencontainers.image.source="https://github.com/cran4linux/rspm" \
      org.opencontainers.image.authors="Iñaki Ucar <iucar@fedoraproject.org>"

# install R
RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y install R-core-devel /usr/bin/su \
    && dnf -y clean all

CMD ["bash"]
