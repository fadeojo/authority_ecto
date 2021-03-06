defmodule <%= inspect context.migration.module %> do
  use Ecto.Migration

  def change do
    create table(:<%= context.user.table %>) do
      add(:email, :string, null: false)
      add(:encrypted_password, :string, null: false)
      timestamps()
    end

    create(unique_index(:<%= context.user.table %>, [:email]))<%= if Authority.Tokenization in behaviours do %>

    create table(:<%= context.token.table %>) do
      add(:user_id, references(:<%= context.user.table %>, on_delete: :nothing), null: false)
      add(:token, :string, null: false)
      add(:purpose, :string, null: false)
      add(:expires_at, :utc_datetime, null: false)

      timestamps()
    end

    create(index(:<%= context.token.table %>, [:user_id]))
    create(unique_index(:<%= context.token.table %>, [:token]))
    <% end %><%= if Authority.Locking in behaviours do %>
    create table(:<%= context.lock.table %>) do
      add(:user_id, references(:<%= context.user.table %>, on_delete: :nothing), null: false)
      add(:reason, :string, null: false)
      add(:expires_at, :utc_datetime, null: false)
      timestamps()
    end

    create(index(:<%= context.lock.table %>, [:user_id]))
    create table(:<%= context.attempt.table %>) do
      add(:user_id, references(:<%= context.user.table %>, on_delete: :nothing), null: false)
      timestamps()
    end

    create(index(:<%= context.attempt.table %>, [:user_id]))
    <% end %>
  end
end
