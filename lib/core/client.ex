defmodule MuxWrapper do
  alias MuxWrapper.EmbeddedSchema.{LiveStream, Playback, Simulcast}

  @doc "Authorisation functions"
  def client,
    do:
      Mux.client(
        Application.get_env(:mux, :access_token_id),
        Application.get_env(:mux, :access_token_secret)
      )

  @doc "Data functions"

  @playback_policy %{
    playback_policy: "public",
    new_asset_settings: %{playback_policy: "public"}
  }

  def create_live_stream(client) do
    {:ok, live_stream, _teslaenv} = Mux.Video.LiveStreams.create(client, @playback_policy)

    live_stream
    |> (&cast(&1, %LiveStream{})).()
  end

  def get_live_stream(client, live_stream_id) do
    {:ok, live_stream, _env} = Mux.Video.LiveStreams.get(client, live_stream_id)

    live_stream
    |> (&cast(&1, %LiveStream{})).()
  end

  def delete_live_stream(client, live_stream_id) do
    {status, _data, _env} = Mux.Video.LiveStreams.delete(client, live_stream_id)

    status
  end

  def enable_live_stream(client, live_stream_id) do
    {status, _, _env} = Mux.Video.LiveStreams.enable(client, live_stream_id)

    status
  end

  def disable_live_stream(client, live_stream_id) do
    {status, _, _env} = Mux.Video.LiveStreams.disable(client, live_stream_id)

    status
  end

  def complete_live_stream(client, live_stream_id) do
    {status, _, _env} = Mux.Video.LiveStreams.signal_complete(client, live_stream_id)

    status
  end

  def list_all_live_stream(client) do
    {:ok, live_streams, _env} = Mux.Video.LiveStreams.list(client)

    live_streams
    |> (&cast(&1, %LiveStream{})).()
  end

  def create_playback_id(client, live_stream_id, :public) do
    # Anyone with the playback URL can stream the asset
    {:ok, playback_id, _env} =
      Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, %{policy: "public"})

    playback_id
    |> cast_playback
  end

  def create_playback_id(client, live_stream_id, :signed) do
    # An additional access token is required to play the asset
    {:ok, playback_id, _env} =
      Mux.Video.LiveStreams.create_playback_id(client, live_stream_id, %{policy: "signed"})

    playback_id
    |> cast_playback
  end

  def delete_playback_id(client, live_stream_id, playback_id) do
    {status, _, _env} =
      Mux.Video.LiveStreams.delete_playback_id(client, live_stream_id, playback_id)

    status
  end

  def create_simulcast_target(client, live_stream_id, params) do
    {:ok, simulcast_target, _env} =
      Mux.Video.LiveStreams.create_simulcast_target(client, live_stream_id, params)

    simulcast_target
    |> (&cast(&1, %Simulcast{})).()
  end

  def get_simulcast_target(client, live_stream_id, simulcast_target_id) do
    {:ok, simulcast_target, _env} =
      Mux.Video.LiveStreams.get_simulcast_target(client, live_stream_id, simulcast_target_id)

    simulcast_target
    |> (&cast(&1, %Simulcast{})).()
  end

  def delete_simulcast_target(client, live_stream_id, simulcast_target_id) do
    {status, _, _env} =
      Mux.Video.LiveStreams.delete_simulcast_target(client, live_stream_id, simulcast_target_id)

    status
  end

  def reset_stream_key(client, live_stream_id) do
    {:ok, live_stream, _env} = Mux.Video.LiveStreams.reset_stream_key(client, live_stream_id)

    live_stream
    |> (&cast(&1, %LiveStream{})).()
  end

  defp cast(map, %LiveStream{} = struct), do: LiveStream.cast(struct, map)
  defp cast(map, %Playback{} = struct), do: Playback.cast(struct, map)
  defp cast(map, %Simulcast{} = struct), do: Simulcast.cast(struct, map)
  defp cast_playback(playback_id), do: playback_id |> (&cast(&1, %Playback{})).()
end
