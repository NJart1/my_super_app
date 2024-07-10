defmodule MySuperAppWeb.EditPage do
  use MySuperAppWeb, :surface_live_view
  alias MySuperApp.{User, Repo, Accounts}
  alias Moon.Design.{Form, Button, Tooltip}
  alias Moon.Design.Form.{Input, Field}

  def mount(%{"id" => user_id}, _session, socket) do
    {:ok,
     assign(socket,
       id: user_id,
       user: Repo.get(User, user_id) |> Map.from_struct(),
       form: to_form(User.changeset(%User{}, %{}))
     )}
  end

  def render(assigns) do
    ~F"""
    <Form for={@form} change="validate" submit="edit">
      <p class="text-moon-32 transition-colors text-center">Edit Form</p>
      <br>
      <Field field={:username}>
        <Input placeholder="Change your username" value={"#{@user.username}"} />
      </Field>
      <br>
      <Field field={:email}>
        <Input placeholder="Change your email" value={"#{@user.email}"} />
      </Field>
      <br>
      <Tooltip class="w-full">
        <Tooltip.Trigger>
          <Button right_icon="generic_download" full_width="true" type="submit">Edit</Button>
        </Tooltip.Trigger>
        <Tooltip.Content position="bottom-center" class="text-moon-14">
          This button will edit all your user data
        </Tooltip.Content>
      </Tooltip>
    </Form>
    """
  end

  def handle_event("validate", %{"user" => params}, socket) do
    form =
      %User{}
      |> User.changeset(params)
      |> Map.put(:action, :insert)
      |> to_form

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("edit", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.id, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "user edited")
         |> redirect(to: ~p"/users")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
