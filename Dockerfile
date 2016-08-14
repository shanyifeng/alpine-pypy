FROM alpine

MAINTAINER qinqie<qinqie@live.cn>

RUN apk add --update musl git curl perl libgcc libbz2 libffi libgcrypt ncurses-libs build-base python-dev gfortran
RUN apk add openblas openblas-dev --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

ENV PYPY pypy-5.3.1-linux_x86_64-portable
ENV GLIBC_VER 2.21-r2

ADD https://bitbucket.org/squeaky/portable-pypy/downloads/${PYPY}.tar.bz2 /tmp/${PYPY}.tar.bz2
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN cd /tmp/ && \
    tar -xjf ${PYPY}.tar.bz2 && \
    cp -rp ${PYPY} /usr/lib/pypy && \
    rm -rf /tmp/${PYPY}.tar.bz2 && \
    rm -rf /tmp/${PYPY}

RUN ln -s /usr/lib/pypy/bin/pypy /usr/local/bin/pypy

RUN ln -s -f /usr/lib/libncurses.so.5.9 /usr/lib/libtinfo.so.5 && \
    ln -s -f /usr/lib/libbz2.so.1 /usr/lib/libbz2.so.1.0 && \
    ln -s -f /usr/lib/libgcrypt.so.20 /usr/lib/libcrypt.so.1

RUN ldd /usr/lib/pypy/bin/pypy
RUN cd /tmp/ && \
    pypy get-pip.py && \
    # pypy3 -m pip install git+https://bitbucket.org/pypy/numpy.git && \
    rm get-pip.py

RUN ln -s /usr/lib/pypy/bin/pip /usr/local/bin/pip

RUN rm -rf /root/.cache/pip/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
