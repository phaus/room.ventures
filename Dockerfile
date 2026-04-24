FROM hugomods/hugo:exts as build
WORKDIR /src
COPY . .
RUN hugo --minify

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
