defmodule MuxWrapper.EmbeddedSchema.Asset do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias MuxWrapper.EmbeddedSchema.{Playback, Track}
  alias MuxWrapper.Type.UnixEpoch

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:aspect_ratio, :string)
    field(:duration, :integer)
    field(:master_access, :string)
    field(:max_stored_frame_rate, :float)
    field(:max_stored_resolution, :string)
    field(:mp4_support, :string)
    field(:status, :string)
    field(:test, :boolean)
    embeds_many(:tracks, Track, on_replace: :delete)
    embeds_many(:playback_ids, Playback, on_replace: :delete)
    # The time at which the event was created. Time value is represented in ISO 8601 format.
    field(:created_at, UnixEpoch)
  end

  @doc false
  @all_fields ~w(
    id aspect_ratio duration master_access max_stored_frame_rate
    max_stored_resolution mp4_support status test created_at
  )a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:tracks, with: &Track.changeset/2)
    |> cast_embed(:playback_ids, with: &Playback.changeset/2)
  end

  def cast(%__MODULE__{} = struct, params) when is_map(params) and params == %{},
    do: cast(struct, %{})

  def cast(%__MODULE__{} = struct, params) when is_list(params) do
    params
    |> Enum.map(&cast(struct, &1))
  end

  def cast(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:tracks, with: &Track.changeset/2)
    |> cast_embed(:playback_ids, with: &Playback.changeset/2)
    |> apply_changes
  end
end
