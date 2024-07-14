defmodule NostrumTemplate.Commands do
  alias NostrumUtils.CommandRouter
  alias NostrumUtils.Command

  alias Nostrum.Constants.ApplicationCommandOptionType
  alias Nostrum.Constants.ApplicationCommandType
  alias Nostrum.Constants.InteractionCallbackType

  alias Nostrum.Api

  alias NostrumTemplate.Commands

  @doc """
  Handling and routing for commands and interactions.
  """

  # Add your commands here. The command name will be passed as an argument to
  

  def commands() do
    [
      Commands.Ping.command(),
      %NostrumUtils.CommandRouter{
        spec: %{
          name: "subgroup",
          type: ApplicationCommandType.chat_input(),
          description: "description",
        }, 
        commands: %{
          "one" => %Command{
            spec: %{
              name: "one",
              description: "A command to check if the bot is alive",
              type: ApplicationCommandOptionType.sub_command(),
            },
            handle_interaction: fn interaction, _options ->
              Api.create_interaction_response!(interaction, %{
                type: InteractionCallbackType.channel_message_with_source(),
                data: %{
                  content: "One by slash command",
                }
              })
            end,
          },
        }
      },
    ]
  end

  def commands_map() do
    commands()
    |> Enum.map(fn x -> 
      {x.spec.name, x}
    end)
    |> Enum.into(%{})
  end

  def register_commands do
    commands =
      for command <- commands() do
        if match?(%CommandRouter{}, command) do
          CommandRouter.to_spec(command)
        else
          command.spec
        end
      end

    # Global application commands take a couple of minutes to update in Discord,
    # so we use a test guild when in dev mode.
    if Application.get_env(:nostrum_template, :env) == :dev do
      IO.puts("Dev mode")
      guild_id = Application.get_env(:nostrum_template, :dev_guild_id)
      {:ok, _data} = Nostrum.Api.bulk_overwrite_guild_application_commands(guild_id, commands)
    else
      Nostrum.Api.bulk_overwrite_global_application_commands(commands)
    end
  end

  def handle_interaction(interaction) do
    command = Map.get(commands_map(), interaction.data.name)

    if command == nil do
      :ok
    else
      if match?(%CommandRouter{}, command) do
        {:ok, {
          subcommand, # Module that has the handle_interaction function inside
          option, # not option of the command, option of the ApplicationCommandInteractionData"Option"
        }} = CommandRouter.direct(command, interaction)
        subcommand.handle_interaction.(interaction, option)
      else
        command.handle_interaction.(interaction, interaction.data.options |> List.wrap() |> List.first())
      end
    end
  end
end
