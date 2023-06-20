# Dockerfile

FROM ruby:3.2.0-alpine

ENV APP_HOME /usr/app
ENV BUILD_PACKAGES="build-base curl-dev git postgresql-dev" \
    DEV_PACKAGES="postgresql-client yaml-dev zlib-dev" \
    RUBY_PACKAGES="ruby-json ruby-dev"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk add --no-cache build-base
COPY Gemfile* ./
RUN bundle install
COPY . ./
EXPOSE $PORT
CMD ["sh", "-c", "bundle exec rackup -p $PORT -o 0.0.0.0"]
