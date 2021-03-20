defmodule MuxWrapper.EmbeddedSchema.AssetInfo do
  @moduledoc "Asset info struct"

  use Ecto.Schema

  import Ecto.Changeset

  alias MuxWrapper.EmbeddedSchema.{File, Settings}

  @primary_key false
  embedded_schema do
    embeds_one(:file, File, on_replace: :delete)
    embeds_one(:settings, Settings, on_replace: :delete)
  end

  @doc false
  @all_fields ~w(file settings)a
  def changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @all_fields)
  end

  def cast(%__MODULE__{} = struct, params) when is_list(params) do
    params
    |> Enum.map(&cast(struct, &1))
  end

  def cast(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, [])
    |> cast_embed(:file, with: &File.changeset/2)
    |> cast_embed(:settings, with: &Settings.changeset/2)
    |> apply_changes
  end
end
