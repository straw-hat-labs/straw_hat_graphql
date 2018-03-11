defmodule StrawHat.GraphQL.Types do
  @moduledoc """
  Common Absinthe Types.

  ## Interfaces

  ### straw_hat_node

  Just a simple interface that will force you to have an ID

  ### mutation_response

  Shape of the mutation response.

  **Important:** read the usage guide because `payload` field is not included
  due to limitations and avoiding macros.

  ## Objects

  ### Errors

  - straw_hat_error_metadata
  - straw_hat_error

  These just map `t:StrawHat.Error.t/0` and `t:StrawHat.Error.ErrorMetadata.t/0`
  """
  use Absinthe.Schema.Notation
  alias StrawHat.GraphQL.Resolver.MetadataResolver

  interface :straw_hat_node do
    field(:id, non_null(:id))
  end

  interface :straw_hat_mutation_response do
    @desc "If the mutation happened without any problem"
    field(:successful, non_null(:boolean))

    @desc "List of errors when the mutation failed (successful: false)"
    field(:errors, list_of(:straw_hat_error))

    # Super Important
    # Due to limitations we can't include it here, we do not know the type
    # of the response
    # field(:payload, TYPE)
  end

  object :straw_hat_error_metadata do
    field :key, :string do
      resolve(&MetadataResolver.key/3)
    end

    field :value, :string do
      resolve(&MetadataResolver.value/3)
    end
  end

  object :straw_hat_error do
    field(:id, non_null(:id))

    @desc "Identifier of the error"
    field(:code, non_null(:string))

    @desc "Categorize or group the error"
    field(:type, :string)

    @desc "Information relative to the error"
    field(:metadata, list_of(:straw_hat_error_metadata))
  end
end
