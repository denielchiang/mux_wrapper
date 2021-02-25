defmodule MuxWrapper.EmbeddedSchema.Simulcast do
  @moduledoc """
  %Simulcast{} struct
  Create a simulcast target for the parent live stream. 
  Simulcast target can only be created when the parent live stream is in idle state. 
  Only one simulcast target can be created at a time with this API.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:url, :string)
    field(:stream_key, :string)
    field(:passthrough, :string)
  end

  @all_fields ~w(id url stream_key passthrough)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
  end

  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> apply_changes
  end
end
