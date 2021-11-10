defprotocol Lava.Events.Hooks do
  @fallback_to_any true
  def event_created(attrs, event)
end

defimpl Lava.Events.Hooks, for: Any do
  def event_created(_, _), do: nil
end
