# battlesnake_crystal

Battlesnake 2018 written in Crystal because why not.


## Installation

Install Crystal off the website or just use:

```
brew update
brew install crystal-lang
```

Then to install deps run:

`crystal deps`


## Usage

For hotcode reloading, install sentry:
[sentry](https://github.com/samueleaton/sentry)

Then call: `./sentry` from the project directory to run it with hot reloading.

Otherwise, to run the server, run:

`crystal src/battlesnake_crystal.cr`

## Battlesnake stuff:

There is an example start request in: start.json

There is an example move request in: move.json

## Issues

If you run into a libssl issue, try:
`https://github.com/crystal-lang/crystal/issues/4745#issuecomment-332553374`

