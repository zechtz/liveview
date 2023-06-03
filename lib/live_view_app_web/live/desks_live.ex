defmodule LiveViewAppWeb.DesksLive do
  use LiveViewAppWeb, :live_view

  alias LiveViewApp.Desks
  alias LiveViewApp.Desks.Desk

  def mount(_params, _session, socket) do
    if connected?(socket), do: Desks.subscribe()

    socket =
      assign(socket,
        form: to_form(Desks.change_desk(%Desk{}))
      )

    socket =
      allow_upload(
        socket,
        :photos,
        accept: ~w(.png .jpeg .jpg),
        max_entries: 3,
        max_file_size: 10_000_000
      )

    {:ok, stream(socket, :desks, Desks.list_desks())}
  end

  def render(assigns) do
    ~H"""
    <h1>What's On Your Desk?</h1>
    <div id="desks">
      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input field={@form[:name]} placeholder="Name" />
        <!-- <pre> -->
        <!--   <%= inspect(@uploads.photos, pretty: true) %> -->
        <!-- </pre> -->
        <div class="hint">
          Add up to <%= @uploads.photos.max_entries %> photos
          (max <%= trunc(@uploads.photos.max_file_size / 1_000_000) %> MB each)
        </div>

        <div class="drop" phx-drop-target={@uploads.photos.ref}>
          <.live_file_input upload={@uploads.photos} /> or drag and drop here
        </div>

        <.error :for={err <- upload_errors(@uploads.photos)}>
          <%= Phoenix.Naming.humanize(err) %>
        </.error>

        <div :for={entry <- @uploads.photos.entries} class="entry">
          <.live_img_preview entry={entry} />
          <div class="progress">
            <div class="value">
              <%= entry.progress %>
            </div>
            <div class="bar">
              <span style={"width: #{entry.progress}%"}></span>
            </div>
            <.error :for={err <- upload_errors(@uploads.photos, entry)}>
              <%= Phoenix.Naming.humanize(err) %>
            </.error>
          </div>
          <a phx-click="cancel" phx-value-ref={entry.ref}>
            &times;
          </a>
        </div>

        <.button phx-disable-with="Uploading...">
          Upload
        </.button>
      </.form>

      <div id="photos" phx-update="stream">
        <div :for={{dom_id, desk} <- @streams.desks} id={dom_id}>
          <div
            :for={
              {photo_location, index} <-
                Enum.with_index(desk.photo_locations)
            }
            class="photo"
          >
            <img src={photo_location} />
            <div class="name">
              <%= desk.name %> (<%= index + 1 %>)
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"desk" => params}, socket) do
    changeset =
      %Desk{}
      |> Desks.change_desk(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  def handle_event("save", %{"desk" => params}, socket) do
    # copy temp file to priv/static/uploads/abc-1.png
    # path: /uploads/abc-1.png

    photo_locations =
      consume_uploaded_entries(socket, :photos, fn meta, entry ->
        # IO.inspect(meta, label: "META => ")
        # IO.inspect(entry, label: "ENTRY => ")
        dest = Path.join(["priv", "static", "uploads", "#{entry.uuid}-#{entry.client_name}"])
        File.cp!(meta.path, dest)

        url_path = static_path(socket, "/uploads/#{Path.basename(dest)}")

        {:ok, url_path}
      end)

    params = Map.put(params, "photo_locations", photo_locations)

    case Desks.create_desk(params) do
      {:ok, _desk} ->
        changeset = Desks.change_desk(%Desk{})
        {:noreply, assign_form(socket, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_info({:desk_created, desk}, socket) do
    {:noreply, stream_insert(socket, :desks, desk, at: 0)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
