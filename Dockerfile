FROM debian:jessie

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python-dev \
    python-pip \
    libffi-dev \
    libssl-dev \
    binutils \
    pwgen \
    git \
    scons \
    liblzma-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools pip

ARG PYINSTALLER_TAG=v3.4
# Build bootloader for alpine
RUN git clone --depth 1 --single-branch --branch $PYINSTALLER_TAG https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
    && cd /tmp/pyinstaller/bootloader \
    && python3 ./waf configure --no-lsb all \
    && pip3 install .. \
    && rm -Rf /tmp/pyinstaller

# Install staticx to convert pyinstaller dynamic binary to static
RUN pip2 install patchelf-wrapper backports.lzma && \
    pip2 install https://github.com/JonathonReinhart/staticx/archive/master.zip

WORKDIR /src
ADD ./bin /pyinstaller
RUN chmod a+x /pyinstaller/*

ENTRYPOINT ["/pyinstaller/pyinstaller.sh"]
