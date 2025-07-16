FROM insideo/centos7-java8-build AS base
LABEL maintainer="pqjrkwem@gmail.com"

RUN groupadd -g 12349 dinstall \
 && groupadd -g 12350 dmdba \
 && useradd -u 12345 -g dinstall -G dmdba -m -d /home/dmdba -s /bin/bash dmdba \
 && echo 'dmdba:dmdba' | chpasswd

ARG INSTALL_FILE="DMInstall.bin"
ENV SOFT_DIR=/soft \
    INSTALL_DIR=/opt/dmdbms \
    CONFIG_INI=db_install.ini \
    DATA_DIR=/opt/data

COPY $INSTALL_FILE $CONFIG_INI db_instance.sh $SOFT_DIR/

# 用 root 权限安装达梦数据库
RUN mkdir -p $SOFT_DIR $INSTALL_DIR \
 && /soft/$INSTALL_FILE -q /soft/$CONFIG_INI \
 && rm -f /soft/$INSTALL_FILE \
 && chmod +x /soft/db_instance.sh \
 && mkdir -p $DATA_DIR \
 && chown -R dmdba:dinstall $INSTALL_DIR $DATA_DIR || true

# 切换到非 root 用户
USER dmdba
WORKDIR /opt/dmdbms/bin
CMD ["/soft/db_instance.sh"]
