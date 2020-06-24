# FETCHER
FROM nginx:alpine AS fetcher

WORKDIR /app/

COPY apnic.sh /app/

RUN chmod +x /app/apnic.sh && /app/apnic.sh

# APP
FROM nginx:alpine

COPY proxy.conf /etc/nginx/conf.d/default.conf

COPY docker-network.sh /docker-entrypoint.d/

COPY --from=fetcher /app/apnic.sh /app/

COPY --from=fetcher /etc/nginx/conf.d/ip-list.conf /etc/nginx/conf.d/

RUN echo "0 0 * * * /app/apnic.sh" >> /etc/crontabs/root