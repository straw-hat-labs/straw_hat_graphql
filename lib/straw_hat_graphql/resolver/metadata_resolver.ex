defmodule StrawHat.GraphQL.MetadataResolver do
  @moduledoc """
  It is been used on `metadata object type` of the graph, it is
  `t:StrawHat.Error.ErrorMetadata.t/0` mapping. It converts the `key` and `value` to
  the proper  values for the GraphQL.
  """

  @doc """
  Converts the `key` from the map using Absinthe Adapter.
  """
  @spec key(%{key: String.t()}, any, %{adapter: Absinthe.Adapter.t()}) :: {:ok, String.t()}
  def key(%{key: key}, _args, %{adapter: adapter} = _resolution) do
    {:ok, adapter.to_external_name(key, :field)}
  end

  @doc """
  Converts the `value` from the map using Absinthe Adapter `IF AND ONLY IF`
  the value is `field_name`.

  `field_name` is `RESERVED ON THE METADATA`. `field_name` is used for map
  `Ecto.Changeset` field name on the changeset.

  The following example shows the field `password_confirmation` failing so
  the value of `field_name` on the metadata will be `field_name: :password_confirmation`.

  ## Examples

      changeset = User.changeset(%UserSchema{}, %{password_confirmation: "123qwe"})
      {:error, changeset} = Repo.insert(changeset)
      changeset.errors #=> [password_confirmation: {"is invalid", []}]

  The reason behind is that Absinthe converts the `arg`s names or
  field names on the `input_object`s using the setup Absinthe Adapter so normally
  the clients want the coorelation between those names and the field name
  to be the same.

  ## Examples

      arg :password_confirmation, non_null(:string)

      # or

      input_object :account_input do
        field :password_confirmation, non_null(:string)
      end

  The actual name that the clients have to use depends of the Absinthe Adapter
  used, this is important because the following example could be different if
  you changed the Absinthe Adapter setup. The default adapter will actually
  expect `passwordConfirmation` from the client and it will convert it into
  `password_confirmation`. So we need to convert it back into `passwordConfirmation`
  for the `key` of that metadata. Check `StrawHat.Error.ChangesetParser` so you
  could understand more how we use `field_name` from `Ecto.Changeset`.
  """
  @spec value(%{key: String.t(), value: String.t()}, any, %{adapter: Absinthe.Adapter.t()}) ::
          {:ok, String.t()}
  def value(%{key: "field_name", value: value}, _args, %{adapter: adapter} = _resolution) do
    {:ok, adapter.to_external_name(value, :field)}
  end

  @spec value(%{value: String.t()}, any, any) :: {:ok, String.t()}
  def value(%{value: value}, _args, _resolution), do: {:ok, value}
end
