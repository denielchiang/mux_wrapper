defmodule MuxWrapper.EmbeddedSchema.OverlaySettings do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:horizontal_align, :string)
    field(:opacity, :string)
    field(:vertical_align, :string)
    field(:vertical_margin, :string)
    field(:width, :string)
  end

  @doc false
  @all_fields ~w(horizontal_align opacity vertical_align vertical_margin width)a
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
