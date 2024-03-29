# UExpressのrubyのバージョン
FROM ruby:2.7.4

ENV RAILS_ENV=production

# /上1文/開発に便利なコマンドをインストールしていると思われる
# /下2文/上記指定ではDebian(DockerHub説明文&多分)+Debianの場合のyarnのinstall方法(公式)
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# yarn,nodejsインストール＋その他情報削除+α.多分3文目は必須。実行時にエラーが出るらしい(Docker or CircleCI)
RUN apt-get update && apt-get install -y --no-install-recommends  nodejs yarn \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /uexpress

WORKDIR /uexpress

COPY Gemfile /uexpress/Gemfile
COPY Gemfile.lock /uexpress/Gemfile.lock

RUN gem install bundler
RUN bundle install
RUN rails action_text:install

# ホストのUExpressディレクトリのものを全てコンテナにコピー
COPY . /uexpress
# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

VOLUME /uexpress/public
VOLUME /uexpress/tmp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD /bin/sh -c "rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb"