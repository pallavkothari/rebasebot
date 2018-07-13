FROM golang:1.5
MAINTAINER Pallav Kothari <me@pallavkothari.com>

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOROOT/bin

# Install rebasebot
#RUN go get -u github.com/pallavkothari/rebasebot
ADD . /go/src/github.com/pallavkothari/rebasebot
RUN go install github.com/pallavkothari/rebasebot

# Configure Git
RUN git config --global user.name "Rebase Bot"
RUN git config --global user.email "rebase-bot@users.noreply.github.com"

# Set default container command
CMD rebasebot
