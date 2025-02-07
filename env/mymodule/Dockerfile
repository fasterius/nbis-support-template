#
# First stage: Build Pixi environment
#
FROM ghcr.io/prefix-dev/pixi:0.37.0 AS build
LABEL org.opencontainers.image.authors="erik.fasterius@nbis.se"
LABEL org.opencontainers.image.description="Dockerfile for the #0000 NBIS support project"

# Copy the environment toml
COPY pixi.toml pixi.lock /

# Install the Pixi environment as 'default'
RUN pixi install

# Create the shell-hook bash script that will activate the environment
RUN pixi shell-hook > /shell-hook.sh

# Extend the shell-hook script to run the command passed to at run-time
RUN echo 'exec "$@"' >> /shell-hook.sh

#
# Last stage: final image
#
FROM ubuntu:20.04 AS work
WORKDIR /work

# Copy over environment and shell-hook script from build stage
COPY --from=build /.pixi/envs/default /.pixi/envs/default
COPY --from=build /shell-hook.sh /shell-hook.sh

# Activate the Pixi environment when running the container
ENTRYPOINT ["/bin/bash", "/shell-hook.sh"]
CMD /bin/bash
