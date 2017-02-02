FROM ubuntu:16.10
RUN apt-get update && \
	apt-get install make gcc libpq-dev ruby ruby-dev -y && \
	gem install bundler
ADD app.rb Gemfile Gemfile.lock /code/
ADD views/* /code/views/
WORKDIR /code
RUN bundle install
CMD ["bundle", "exec", "ruby", "app.rb"]