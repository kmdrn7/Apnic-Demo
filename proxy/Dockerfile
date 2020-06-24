FROM nginx:alpine

RUN rm /etc/nginx/conf.d/*

COPY proxy.conf /etc/nginx/conf.d/

COPY apnic.sh /app/apnic/

ENTRYPOINT ["/app/apnic/apnic.sh"]