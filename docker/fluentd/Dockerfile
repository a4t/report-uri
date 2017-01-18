FROM fluent/fluentd

USER root
RUN \
  apk add --update ruby-dev gcc build-base

USER fluent
RUN \
  gem install fluent-plugin-norikra fluent-plugin-slack
