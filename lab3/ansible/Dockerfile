FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-client sshpass \
    && pip install --no-cache-dir ansible-core==2.17.8 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY ansible /work/ansible
COPY app /work/app

RUN chmod +x /work/ansible/entrypoint.sh

ENTRYPOINT ["/work/ansible/entrypoint.sh"]
