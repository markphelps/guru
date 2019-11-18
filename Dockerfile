FROM ruby:2.3-slim

LABEL maintainer='Mark Phelps <mark.aaron.phelps@gmail.com>'

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  git-core \
  libpq-dev \
  libxml2-dev libxslt1-dev \
  libqtwebkit4 libqt4-dev xvfb \
  sqlite3 libsqlite3-dev \
  nodejs && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app/

ENV BUNDLE_PATH /gems

RUN gem install bundler -v '~> 1.0' && \
    bundle install

EXPOSE 3000
CMD ["bundle", "exec", "unicorn", "-p", "3000", "-E", "development"]
