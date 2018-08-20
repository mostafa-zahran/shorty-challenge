FROM ruby:2.2.5
RUN apt-get update -qq && apt-get install -y build-essential
ENV APP_HOME /shorty

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock

RUN bundle install
ADD . $APP_HOME

EXPOSE 9292
