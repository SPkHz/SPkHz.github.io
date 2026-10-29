FROM ruby:slim@sha256:1fbc01ba38b664604059211f69fa5414301100e84468479a08225245cced1ba2

# uncomment these if you are having this issue with the build:
# /usr/local/bundle/gems/jekyll-4.3.4/lib/jekyll/site.rb:509:in `initialize': Permission denied @ rb_sysopen - /srv/jekyll/.jekyll-cache/.gitignore (Errno::EACCES)
# ARG GROUPID=901
# ARG GROUPNAME=ruby
# ARG USERID=901
# ARG USERNAME=jekyll

ENV DEBIAN_FRONTEND noninteractive

LABEL authors="Amir Pourmand,George Araújo" \
      description="Docker image for al-folio academic template" \
      maintainer="Amir Pourmand"

# uncomment these if you are having this issue with the build:
# /usr/local/bundle/gems/jekyll-4.3.4/lib/jekyll/site.rb:509:in `initialize': Permission denied @ rb_sysopen - /srv/jekyll/.jekyll-cache/.gitignore (Errno::EACCES)
# add a non-root user to the image with a specific group and user id to avoid permission issues
# RUN groupadd -r $GROUPNAME -g $GROUPID && \
#     useradd -u $USERID -m -g $GROUPNAME $USERNAME

# Python consumers are independently locked for CPython 3.13/Linux x86-64.
COPY .github/python-installer/requirements.lock /opt/python-locks/installer.lock
COPY .github/python-build-tools/requirements.lock /opt/python-locks/build.lock

# install system dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        imagemagick \
        inotify-tools \
        locales \
        nodejs \
        procps \
        python3-venv \
        zlib1g-dev && \
    test "$(dpkg --print-architecture)" = "amd64" && \
    python3 -c 'import sys; assert sys.version_info[:2] == (3, 13)' && \
    python3 -m venv /opt/site-python && \
    /opt/site-python/bin/python -m pip install --require-hashes --only-binary=:all: \
        --disable-pip-version-check --no-cache-dir -r /opt/python-locks/installer.lock && \
    /opt/site-python/bin/python -m pip install --require-hashes --only-binary=:all: \
        --disable-pip-version-check --no-cache-dir -r /opt/python-locks/build.lock

ENV PATH="/opt/site-python/bin:${PATH}"

# clean up
RUN apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*  /tmp/*

# set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

# set environment variables
ENV EXECJS_RUNTIME=Node \
    JEKYLL_ENV=production \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# create a directory for the jekyll site
RUN mkdir /srv/jekyll

# copy the Gemfile and Gemfile.lock to the image
ADD Gemfile.lock /srv/jekyll
ADD Gemfile /srv/jekyll

# set the working directory
WORKDIR /srv/jekyll

# install jekyll and dependencies
RUN gem install --no-document bundler --version 4.0.15
ENV BUNDLE_FROZEN=true
RUN bundle _4.0.15_ install --no-cache

EXPOSE 8080

COPY bin/entry_point.sh /tmp/entry_point.sh

# uncomment this if you are having this issue with the build:
# /usr/local/bundle/gems/jekyll-4.3.4/lib/jekyll/site.rb:509:in `initialize': Permission denied @ rb_sysopen - /srv/jekyll/.jekyll-cache/.gitignore (Errno::EACCES)
# set the ownership of the jekyll site directory to the non-root user
# USER $USERNAME

CMD ["/tmp/entry_point.sh"]
