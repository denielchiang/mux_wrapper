defmodule MuxWrapper.EmbeddedSchema.Playback do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @policy_options %{
    public: :public,
    signed: :signed
  }

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:policy, :string)
  end

  @doc false
  @all_fields ~w(id policy)a
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

  @doc """
  Return policy public atom `:public`
  """
  def policy_public, do: @policy_options.public

  @doc """
  Return policy private atom `:signed`
  """
  def policy_private, do: @policy_options.signed
end
