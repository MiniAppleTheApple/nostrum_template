import Config

config :nostrum_template, ecto_repos: [NostrumTemplate.Repo]

config :nostrum_template, NostrumTemplate.Repo,
  username: "postgres",
  password: "pwd",
  database: "postgres",
  hostname: "localhost"
