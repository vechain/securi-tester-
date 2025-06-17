FROM node:10.24.1

RUN apt-get update && \
    apt-get install -y openssl=1.0.1f-1ubuntu2 python2.7 python-pip openssh-server=1:6.6p1-2ubuntu2

COPY . /app
WORKDIR /app
CMD ["node", "app/web.js"]
