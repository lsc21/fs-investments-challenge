# FS Investments Code Challenge

## Summary

Write code that consumes a YAML file, increments any embedded version
numbers in a variety of ways, and outputs the changed file.

You may use any language, libraries or tools you want, as long as you will be
able to demonstrate your solution in person. Code that you can email to the
interviewers ahead of time usually works best, but other means of
demonstration, such as a laptop with the necessary tools loaded, would be fine
as well.

## Input Specification

YAML file; see included "example.yaml"

Note: Don't rely on the specific structure of the included example, be
prepared to auto-detect version strings or take YAML key names/patterns
as an argument.

## Output Specification

Generate a YAML file that is the same as the input
except with version numbers changed. Include provisions for how to
increment the version numbers (major, minor, release, filtering by key
name, etc.).

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

### Usage

* Bump all major versions in the file
`thor sem_ver_editor:bump -f artifacts/example.yaml -l major`

* Bump all minor versions in the file
`thor sem_ver_editor:bump -f artifacts/example.yaml -l minor`

* Bump all patch versions in the file
`thor sem_ver_editor:bump -f artifacts/example.yaml -l patch`

* Bump all patch versions in the file
`thor sem_ver_editor:bump -f artifacts/example.yaml -l patch`

* Bump all only the semver occurences in this tree of YAML
`thor sem_ver_editor:bump -f artifacts/example.yaml -t advisorUI`

* Bump all only the semver occurences matching this key
`thor sem_ver_editor:bump -f artifacts/example.yaml -k test`


## Built With

* [Semantic](https://github.com/jlindsey/semantic) - A Ruby utility class to aid in the storage, parsing, and comparison of SemVer-style Version strings.

* [Thor](https://github.com/khuda/thor) - An efficient tool for building self-documenting command line tools

