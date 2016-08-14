FROM alpine

MAINTAINER qinqie<qinqie@live.cn>


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

RUN ldd /usr/lib/pypy/bin/pypy
RUN cd /tmp/ && \
    pypy get-pip.py && \
    # pypy3 -m pip install git+https://bitbucket.org/pypy/numpy.git && \
    rm get-pip.py

RUN ln -s /usr/lib/pypy/bin/pip /usr/local/bin/pip

RUN rm -rf /root/.cache/pip/* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
