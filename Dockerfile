FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    flex \
    bison \
    make \
    && rm -rf /var/lib/apt/lists/*


VOLUME ["/app"]
WORKDIR /app

CMD ["tail","-f","/dev/null"]