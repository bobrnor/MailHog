#
# MailHog Dockerfile
#

FROM alpine:3.7

# TODO: remove before release
ENV MH_STORAGE="boltdb" \
    MH_BOLTDB_PATH="/home/mailhog/bolt.db" \
    MH_BOLTDB_BUCKET="mailhog"


# Install ca-certificates, required for the "release message" feature:
RUN apk --no-cache add \
    ca-certificates musl-dev

# Install MailHog:
RUN apk --no-cache add --virtual build-dependencies \
    go \
    git \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go get github.com/bobrnor/MailHog \
  && mv /root/gocode/bin/MailHog /usr/local/bin \
  && rm -rf /root/gocode \
  && apk del --purge build-dependencies

# Add mailhog user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailhog

USER mailhog

WORKDIR /home/mailhog

ENTRYPOINT ["MailHog"]

# Expose the SMTP and HTTP ports:
EXPOSE 1025 8025
