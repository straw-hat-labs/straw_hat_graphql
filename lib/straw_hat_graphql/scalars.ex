defmodule StrawHat.GraphQL.Scalars do
  @moduledoc """
  Common Absinthe Scalars.

  ## Scalars

  - :json
  """

  use Absinthe.Schema.Notation
  alias StrawHat.GraphQL.Scalar.JSON

  scalar :json, name: "JSON" do
    parse(&JSON.parse/1)
    serialize(&JSON.serialize/1)
  end
end
