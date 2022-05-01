FROM debian:bullseye-slim as builder

COPY src/main.py /main.py

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      python3-pymodbus \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/python3", "/main.py"]

LABEL "org.opencontainers.image.documentation"="https://github.com/sdm4fzi/hello-world" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/sdm4fzi/hello-world" \
      "org.opencontainers.image.url"="https://www.23technologies.cloud" \
      "org.opencontainers.image.vendor"="23 Technologies GmbH"
