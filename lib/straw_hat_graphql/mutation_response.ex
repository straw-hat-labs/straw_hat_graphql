defmodule StrawHat.GraphQL.MutationResponse do
  @moduledoc """
  Absinthe Mutation Response utilities. Normally will be use in Absinthe
  resolvers.

  ### Usage

  On the resolver.

  ## Examples

      defmodule App.AccountResolver do

        alias StrawHat.GraphQL.MutationResponse

        def create_account(params, _) do
          case App.Account.create_account(params) do
            {:ok, account} -> MutationResponse.succeeded(account)
            {:error, reason} -> MutationResponse.failed(reason)
          end
        end
      end
  """

  alias StrawHat.Error
  alias StrawHat.Error.ErrorList

  @typedoc """
  - `successful`: When the mutation succeeded or not.
  - `payload`: Data of the mutation payload.
  - `errors`: List of `t:StrawHat.Error.t/0`.
  """
  @type mutation_response :: %{successful: boolean, payload: any, errors: [StrawHat.Error.t()]}

  @doc """
  Returns a failed mutation response map.
  """
  if Code.ensure_loaded?(Ecto) do
    @spec failed(Ecto.Changeset.t()) :: {:ok, mutation_response}
    def failed(%Ecto.Changeset{} = changeset) do
      changeset
      |> Error.new()
      |> failed()
    end
  end

  @spec failed(StrawHat.Error.t()) :: {:ok, mutation_response}
  def failed(%Error{} = error) do
    [error]
    |> ErrorList.new()
    |> failed()
  end

  @spec failed(StrawHat.Error.ErrorList.t()) :: {:ok, mutation_response}
  def failed(%ErrorList{} = error_list) do
    response = %{successful: false, errors: error_list.errors}

    respond(response)
  end

  @spec failed(any) :: no_return
  def failed(_), do: raise(ArgumentError)

  @doc """
  Returns a succeeded mutation response map.
  """
  @spec succeeded(any) :: {:ok, mutation_response}
  def succeeded(payload) do
    response = %{successful: true, payload: payload}

    respond(response)
  end

  def response_with({:ok, response}), do: succeeded(response)
  def response_with({:error, reason}), do: failed(reason)
  def response_with(_), do: raise(ArgumentError)

  defp respond(payload), do: {:ok, payload}
end
