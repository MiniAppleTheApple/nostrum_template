defmodule NostrumTemplate.Commands.Ping do
  alias NostrumUtils.Command
  alias NostrumUtils.Constants.MessageFlag

  alias Nostrum.Api

  alias Nostrum.Constants.InteractionCallbackType

  def spec() do
    %{
      name: "ping",
      description: "A command to check if the bot is alive"
    }
  end

  def handle_interaction(interaction, _option) do
    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        content: "Ping by slash command",
        flags: MessageFlag.emphemeral() |> MessageFlag.add(MessageFlag.suppress_notifications()),
      }
    })
  end

  def command() do
    %Command{
      spec: spec(),
      handle_interaction: &handle_interaction/2,
    }
  end
end
