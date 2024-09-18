# Gakimint

Gakimint is a Cashu Mint implementation in Elixir.

## Prerequisites

- Elixir 1.14 or later
- Erlang/OTP 24 or later
- PostgreSQL 12 or later

## Setup

1. Clone the repository:

```bash
git clone https://github.com/AbdelStark/gakimint.git
# Go to the project directory
cd gakimint
```

1. Install dependencies:

```bash
mix deps.get
```

1. Set up the database:

- Ensure PostgreSQL is running (you can use the docker-compose file in the `infra` directory to start a postgres instance, i.e `docker-compose -f infra/docker-compose.yml up -d`)
- Update the database configuration in `config/dev.exs` if necessary
- Create and migrate the database:

```bash
mix ecto.setup
```

## Running the Application

To start the Gakimint server:

```bash
mix phx.server
```

The server will be running on `http://localhost:4000`.

## Development

- Run tests:

```bash
mix test
```

- Run the formatter:

```bash
mix format
```

- Generate documentation:

```bash
mix docs
```

## Database management

- Create the database:

```bash
mix ecto.create
```

- Run migrations:

```bash
mix ecto.migrate
```

- Reset the database (drop, create, and migrate):

```bash
mix ecto.reset
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
