# UExpressのrubyのバージョン
FROM ruby:2.7.4

# /上1文/開発に便利なコマンドをインストールしていると思われる
# /下2文/上記指定ではDebian(DockerHub説明文&多分)+Debianの場合のyarnのinstall方法(公式)
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# yarn,nodejsインストール＋その他情報削除+α.多分3文目は必須。実行時にエラーが出るらしい(Docker or CircleCI)
RUN apt-get update && apt-get install -y --no-install-recommends  nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /UExpress

WORKDIR /UExpress

COPY Gemfile /UExpress/Gemfile
COPY Gemfile.lock /UExpress/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /UExpress

# rails sの代用?
CMD ["rails", "server", "-b", "0.0.0.0"]