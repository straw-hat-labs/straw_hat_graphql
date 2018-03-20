defmodule StrawHat.GraphQL.JSONScalarTest do
  use ExUnit.Case
  alias StrawHat.GraphQL.Scalar.JSON
  doctest JSON

  test "serialize/1" do
    assert "{\"hello\":\"world\"}" == JSON.serialize(%{hello: "world"})
  end

  test "parse/1" do
    assert {:ok, %{"hello" => "world"}} == JSON.parse(%{value: "{\"hello\":\"world\"}"})
  end
end
