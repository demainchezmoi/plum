# FROM 383646808490.dkr.ecr.eu-west-1.amazonaws.com/demainchezmoi/plum:0.0.1.20-6bd3e51574
# EXPOSE 4000
# # ENTRYPOINT ["/opt/app/bin/plum"]
# CMD ["foreground"]
FROM bitwalker/alpine-erlang:19.3

RUN apk update && \
    apk --no-cache --update add bash libgcc libstdc++ && \
    rm -rf /var/cache/apk/*

EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/sh

ADD plum.tar.gz ./
RUN chown -R default ./releases

USER default

ENTRYPOINT ["/opt/app/bin/plum"]
CMD ["foreground"]
