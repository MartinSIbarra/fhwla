FROM alpine:latest

RUN apk add --no-cache lighttpd

# Crear carpeta web
RUN mkdir -p /var/www/localhost/htdocs

# Configuración personalizada de Lighttpd en el puerto 3000
RUN echo "server.document-root = \"/var/www/localhost/htdocs\"" > /etc/lighttpd/lighttpd.conf && \
    echo "server.port = 3000" >> /etc/lighttpd/lighttpd.conf && \
    echo 'index-file.names = ( "index.html" )' >> /etc/lighttpd/lighttpd.conf

EXPOSE 3000

# CMD genera el index dinámicamente usando `hostname`
CMD sh -c 'echo "¡App fake $(hostname)!" > /var/www/localhost/htdocs/index.html && lighttpd -D -f /etc/lighttpd/lighttpd.conf'
