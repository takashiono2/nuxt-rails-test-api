# ベースイメージを指定する 「FROM ベースイメージ:タグ」という構成
FROM ruby:2.7.2-alpine
#Dockerfile内で使用する変数を定義する
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

# 環境変数を定義（Dockerfile,コンテナ参照可）
ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo
# ベースイメージに対してコマンドを実行する ${変数}　echoは展開せよという命令　WORKDIRにはappが入るので、${HOME}=>/app
# RUN echo ${HOME}
# Dockerfile内で指定した命令を実行する
WORKDIR ${HOME}
#ホスト側（自分のPC）のファイルをコンテナにコピー Gemfileから始まる始まる全指定（Gemfile,Gemfile.lock）
COPY Gemfile* ./
#apkは、alpine Linuxのコマンド
RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies
#「.」は、Dockerfileにあるディレクトリの全てのファイル
COPY . ./

# CMD /bin/sh -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"