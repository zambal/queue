defmodule Quex do
  @moduledoc File.read!("README.md")

  defstruct front: [], rear: []
  @type t :: %Quex{front: list, rear: list}

  @doc "Creates a new empty queue"
  @spec new :: t
  def new do
    %Quex{}
  end

  @doc """
  Creates a new queue from a list

  The first element in the list will be the front item of the queue.
  """
  @spec new(list) :: t
  def new(items) do
    f2r(items)
  end

  @doc "Puts the given value at the end the queue"
  @spec put(t, term) :: t
  def put(%Quex{front: [], rear: rear = [_]}, item) do
    %Quex{front: rear, rear: [item]}
  end

  def put(%Quex{rear: rear} = queue, item) do
    %Quex{queue | rear: [item | rear]}
  end

  @doc """
  Puts the given value at the front of the queue

  This means that it will be the first item in the queue to pop, peek, or drop.
  """
  @spec put_front(t, term) :: t
  def put_front(%Quex{front: front = [_], rear: []}, item) do
    %Quex{front: [item], rear: front}
  end

  def put_front(%Quex{front: front} = queue, item) do
    %Quex{queue | front: [item | front]}
  end

  @doc """
  Pop the first value from the front of the queue

  Returns the value as well the rest of the queue or `:empty` if the queue has
  no items.
  """
  @spec pop(t) :: {term, t} | :empty
  def pop(%Quex{front: [], rear: []}) do
    :empty
  end

  def pop(%Quex{front: [], rear: [item]}) do
    {item, %Quex{front: [], rear: []}}
  end

  def pop(%Quex{front: [], rear: [last | rest]}) do
    [item | front] = :lists.reverse(rest, [])
    {item, %Quex{front: front, rear: [last]}}
  end

  def pop(%Quex{front: [item], rear: rear}) do
    {item, r2f(rear)}
  end

  def pop(%Quex{front: [item | rest]} = queue) do
    {item, %Quex{queue | front: rest}}
  end

  @doc """
  Pop the last value from the rear of the queue

  Returns the value as well the rest of the queue or `:empty` if the queue has
  no items.
  """
  @spec pop_rear(t) :: {term, t} | :empty
  def pop_rear(%Quex{front: [], rear: []}) do
    :empty
  end

  def pop_rear(%Quex{front: [item], rear: []}) do
    {item, %Quex{front: [], rear: []}}
  end

  def pop_rear(%Quex{front: [first | rest], rear: []}) do
    [item | rear] = :lists.reverse(rest, [])
    {item, %Quex{front: [first], rear: rear}}
  end

  def pop_rear(%Quex{front: front, rear: [item]}) do
    {item, f2r(front)}
  end

  def pop_rear(%Quex{rear: [item | rest]} = queue) do
    {item, %Quex{queue | rear: rest}}
  end

  @doc """
  Remove the first value from the front of the queue

  Returns the rest of the queue or `:empty` if the queue has no items.
  """
  @spec drop(t) :: t | :empty
  def drop(%Quex{front: [], rear: []}) do
    :empty
  end

  def drop(%Quex{front: [], rear: [_item]}) do
    %Quex{front: [], rear: []}
  end

  def drop(%Quex{front: [], rear: [last | rest]}) do
    [_item | front] = :lists.reverse(rest, [])
    %Quex{front: front, rear: [last]}
  end

  def drop(%Quex{front: [_item], rear: rear}) do
    r2f(rear)
  end

  def drop(%Quex{front: [_item | rest]} = queue) do
    %Quex{queue | front: rest}
  end

  @doc """
  Remove the last value from the rear of the queue

  Returns the rest of the queue or `:empty` if the queue has no items.
  """
  @spec drop_rear(t) :: t | :empty
  def drop_rear(%Quex{front: [], rear: []}) do
    :empty
  end

  def drop_rear(%Quex{front: [_item], rear: []}) do
    %Quex{front: [], rear: []}
  end

  def drop_rear(%Quex{front: [first | rest], rear: []}) do
    [_item | rear] = :lists.reverse(rest, [])
    %Quex{front: [first], rear: rear}
  end

  def drop_rear(%Quex{front: front, rear: [_item]}) do
    f2r(front)
  end

  def drop_rear(%Quex{rear: [_item | rest]} = queue) do
    %Quex{queue | rear: rest}
  end

  @doc """
  Get the first value from the front of the queue without removing it

  Returns the `{:ok, value}` or `:empty` if the queue has no items.
  """
  @spec peek(t) :: {:ok, term} | :empty
  def peek(%Quex{front: [], rear: []}) do
    :empty
  end

  def peek(%Quex{front: [item | _]}) do
    {:ok, item}
  end

  def peek(%Quex{front: [], rear: [item]}) do
    {:ok, item}
  end

  @doc """
  Get the last value from the rear of the queue without removing it

  Returns the `{:ok, value}` or `:empty` if the queue has no items.
  """
  @spec peek_rear(t) :: {:ok, term} | :empty
  def peek_rear(%Quex{front: [], rear: []}) do
    :empty
  end

  def peek_rear(%Quex{rear: [item | _]}) do
    {:ok, item}
  end

  def peek_rear(%Quex{front: [item], rear: []}) do
    {:ok, item}
  end

  @doc """
  Join two queues

  It effectively appends the second queue to the first queue.
  """
  @spec join(t, t) :: t
  def join(%Quex{} = q, %Quex{front: [], rear: []}) do
    q
  end

  def join(%Quex{front: [], rear: []}, %Quex{} = q) do
    q
  end

  def join(%Quex{front: f1, rear: r1}, %Quex{front: f2, rear: r2}) do
    %Quex{front: f1 ++ :lists.reverse(r1, f2), rear: r2}
  end

  @doc """
  Converts a queue to a list

  The front item of the queue will be the first element in the list.
  """
  @spec to_list(t) :: list
  def to_list(%Quex{front: front, rear: rear}) do
    front ++ :lists.reverse(rear, [])
  end

  @doc "Converts a queue to Erlang's queue data type"
  @spec to_erl(t) :: {list, list}
  def to_erl(%Quex{front: front, rear: rear}) do
    {rear, front}
  end

  @doc "Converts Erlang's queue data type to a queue"
  @spec from_erl({list, list}) :: t
  def from_erl({rear, front}) when is_list(rear) and is_list(front) do
    %Quex{front: front, rear: rear}
  end

  @doc "Returns the number of items in the queue"
  @spec size(t) :: non_neg_integer
  def size(%Quex{front: front, rear: rear}) do
    length(front) + length(rear)
  end

  @doc "Returns true if the given value exists in the queue"
  @spec member?(t, term) :: boolean
  def member?(%Quex{front: front, rear: rear}, item) do
    :lists.member(item, rear) or :lists.member(item, front)
  end

  # Move half of elements from rear to front, if there are at least three
  defp r2f([]), do: %Quex{}
  defp r2f([_] = rear), do: %Quex{front: [], rear: rear}
  defp r2f([x, y]), do: %Quex{front: [y], rear: [x]}

  defp r2f(list) do
    {rear, front} = :lists.split(div(length(list), 2) + 1, list)
    %Quex{front: :lists.reverse(front, []), rear: rear}
  end

  # Move half of elements from front to rear, if there are enough
  defp f2r([]), do: %Quex{}
  defp f2r([_] = front), do: %Quex{front: [], rear: front}
  defp f2r([x, y]), do: %Quex{front: [x], rear: [y]}

  defp f2r(list) do
    {front, rear} = :lists.split(div(length(list), 2) + 1, list)
    %Quex{front: front, rear: :lists.reverse(rear, [])}
  end
