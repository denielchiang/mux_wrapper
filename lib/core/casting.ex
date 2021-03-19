defmodule MuxWrapper.Casting do
  @moduledoc false
  alias MuxWrapper.EmbeddedSchema.{Asset, LiveStream, Playback, Simulcast}

  def cast(list, %LiveStream{} = struct) when is_list(list),
    do: Enum.map(list, &cast(&1, struct))

  def cast(map, %Asset{} = struct), do: Asset.cast(struct, map)
  def cast(map, %LiveStream{} = struct), do: LiveStream.cast(struct, map)
  def cast(map, %Playback{} = struct), do: Playback.cast(struct, map)
  def cast(map, %Simulcast{} = struct), do: Simulcast.cast(struct, map)
  def cast_playback(playback_id), do: playback_id |> (&cast(&1, %Playback{})).()
end
