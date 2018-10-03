#
# Dockerfile for *nix host
#
# Usage:
#   docker build -t airthingswave .
#   docker run -it --rm --privileged --volume /sys/fs/cgroup:/sys/fs/cgroup:ro airthingswave /bin/bash
#

# Define base image
FROM buildpack-deps:latest

# Declare build environment variables
ENV AIRTHINGSWAVE_VERSION 0.2
ENV VERSION 0.2
ENV container docker

# Label image with metadata
LABEL org.label-schema.name="balena AirthingsWave Debian" \
      org.label-schema.description="Airthings Wave radon detector bridge for single-board computers." \
      org.label-schema.vcs-url="https://github.com/renemarc/balena-airthingswave-debian" \
      org.label-schema.url="https://airthings.com/wave/" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"

# Setup application directory
WORKDIR /usr/src/app

# Install requirements
#   `gettext` to use `envsubst` in `start.sh`
RUN apt-get update \
 && apt-get install --yes --quiet \
      dbus \
      gettext \
      python \
      python-pip \
      systemd \
      systemd-sysv \
 && pip install --no-cache-dir \
      airthingswave-mqtt==${AIRTHINGSWAVE_VERSION} \
      PyYAML \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy project files in their proper locations
COPY ["airthingswave-mqtt.service", "airthingswave-mqtt.timer", "/etc/systemd/system/"]
COPY ["config.yaml", "start.sh", "./"]

# Enable systemd service unit
RUN systemctl enable airthingswave-mqtt

# Start the main loop
CMD ["/usr/src/app/start.sh"]
