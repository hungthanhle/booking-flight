# Base image sử dụng Ruby on Rails và các dependencies
FROM ruby:3.0.4

# Cài đặt các dependencies cần thiết
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn

# Thiết lập thư mục làm việc
WORKDIR /web

# Sao chép Gemfile và Gemfile.lock
COPY Gemfile* ./

# Cài đặt các gems cần thiết cho Rails
RUN gem install bundler && bundle install

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Precompile assets cho development (nếu cần)
RUN RAILS_ENV=development bundle exec rake assets:precompile

# Mở port 3000 cho Rails server
EXPOSE 3000

# Command để khởi động server Rails
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]
