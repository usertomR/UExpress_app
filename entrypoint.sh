#!/bin/sh
set -e

# server.pidがあると不具合を起こすことがあるはず。
rm -f /myapp/tmp/pids/server.pid

# データベースとアセットのセットアップ
# bundle exec rails db:migrate:reset RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1
# bundle exec rails db:seed RAILS_ENV=production
bundle exec rails assets:precompile RAILS_ENV=production

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"