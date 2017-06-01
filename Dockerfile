FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
#RUN bundle exec rake db:drop
#RUN bundle exec rake db:create
#RUN bundle exec rake db:migrate
#RUN bundle exec rake example:make
#RUN bundle exec rake default_data:load
#RUN bundle exec rake parser:run
ADD . /myapp
RUN echo "open app root url for more info about API"
