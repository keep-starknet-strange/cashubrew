# 🌟 Gakimint: Cashu Mints with Elixir Magic ✨

[![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)](https://elixir-lang.org/)
[![Cashu](https://img.shields.io/badge/cashu-ecash-orange?style=for-the-badge)](https://cashu.space/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> 💡 Gakimint: Where Elixir meets Cashu, creating a symphony of secure, scalable, and lightning-fast ecash transactions!

## 🚀 Quick Start

Embark on your Gakimint journey with these simple steps:

1. **Clone the Treasure Map**

   ```bash
   git clone https://github.com/AbdelStark/gakimint.git
   cd gakimint
   ```

2. **Summon the Dependencies**

   ```bash
   mix deps.get
   ```

3. **Prepare the Vault (Database)**

   - Ensure PostgreSQL is running (Use our magic spell: `docker-compose -f infra/docker-compose.yml up -d`)
   - Adjust the incantation in `config/dev.exs` if needed
   - Create and migrate your vault:

     ```bash
     mix ecto.setup
     ```

## 🎭 Running the Show

Launch your Gakimint server with a single command:

```bash
mix phx.server
```

🌈 Voilà! Your mint is now live at `http://localhost:4000`.

## 🛠️ Developer's Toolkit

- **Test the Waters**: `mix test`
- **Polish Your Code**: `mix format`
- **Manage Your Vault**:
  - Create: `mix ecto.create`
  - Migrate: `mix ecto.migrate`
  - Reset: `mix ecto.reset`

### 🔍 Code Quality and Security

Ensure your code is top-notch with these magical incantations:

- **Security Checks**: `mix sobelow`
- **Elixir Best Practices**: `mix credo`
- **Static Analysis**: `mix dialyzer`

Run these spells regularly to keep your code base clean and secure!

## 🐳 Docker Deployment

Sail the high seas with Gakimint in a Docker container:

1. **Build your ship**:

   ```bash
   docker build -t gakimint:latest .
   ```

2. **Set sail**:

   ```bash
   docker run \
     --name gakimint \
     --network host \
     -e DATABASE_URL="ecto://postgres:postgres@localhost/gakimint_dev" \
     -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
     -e PORT=4000 \
     -e MIX_ENV=prod \
     gakimint:latest
   ```

   Adjust the `DATABASE_URL` and other environment variables as needed for your voyage.

## 🕵️ Phoenix Live Dashboard

Peek behind the curtain at `http://localhost:4000/dashboard`. Don't forget your secret key!

```bash
SECRET_KEY_BASE=$(mix phx.gen.secret)
export SECRET_KEY_BASE=$SECRET_KEY_BASE
MIX_ENV=dev mix phx.server
```

## 🏎️ Turbocharge with Benchmarks

Rev up your engines:

```bash
mix bench
```

## 🤝 Join the Gakimint Community

We're always looking for fellow wizards to join our quest. Check out our [contribution guidelines](CONTRIBUTING.md) and let's make magic together!

## 📜 License

Gakimint is released under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

<p align="center">
  Made with ❤️ by @AbdelStark
</p>

<p align="center">
  <a href="https://github.com/AbdelStark/gakimint/stargazers">⭐ Star us on GitHub!</a>
</p>
