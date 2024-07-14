defmodule NostrumTemplate.Consumer do
  @moduledoc false
  use Nostrum.Consumer

  require Logger

  alias Nostrum.Constants.InteractionType

  alias NostrumUtils.Listeners

  alias NostrumTemplate.Commands

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _data, _ws_state}) do
    IO.puts("On ready")
    Commands.register_commands()
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do

    application_command = InteractionType.application_command()
    message_component = InteractionType.message_component()
    modal_submit = InteractionType.modal_submit()

    case interaction.type do
      ^application_command ->
        Commands.handle_interaction(interaction)

      ^message_component ->
        custom_id =
          interaction.message.components
          |> List.first()
          |> Map.get(:components)
          |> List.first()
          |> Map.get(:custom_id)
        
        Listeners.trigger(custom_id, interaction)
        
      ^modal_submit ->
        custom_id = interaction.data.custom_id

        Listeners.trigger(custom_id, interaction)
    end
  end

  def handle_event(_data) do
    :ok
  end
end
