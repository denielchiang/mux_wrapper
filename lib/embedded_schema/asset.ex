defmodule MuxWrapper.EmbeddedSchema.Asset do
  @moduledoc "Asset struct"

  use Ecto.Schema

  import Ecto.Changeset

  alias MuxWrapper.EmbeddedSchema.Playback
  alias MuxWrapper.Type.UnixEpoch

  @primary_key false
  embedded_schema do
    field(:id, :string)
    embeds_many(:playback_ids, Playback, on_replace: :delete)
    field(:mp4_support, :string)
    field(:status, :string)
    field(:master_access, :string)
    # The time at which the event was created. Time value is represented in ISO 8601 format.
    field(:created_at, UnixEpoch)
  end

  @doc false
  @all_fields ~w(id mp4_support status master_access created_at)a
  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:playback_ids, with: &Playback.changeset/2)
    |> apply_changes
  end
end
