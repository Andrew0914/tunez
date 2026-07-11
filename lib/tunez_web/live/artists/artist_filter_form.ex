defmodule TunezWeb.Artists.ArtistFilterForm do
  use TunezWeb, :component

  attr :filter_form, AshPhoenix.FilterForm, required: true

  def artist_filter_form(%{filter_form: %AshPhoenix.FilterForm{}} = assigns) do
    ~H"""
    <.simple_form
      :let={filter_form}
      for={@filter_form}
      phx-change="filter_validate"
      phx-submit="filter_submit"
    >
      <.filter_form_component component={filter_form} />
      <:actions>
        <.button>Submit</.button>
      </:actions>
    </.simple_form>
    """
  end

  attr :component, :map, required: true, doc: "Could be a FilterForm (group) or a Predicate"

  defp filter_form_component(%{component: %{source: %AshPhoenix.FilterForm{}}} = assigns) do
    ~H"""
    <div class="border-gray-50 border-4 px-4 rounded-2xl mt-2">
      <div class="flex flex-row justify-between">
        <div class="flex flex-row gap-2 items-center">Advanced Search</div>
        <div class="flex flex-row gap-2 items-center">
          <.input type="select" field={@component[:operator]} options={["and", "or"]} />
          <.button
            phx-click="add_filter_predicate"
            phx-value-component-id={@component.source.id}
            type="button"
          >
            Add Predicate
          </.button>
        </div>
      </div>
      <.inputs_for :let={component} field={@component[:components]}>
        <.filter_form_component component={component} />
      </.inputs_for>
    </div>
    """
  end

  defp filter_form_component(
         %{component: %{source: %AshPhoenix.FilterForm.Predicate{}}} = assigns
       ) do
    ~H"""
    <div class="flex flex-row gap-2 mt-4">
      <.input
        type="select"
        options={build_fields_options(AshPhoenix.FilterForm.fields(Tunez.Music.Artist))}
        field={@component[:field]}
      />
      <.input
        type="select"
        options={AshPhoenix.FilterForm.predicates(Tunez.Music.Artist)}
        field={@component[:operator]}
      />
      <.input field={@component[:value]} />
      <.button
        phx-click="remove_filter_component"
        phx-value-component-id={@component.source.id}
        type="button"
      >
        Remove
      </.button>
    </div>
    """
  end

  defp build_fields_options(fields) do
    fields
    |> Enum.filter(&(&1 in [:average_rating, :album_count, :follower_count, :previous_names]))
    |> Enum.map(fn field ->
      case field do
        :average_rating -> {"Average Rating", :average_rating}
        :album_count -> {"Album Count", :album_count}
        :follower_count -> {"Follower Count", :follower_count}
        :previous_names -> {"Previous Names", :previous_names}
      end
    end)
  end
end
