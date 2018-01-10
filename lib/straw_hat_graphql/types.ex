defmodule StrawHat.GraphQL.Types do
  @moduledoc """
  Common Absinthe Types.

  ## Interfaces
  - node
  - mutation_response

  ## Objects
  - error_metadata
  - error
  """
  use Absinthe.Schema.Notation
  alias StrawHat.GraphQL.Resolver.MetadataResolver

  interface :node do
    field(:id, non_null(:id))
  end

  interface :mutation_response do
    @desc "If the mutation happened without any problem"
    field(:successful, non_null(:boolean))

    @desc "List of errors when the mutation failed (successful: false)"
    field(:errors, list_of(:error))
  end

  object :error_metadata do
    field :key, :string do
      resolve(&MetadataResolver.key/3)
    end

    field :value, :string do
      resolve(&MetadataResolver.value/3)
    end
  end

  object :error do
    field(:id, non_null(:id))

    @desc "Identifier of the error"
    field(:code, non_null(:string))

    @desc "Categorize or group the error"
    field(:type, :string)

    @desc "Information relative to the error"
    field(:metadata, list_of(:error_metadata))
  end
end
