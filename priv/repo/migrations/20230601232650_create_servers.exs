defmodule LiveViewApp.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string
      add :status, :string
      add :deploy_count, :integer
      add :size, :float
      add :framework, :string
      add :last_commit_message, :string

      timestamps()
    end
  end
end
