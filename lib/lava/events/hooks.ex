defprotocol Lava.Events.Hooks do
  @fallback_to_any true
  @type event :: Lava.Events.Event
  @spec event_created(map, event) :: [{atom, event}]
  def event_created(attrs, event)
end

defimpl Lava.Events.Hooks, for: Any do
  def event_created(_, event), do: {:ok, event}
end
