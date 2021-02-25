defmodule MuxWrapper.EmbeddedSchema.LiveStream do
  @moduledoc "%LiveStream{} struct which defines receiver's live stream for API Client"

  use Ecto.Schema

  import Ecto.Changeset

  alias MuxWrapper.EmbeddedSchema.Playback

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:new_asset_settings, :map)
    embeds_many(:playback_ids, Playback, on_replace: :delete)
    field(:reconnect_window, :integer)
    field(:status, :string)
    field(:stream_key, :string)
    field(:created_at, :date)
  end

  @all_fields ~w(id new_asset_settings reconnect_window status stream_key created_at)a
  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:playback_ids, with: &Playback.changeset/2)
    |> apply_changes
  end
end
