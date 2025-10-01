FROM alpine:3.22.1 as builder

RUN apk add --no-cache python3 py3-pip python3-dev

WORKDIR /home/appuser
COPY requirements.txt .
RUN python3 -m venv /home/appuser/venv && \
    . /home/appuser/venv/bin/activate && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

FROM alpine:3.22.1

RUN apk add --no-cache python3

RUN addgroup -g 10001 appuser && \
    adduser -u 10001 -G appuser -s /sbin/nologin -D -h /home/appuser appuser

COPY --from=builder /home/appuser/venv /home/appuser/venv

WORKDIR /home/appuser
COPY --chown=appuser:appuser helloapp/ ./helloapp/
COPY --chown=appuser:appuser run.sh ./run.sh
RUN chmod +x run.sh

USER appuser
ENV PATH="/home/appuser/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080')" || exit 1

EXPOSE 8080

CMD ["./run.sh"]