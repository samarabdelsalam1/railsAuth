FROM ruby:3.3

ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000
ARG APP_USER=auth_app_user
ARG PROJECT_DIRECTORY=auth_app

# Directories
ENV USER_HOME_DIRECTORY=/home/${APP_USER}
ENV APP_PATH=${USER_HOME_DIRECTORY}/${PROJECT_DIRECTORY}
ENV BUNDLED_GEMS_PATH=/bundle
ENV BUNDLE_PATH=${BUNDLED_GEMS_PATH}
ENV BUNDLE_BIN=${BUNDLED_GEMS_PATH}/bin
ENV BUNDLE_APP_CONFIG=${BUNDLED_GEMS_PATH}
ENV PATH=${BUNDLE_BIN}:${PATH}

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  curl \
  nodejs \
  npm \
  vim \
  postgresql-client \
  && npm install -g corepack \
  && corepack enable \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -md ${USER_HOME_DIRECTORY} -u ${APP_USER_ID} -s /bin/bash ${APP_USER} && \
    mkdir -p ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR} && \
    chown -R ${APP_USER}:${APP_USER} ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR}


WORKDIR ${USER_HOME_DIRECTORY}
# Copy entrypoint to docker home directory
# Copy entrypoint into the app directory
COPY --chown=${APP_USER}:${APP_USER} entrypoint.sh ${APP_PATH}/entrypoint.sh

# Ensure it’s executable
RUN chmod +x ${APP_PATH}/entrypoint.sh

# Save Rails Console's history
RUN echo "require 'irb/ext/save-history'\n\
IRB.conf[:SAVE_HISTORY] = 500\n\
IRB.conf[:HISTORY_FILE] = '${APP_PATH}/.irb-history'\n" >> ${USER_HOME_DIRECTORY}/.irbrc


USER ${APP_USER}

WORKDIR ${APP_PATH}

COPY --chown=${APP_USER} Gemfile .
COPY --chown=${APP_USER} Gemfile.lock .

RUN bundle install --jobs $(getconf _NPROCESSORS_ONLN) --retry 3