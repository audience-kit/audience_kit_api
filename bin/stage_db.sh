#!/usr/bin/env bash

heroku pg:copy hotmess-api::DATABASE_URL DATABASE_URL --app hotmess-api-next --confirm hotmess-api-next