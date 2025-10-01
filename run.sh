#!/bin/sh

# Assumes an existing virtualenv at venv
. venv/bin/activate
gunicorn --bind 0.0.0.0:8080 -w 2 --timeout 30 --keep-alive 2 helloapp.app:app
