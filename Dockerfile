# See https://codeship.com/documentation/docker/browser-testing/
FROM ubuntu:20.04

# We need wget to set up the PPA and xvfb to have a virtual screen and unzip to install the Chromedriver
# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update
RUN apt-get install -y wget gnupg unzip curl git xz-utils zip
RUN apt-get install -y libglu1-mesa xvfb

# Install chrome
RUN apt-get install -y google-chrome-stable

# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 94.0.4606.61
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR

# Download and install Chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH
RUN chmod +x $CHROMEDRIVER_DIR/chromedriver


#Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
#RUN export PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"
ENV PATH $PATH:/usr/local/flutter/bin/:/usr/local/flutter/bin/cache/dart-sdk/bin

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web
RUN flutter doctor -v
