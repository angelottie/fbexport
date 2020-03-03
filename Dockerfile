FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y g++ make libfbclient2

COPY . /build/fbexport
WORKDIR /build/fbexport
RUN make
RUN cp exe/fbexport /usr/local/bin
RUN cp exe/fbcopy /usr/local/bin
WORKDIR /
