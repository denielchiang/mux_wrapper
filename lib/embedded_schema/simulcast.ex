defmodule MuxWrapper.EmbeddedSchema.Simulcast do
  @moduledoc "Simulcast struct"

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:url, :string)
    field(:stream_key, :string)
    field(:passthrough, :string)
  end

  @doc false
  @all_fields ~w(id url stream_key passthrough)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
  end

  @doc false
  def cast(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> apply_changes
  end
end
