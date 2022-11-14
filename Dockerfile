# Build a virtualenv using the appropriate Debian release
# * Install python3-venv for the built-in Python3 venv module (not installed by default)
# * Install gcc libpython3-dev to compile C Python modules
# * In the virtualenv: Update pip setuputils and wheel to support building new packages
FROM debian:11-slim AS build
# hadolint ignore=DL3008,DL3009
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel

# Install dependencies:
COPY requirements.txt /requirements.txt
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel

# Build the virtualenv as a separate step: Only re-execute this step when requirements.txt changes
FROM build AS build-venv
COPY requirements.txt /requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Now setup distroless and run the application:
# hadolint ignore=DL3006,DL3007
FROM gcr.io/distroless/python3:latest-${TARGETARCH}

COPY --from=build-venv /venv /venv
COPY ./app /app/
WORKDIR /app


# Start Server
ENTRYPOINT ["/venv/bin/python3", "/app/modbus_server.py"]
CMD ["-f", "/app/modbus_server.json"]
