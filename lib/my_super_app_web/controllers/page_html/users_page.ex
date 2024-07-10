defmodule MySuperAppWeb.UsersPage do
  use MySuperAppWeb, :surface_live_view

  import MySuperApp.Accounts

  alias MySuperApp.{User, Repo, Accounts}

  alias Moon.Design.Table.Column
  alias Moon.Design.{Form, Button, Drawer, Table, Modal}
  alias Moon.Design.Form.{Input, Field}

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        users: get_users(),
        form: to_form(User.changeset(%User{}, %{})),
        selected_user: %{id: "", username: "", email: ""},
        temp_user: %{id: "", username: "", email: ""},
        selected: nil,
        create_user_drawer: false
      )
    }
  end

  def handle_event("single_row_click", %{"selected" => selected}, socket) do
    Drawer.open("edit_drawer")

    {:noreply,
     assign(socket,
       selected: [selected],
       selected_user: Repo.get(User, selected),
       temp_user: Repo.get(User, selected)
     )}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    form =
      %User{}
      |> User.changeset(params)
      |> Map.put(:action, :insert)
      |> to_form

    {:noreply,
     assign(socket,
       form: form,
       temp_user: %{username: params["username"], email: params["email"]}
     )}
  end

  def handle_event("edit", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.selected_user.id, user_params) do
      {:ok, _user} ->
        {:noreply,
         assign(
           socket
           |> put_flash(:info, "user edited"),
           users: get_users()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("delete", %{"value" => user_params}, socket) do
    Modal.close("default_modal")

    case Accounts.delete_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         assign(
           socket
           |> put_flash(:info, "user deleted"),
           users: get_users()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("on_close", _params, socket) do
    Drawer.close("edit_drawer")
    {:noreply, assign(socket, form: to_form(User.changeset(%User{}, %{})), selected: [])}
  end

  def handle_event("set_open", %{"value" => user_params}, socket) do
    Modal.open("default_modal")
    {:noreply, assign(socket, selected_user: get_user(user_params))}
  end

  def handle_event("set_close", _, socket) do
    Modal.close("default_modal")
    {:noreply, socket}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        Drawer.close("create_user_drawer")
        {:noreply,
         assign(
           socket
           |> put_flash(:info, ("user #{user_params["username"]} \n #{user_params["email"]} created")),
           users: get_users()
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset), create_user_drawer: false)}
    end
  end

  def handle_event("open_create_user_drawer", _, socket) do
    Drawer.open("create_user_drawer")
    {:noreply, assign(socket, create_user_drawer: true)}
  end

  def handle_event("create_user_drawer_close", _, socket) do
    Drawer.close("create_user_drawer")

    {:noreply,
     assign(socket, form: to_form(User.changeset(%User{}, %{})), create_user_drawer: [])}
  end
end
