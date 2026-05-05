FROM alpine:latest

RUN apk add --no-cache bpftrace gcc musl-dev wget \
    && wget -q -O /tmp/vmtouch.c https://raw.githubusercontent.com/hoytech/vmtouch/master/vmtouch.c \
    && gcc -O2 -o /usr/local/bin/vmtouch /tmp/vmtouch.c \
    && rm /tmp/vmtouch.c \
    && apk del gcc musl-dev wget

CMD ["/bin/sh"]