end

defimpl Enumerable, for: Quex do
  def count(queue), do: {:ok, Quex.size(queue)}
  def member?(queue, x), do: {:ok, Quex.member?(queue, x)}

  def reduce(%Quex{front: front, rear: rear}, acc, fun) do
    rear_acc = do_reduce(front, acc, fun)

    case do_reduce(:lists.reverse(rear, []), rear_acc, fun) do
      {:cont, acc} ->
        {:done, acc}

      {:halt, acc} ->
        {:halted, acc}

      suspended ->
        suspended
    end
  end

  defp do_reduce([h | t], {:cont, acc}, fun) do
    do_reduce(t, fun.(h, acc), fun)
  end

  defp do_reduce([], {:cont, acc}, _fun) do
    {:cont, acc}
  end

  defp do_reduce(_queue, {:halt, acc}, _fun) do
    {:halt, acc}
  end

  defp do_reduce(queue, {:suspend, acc}, fun) do
    {:suspended, acc, &do_reduce(queue, &1, fun)}
  end

  defp do_reduce(queue, {:suspended, acc, continuation}, fun) do
    {:suspended, acc,
     fn acc ->
       rear_acc = continuation.(acc)
       do_reduce(queue, rear_acc, fun)
     end}
  end

  def slice(queue) do
    {:ok, Quex.size(queue), &Quex.to_list/1}
  end
end

defimpl Collectable, for: Quex do
  def into(original) do
    {original,
     fn
       queue, {:cont, item} ->
         Quex.put(queue, item)

       %Quex{front: [front], rear: [rear | rest]} = queue, :done ->
         %{queue | front: [front | :lists.reverse(rest)], rear: [rear]}

       _, :halt ->
         :ok
     end}
  end
end

defimpl Inspect, for: Quex do
  import Inspect.Algebra

  def inspect(%Quex{} = queue, opts) do
    concat(["Quex.new(", to_doc(Quex.to_list(queue), opts), ")"])
  end
end
