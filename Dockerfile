FROM alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.opencontainers.image.title="Makeself" \
    org.opencontainers.image.description="A self-extracting archiving tool for Unix systems, in 100% shell script." \
    org.opencontainers.image.url="https://github.com/rothwerx/makeself" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.authors="Jeremiah Roth"

WORKDIR /tmp

RUN apk --update add tar xz pigz

COPY . .

ENTRYPOINT ["/tmp/makeself.sh"]
CMD ["--help"]
