defmodule MuxWrapper.EmbeddedSchema.File do
  @moduledoc "File struct"

  use Ecto.Schema

  import Ecto.Changeset

  alias MuxWrapper.EmbeddedSchema.Track

  @primary_key false
  embedded_schema do
    field(:container_format, :string)
    embeds_many(:tracks, Track, on_replace: :delete)
  end

  @doc false
  @all_fields ~w(container_format)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:tracks, with: &Track.changeset/2)
  end

  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> cast_embed(:tracks, with: &Track.changeset/2)
    |> apply_changes
  end
end
