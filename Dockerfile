# ------------------------------------------------------------------------------
#
#                                 Build stage
#
# ------------------------------------------------------------------------------
FROM ruby:2.4-alpine3.6 as builder

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk update && \
    apk --no-cache --update add build-base bash python nodejs nodejs-npm \
    libsass "postgresql-dev<9.7" && rm -rf /var/cache/apk/*

ENV RACK_ENV=production

RUN mkdir -p /opt/app

WORKDIR /opt/app

# Cache node deps
RUN mkdir assets

COPY assets ./assets

WORKDIR ./assets

RUN npm install && npm rebuild node-sass --force

RUN npm run build

WORKDIR /opt/app

RUN rm -rf assets

COPY Gemfile .
COPY Gemfile.lock .

RUN mkdir deps && bundle install --path deps

COPY . .

# ------------------------------------------------------------------------------
#
#                             Release stage
#
# ------------------------------------------------------------------------------
FROM ruby:2.4-alpine3.6

RUN apk update && \
    apk --no-cache --update add bash ruby-bundler "libpq<9.7" && \
    rm -rf /var/cache/apk/*

ENV RACK_ENV=production

RUN mkdir -p /opt/app

WORKDIR /opt/app

COPY --from=builder /opt/app .

RUN bundle install --path deps

CMD bundle exec puma -C config/puma.rb