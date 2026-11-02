A demo showing how concise and readable the Erlang binary notation is, using a logger as an example. The example supports decoding strings, uint8-32 arrays, and int8-32 (signed and unsigned).

## Build and test

This project uses [Rebar3](https://rebar3.org/). With Erlang/OTP and Rebar3 installed, run:

```sh
rebar3 compile
rebar3 eunit
```

The included development container provides both tools. In VS Code, open the repository in a container using **Dev Containers: Reopen in Container**.
