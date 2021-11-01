FROM debian:bullseye AS build

ENV SOLANA_VERSION v1.7.14
ENV GOSU_VERSION 1.10

RUN apt-get update && apt -y upgrade && apt-get -y install curl git gcc make bzip2
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y install nodejs yarn
RUN apt-get -y install libpixman-1-0 libcairo2 libpangocairo-1.0-0 librsvg2-2 libjpeg62-turbo libgif7 libudev-dev librust-libudev-sys-dev libssl-dev

WORKDIR /root

RUN sh -c "$(curl -sSfL https://release.solana.com/$SOLANA_VERSION/install)"
RUN cp -r /root/.local/share/solana/install/active_release/bin/* /usr/local/bin/
RUN git clone https://github.com/metaplex-foundation/metaplex
# RUN cd metaplex/js/packages/cli && \
# 	yarn install --ignore-engines && \
# 	yarn build && \
# 	yarn run package:linuxb && \
RUN cd /root && \
	curl https://sh.rustup.rs -sSfo rustup-init.sh && \
	chmod a+x rustup-init.sh && \
	./rustup-init.sh -y

RUN cd $HOME/metaplex/rust && . $HOME/.cargo/env && cargo build-bpf

# -----------------------------------------------------------------------------
# Grab gosu for easy step-down from root
# -----------------------------------------------------------------------------
RUN set -x \
  && curl -Lso /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && curl -Lso /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

FROM debian:bullseye
# -----------------------------------------------------------------------------
# Grab gosu for easy step-down from root
# -----------------------------------------------------------------------------
# COPY --from=build /usr/local/bin/gosu /usr/local/bin/gosu
# -----------------------------------------------------------------------------
# Install Solana tools
# -----------------------------------------------------------------------------
COPY --from=build /root/.local/share/solana/install/active_release/bin/* /usr/local/bin/

# -----------------------------------------------------------------------------
# Copy Metaplex programs
# -----------------------------------------------------------------------------
COPY --from=build /root/metaplex/rust/target/deploy/* /tmp/deploy/

VOLUME /test-data
WORKDIR /test-data

RUN apt-get update && apt -y upgrade && apt-get -y install curl git jq gzip bzip2 nano procps netcat \
	libpixman-1-0 libcairo2 libpangocairo-1.0-0 librsvg2-2 libjpeg62-turbo libgif7 libudev-dev \
	librust-libudev-sys-dev libssl-dev && \
	curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
	echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update && apt-get -y install nodejs yarn && npm install -g ts-node typescript @types/node && \
  echo "#!/bin/sh" > /usr/local/bin/metaplex && \
  echo "/usr/bin/ts-node /test-data/metaplex/js/packages/cli/src/candy-machine-cli.ts \"\$@\"" >> /usr/local/bin/metaplex && \
  chmod a+x /usr/local/bin/metaplex && \
	useradd -N -M -d /test-data -s /bin/bash solana && chown -R solana:users /test-data && \
	apt clean

ADD patch.diff /tmp
ADD docker-startup.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker-startup.sh

# Gossip Address
EXPOSE 1024
#TPU Address
EXPOSE 1027
#JSON RPC URL
EXPOSE 8899
# WebSocket URL
EXPOSE 8900

USER solana

ENTRYPOINT ["docker-startup.sh"]
