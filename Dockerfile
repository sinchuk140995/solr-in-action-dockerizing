FROM maven:3-jdk-8
ARG SOLR_VER=4.7.0

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y git \
    && apt-get install -y curl \
    && apt-get install -y vim \
    && rm -rf /var/lib/apt/lists/*

# SOLR
# if you don't have local one
# RUN curl https://archive.apache.org/dist/lucene/solr/${SOLR_VER}/solr-${SOLR_VER}.tgz --output solr-${SOLR_VER}.tgz
# if you have local one
COPY solr-${SOLR_VER}.tgz /
RUN tar xvf solr-${SOLR_VER}.tgz \
    && mv solr-${SOLR_VER} solr \
    && rm solr-${SOLR_VER}.tgz

# Solr In Action docs
RUN git clone https://github.com/treygrainger/solr-in-action.git \
    && cd solr-in-action \
    && mvn clean package

# ch10 core
RUN cp -r /solr-in-action/example-docs/ch10/cores/solrpedia /solr/example/solr/

COPY start.sh /
RUN chmod +x /start.sh

EXPOSE 8983
WORKDIR /solr/example/solr
CMD ["/start.sh"]
