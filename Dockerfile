# FROM python:alpine

# RUN apk add --no-cache git

# WORKDIR /app

# COPY requirements.txt .

# RUN pip install --no-cache-dir -r requirements.txt





FROM python:alpine AS base

ENV  POETRY_VERSION=1.8.5 \
  PYTHONUNBUFFERED=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_HOME="/opt/poetry" \
  POETRY_VIRTUALENVS_IN_PROJECT=true \
  POETRY_NO_INTERACTION=1 \
  PYSETUP_PATH="/opt/pysetup" \
  VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"


FROM base AS builder

RUN --mount=type=cache,target=/root/.cache \
  pip install "poetry==$POETRY_VERSION"

WORKDIR $PYSETUP_PATH

COPY ./poetry.lock ./pyproject.toml ./

RUN --mount=type=cache,target=$POETRY_HOME/pypoetry/cache \
  poetry install --no-dev


FROM base AS production

COPY --from=builder $VENV_PATH $VENV_PATH

COPY ./ /app/

WORKDIR /app
