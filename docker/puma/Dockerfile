FROM ruby:2.3.3

RUN \
  gem install bundler foreman && \
  mkdir install /app

COPY ./app/Gemfile /app/Gemfile

WORKDIR /app
RUN bundle install
