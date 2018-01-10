defmodule StrawHat.GraphQL.Scalar.JSON do
  @moduledoc """
  An Absinthe Scalar for JSON.
  """

  use Absinthe.Schema.Notation

  @spec serialize(Poison.Encoder.t()) :: iodata | no_return
  defdelegate serialize(value), to: Poison, as: :encode!

  @spec parse(%{value: String.t()}) :: {:ok, map} | :error
  def parse(%{value: value}) do
    case Poison.decode(value) do
      {:ok, result} -> {:ok, result}
      _ -> :error
    end
  end
end
