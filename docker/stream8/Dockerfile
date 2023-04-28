FROM quay.io/centos/centos:stream8

LABEL org.opencontainers.image.licenses="GPL-2.0" \
      org.opencontainers.image.source="https://github.com/Enchufa2/rspm" \
      org.opencontainers.image.authors="Iñaki Ucar <iucar@fedoraproject.org>"

# install R
RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
    && dnf -y install 'dnf-command(config-manager)' \
    && dnf config-manager --set-enabled powertools \
    && dnf -y install epel-release epel-next-release \
    && dnf -y install R-core-devel \
    && dnf -y clean all

CMD ["bash"]
