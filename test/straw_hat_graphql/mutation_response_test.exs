defmodule StrawHat.Test.MutationResponseTest do
  use ExUnit.Case
  import Ecto.Changeset
  alias StrawHat.GraphQL.MutationResponse

  @types %{title: :string}
  @default %{title: "bar"}
  @params %{"title" => "foobar"}

  defp get_changeset(params) do
    type_keys = Map.keys(@types)

    {@default, @types}
    |> cast(params, type_keys)
    |> validate_confirmation(:password)
    |> validate_length(:title, is: 9)
  end

  test "succeeded/1" do
    {:ok, response} = MutationResponse.succeeded(%{hello: "world"})

    assert response.successful == true
    assert response.payload.hello == "world"
  end

  describe "failed/1" do
    test "with an straw hat error" do
      error = StrawHat.Error.new("whatever")
      {:ok, response} = MutationResponse.failed(error)

      assert response.successful == false
      assert List.first(response.errors).code == "whatever"
    end

    test "with an ecto changeset" do
      changeset = get_changeset(@params)
      {:ok, response} = MutationResponse.failed(changeset)

      assert response.successful == false
      assert List.first(response.errors).code == "ecto.changeset.validation.length"
    end

    test "with some random value" do
      assert_raise ArgumentError, fn ->
        {:ok, _response} = MutationResponse.failed([])
      end
    end
  end
end
