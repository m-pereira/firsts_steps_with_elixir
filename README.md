# FriendsApp

My fitst app with mix. Just a simple app to manage my friend's number.

## About mix

Mix is a framework for building web applications. It remembers me the rails framework, because it has
a clt, like rails has.

To create a new mix app, you can run:

    $ mix new <application_name>

To compile the app and run the app, just run:

    $ mix run

To compile the app, and start a iex cli, like rails console, run:

    $ mix -S mix

or

      $ MIX_ENV=prod mix -S mix

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `friends_app` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:friends_app, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/friends_app](https://hexdocs.pm/friends_app).
