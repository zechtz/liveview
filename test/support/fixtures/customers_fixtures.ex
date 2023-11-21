defmodule LiveViewApp.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewApp.Customers` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        address: "some address",
        latitude: 120.5,
        longitude: 120.5,
        name: "some name",
        phone: "some phone",
        zip: "some zip"
      })
      |> LiveViewApp.Customers.create_customer()

    customer
  end
end
