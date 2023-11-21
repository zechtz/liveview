defmodule LiveViewApp.CustomersTest do
  use LiveViewApp.DataCase

  alias LiveViewApp.Customers

  describe "customers" do
    alias LiveViewApp.Customers.Customer

    import LiveViewApp.CustomersFixtures

    @invalid_attrs %{address: nil, latitude: nil, longitude: nil, name: nil, phone: nil, zip: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Customers.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{address: "some address", latitude: 120.5, longitude: 120.5, name: "some name", phone: "some phone", zip: "some zip"}

      assert {:ok, %Customer{} = customer} = Customers.create_customer(valid_attrs)
      assert customer.address == "some address"
      assert customer.latitude == 120.5
      assert customer.longitude == 120.5
      assert customer.name == "some name"
      assert customer.phone == "some phone"
      assert customer.zip == "some zip"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{address: "some updated address", latitude: 456.7, longitude: 456.7, name: "some updated name", phone: "some updated phone", zip: "some updated zip"}

      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, update_attrs)
      assert customer.address == "some updated address"
      assert customer.latitude == 456.7
      assert customer.longitude == 456.7
      assert customer.name == "some updated name"
      assert customer.phone == "some updated phone"
      assert customer.zip == "some updated zip"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end
end
