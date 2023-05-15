# Dockerfile

FROM ruby:3.2.0

WORKDIR /usr/app
COPY  . ./
RUN bundle install

EXPOSE $SERVER_PORT

CMD ["bundle", "exec", "rackup", "-p", $SERVER_PORT]
