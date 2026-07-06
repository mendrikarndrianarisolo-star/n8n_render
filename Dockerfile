FROM node:20-slim

RUN apt-get update && apt-get install -y tini && rm -rf /var/lib/apt/lists/*

RUN groupadd -r n8n && useradd -r -g n8n -d /home/n8n -m n8n

RUN npm install -g n8n@1.86.0

RUN mkdir -p /home/n8n/.n8n && \
    chown -R n8n:n8n /home/n8n/.n8n && \
    chmod 700 /home/n8n/.n8n

RUN echo '#!/bin/bash\n\
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false\n\
export N8N_RELEASE_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")\n\
exec n8n start\n' > /start.sh && chmod +x /start.sh

USER n8n

ENV N8N_BASIC_AUTH_ACTIVE=false
ENV N8N_PORT=10000
ENV N8N_HOST=0.0.0.0
ENV N8N_PROTOCOL=https
ENV GENERIC_TIMEZONE=Europe/Paris

ENV DB_TYPE=sqlite
ENV DB_SQLITE_VACUUM_ON_STARTUP=true

EXPOSE 10000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/start.sh"]
