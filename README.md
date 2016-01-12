# What is Politor ?
Politor is a Modular collection of gulp-tasks

# Getting started

install the politor-cli (`npm i -g politor-cli`)

- scaffold your project by running `politor create AppName`
- choose a core-module to start with i.e. `Angular 1` (this will create a basic app structure with a template gulpfile and package.json)

run the preregistered tasks politor provides for your development workflow

# Politor Angular App
Politor Core Module for building Angular(1) Apps

# Common Tasks
name | description | environment
-----|-------------|------------
`web:dev:build` | builds a version of the Project in Development State (not minified or concateneted) | development
`web:dev:serve` | the main task for development (transpiles everything, injects it into index.html, creates local server) | development
`web:clean` | clean the dev and dist folder | development & distribution
`web:build` | create a fully optimised build of your current app | distribution
`web:dist:serve` | run `web:build` and serves the result from the `dist`-directory | distribution


