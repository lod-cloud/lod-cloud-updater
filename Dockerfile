FROM ubuntu:20.04

RUN apt update 
RUN DEBIAN_FRONTEND="noninteractive" apt install -y git cargo python3 maven liblbfgs-dev gfortran make python3-pip imagemagick zip
RUN pip3 install beautifulsoup4 requests
RUN git clone https://github.com/lod-cloud/lod-cloud-draw
RUN cd lod-cloud-draw && RUST_BACKTRACE=full cargo build --release
RUN git clone https://github.com/lod-cloud/lod-cloud-site
RUN cd lod-cloud-site && mvn install
ADD run.sh /
ADD versions.zip /lod-cloud-site/src/main/webapp/versions/
RUN chmod a+x run.sh
# DEBUG
ADD lod-data.json /lod-cloud-draw/

ENTRYPOINT /run.sh
