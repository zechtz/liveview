defmodule LiveViewAppWeb.CsvController do
  alias LiveViewApp.Customer.Importer
  use LiveViewAppWeb, :controller

  def index(conn, _param) do
    csv_data = Importer.empty_csv_data()

    send_download(conn, {:binary, csv_data}, content_type: "application/csv", filename: "sample-import.csv")
  end
end
