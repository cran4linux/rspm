FROM quay.io/centos/centos:centos7

LABEL org.opencontainers.image.licenses="GPL-2.0" \
      org.opencontainers.image.source="https://github.com/Enchufa2/rspm" \
      org.opencontainers.image.authors="Iñaki Ucar <iucar@fedoraproject.org>"

# install R
RUN echo "install_weak_deps=False" >> /etc/yum.conf \
    && yum -y install epel-release \
    && yum -y install R-core \
    && yum -y clean all

CMD ["bash"]
