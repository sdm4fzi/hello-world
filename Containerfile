FROM python:3.10-slim as builder

COPY requirements.txt /requirements.txt
COPY src/main.py /main.py

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      gcc \
    && python3 -m pip wheel --no-cache-dir --wheel-dir=/wheels -r /requirements.txt \
    && apt-get remove -y \
      build-essential \
      gcc \
    && apt-get autoremove -y \
    && rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/python3", "/main.py"]

LABEL "org.opencontainers.image.documentation"="https://github.com/sdm4fzi/hello-world" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/sdm4fzi/hello-world" \
      "org.opencontainers.image.url"="https://www.23technologies.cloud" \
      "org.opencontainers.image.vendor"="23 Technologies GmbH"
