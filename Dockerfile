FROM ruby:2.3.3-slim

RUN gem install bundler && gem update bundler && \
      apt-get update && \
      apt-get install -y --no-install-recommends \
      build-essential nodejs less \
      libnetcdf-dev libmysqlclient-dev libxml2-dev && \
      rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ARG bundle_jobs

ENV BUNDLE_JOBS=$bundle_jobs

ADD . $APP_HOME
