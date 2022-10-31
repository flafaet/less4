FROM debian:9 as build

RUN apt update && apt install -y wget gcc make && mkdir /root/src
WORKDIR /root/src
RUN wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.gz && tar xvfz pcre2-10.40.tar.gz
RUN wget http://zlib.net/zlib-1.2.13.tar.gz && tar xvfz zlib-1.2.13.tar.gz
RUN wget http://nginx.org/download/nginx-1.22.1.tar.gz && tar xvfz nginx-1.22.1.tar.gz && cd nginx-1.22.1 && ./configure --with-pcre=/root/src/pcre2-10.40 --with-zlib=/root/src/zlib-1.2.13 && make && make install

FROM debian:9
WORKDIR /usr/local/nginx/sbin
COPY --from=build /usr/local/nginx/sbin/nginx .
RUN mkdir ../logs ../conf && touch ../logs/error.log && chmod +x nginx
CMD ["./nginx", "-g", "daemon off;"]
