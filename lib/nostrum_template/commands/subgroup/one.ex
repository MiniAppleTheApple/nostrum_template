defmodule NostrumTemplate.Commands.Subgroup.One do
  alias Nostrum.Constants.ApplicationCommandOptionType
  alias NostrumUtils.SubCommand

  alias Nostrum.Api

  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Component.ActionRow

  alias Nostrum.Constants.InteractionCallbackType

  alias Nostrum.Cache.Me

  def spec(name) do
    %{
      name: name,
      description: "A command to check if the bot is alive",
      type: ApplicationCommandOptionType.sub_command(),
    }
  end

  def handle_interaction(interaction, _option) do
    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        content: "One by slash command",
      }
    })
  end

end
