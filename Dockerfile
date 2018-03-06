FROM postgres:10-alpine
LABEL maintainer "unicorn research Ltd"

ARG googlesdk="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-185.0.0-linux-x86_64.tar.gz"

RUN apk update \
  && apk add --no-cache curl python

WORKDIR /tmp
RUN curl ${googlesdk} -o google-cloud-sdk.tar.gz

COPY profile /root/.profile

WORKDIR /root
RUN tar xzf /tmp/google-cloud-sdk.tar.gz \
  && CLOUDSDK_CORE_DISABLE_PROMPTS=1 ./google-cloud-sdk/install.sh \
  && CLOUDSDK_CORE_DISABLE_PROMPTS=1 /root/google-cloud-sdk/bin/gcloud components update

RUN sed -i -e 's/set -e/set -e\n\ncrond -L \/var\/log\/cron.log/g' /usr/local/bin/docker-entrypoint.sh
