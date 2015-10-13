defmodule Queue do
  @moduledoc File.read!("README.md")

  defstruct front: [], rear: []
  @type t :: %Queue{front: list, rear: list}

  @doc "Returns a new empty queue"
  @spec new :: t
  def new do
    %Queue{}
  end

  @doc "Puts the given value at the end the queue"
  @spec put(t, term) :: t
  def put(%Queue{front: [], rear: rear = [_]}, item) do
    %Queue{front: rear, rear: [item]}
  end
  def put(%Queue{rear: rear} = queue, item) do
    %Queue{queue|rear: [item | rear]}
  end

  @doc """
  Puts the given value at the front of the queue

  This means that it will be the first item in the queue to pop, peek, or drop.
  """
  @spec put_front(t, term) :: t
  def put_front(%Queue{front: front = [_], rear: []}, item) do
    %Queue{front: [item], rear: front}
  end
  def put_front(%Queue{front: front} = queue, item) do
    %Queue{queue|front: [item | front]}
  end

  @doc """
  Pop the first value from the front of the queue

  Returns the value as well the rest of the queue or `:empty` if the queue has
  no items.
  """
  @spec pop(t) :: { term, t } | :empty
  def pop(%Queue{front: [], rear: []}) do
    :empty
  end
  def pop(%Queue{front: [], rear: [item]}) do
    { item, %Queue{front: [], rear: []} }
  end
  def pop(%Queue{front: [], rear: [last | rest]}) do
    [item | front] = :lists.reverse(rest, [])
    { item, %Queue{front: front, rear: [last]} }
  end
  def pop(%Queue{front: [item], rear: rear}) do
    { item, r2f(rear) }
  end
  def pop(%Queue{front: [item | rest]} = queue) do
    { item, %Queue{queue|front: rest} }
  end

  @doc """
  Pop the last value from the rear of the queue

  Returns the value as well the rest of the queue or `:empty` if the queue has
  no items.
  """
  @spec pop_rear(t) :: { term, t } | :empty
  def pop_rear(%Queue{front: [], rear: []}) do
    :empty
  end
  def pop_rear(%Queue{front: [item], rear: []}) do
    { item, %Queue{front: [], rear: []} }
  end
  def pop_rear(%Queue{front: [first | rest], rear: []}) do
    [item | rear] = :lists.reverse(rest, [])
    { item, %Queue{front: [first], rear: rear} }
  end
  def pop_rear(%Queue{front: front, rear: [item]}) do
    { item, f2r(front) }
  end
  def pop_rear(%Queue{rear: [item | rest]} = queue) do
    { item, %Queue{queue|rear: rest} }
  end

  @doc """
  Remove the first value from the front of the queue

  Returns the rest of the queue or `:empty` if the queue has no items.
  """
  @spec drop(t) :: t | :empty
  def drop(%Queue{front: [], rear: []}) do
    :empty
  end
  def drop(%Queue{front: [], rear: [_item]}) do
    %Queue{front: [], rear: []}
  end
  def drop(%Queue{front: [], rear: [last | rest]}) do
    [_item | front] = :lists.reverse(rest, [])
    %Queue{front: front, rear: [last]}
  end
  def drop(%Queue{front: [_item], rear: rear}) do
    r2f(rear)
  end
  def drop(%Queue{front: [_item | rest]} = queue) do
    %Queue{queue|front: rest}
  end

  @doc """
  Remove the last value from the rear of the queue

  Returns the rest of the queue or `:empty` if the queue has no items.
  """
  @spec drop_rear(t) :: t | :empty
  def drop_rear(%Queue{front: [], rear: []}) do
    :empty
  end
  def drop_rear(%Queue{front: [_item], rear: []}) do
    %Queue{front: [], rear: []}
  end
  def drop_rear(%Queue{front: [first | rest], rear: []}) do
    [_item | rear] = :lists.reverse(rest, [])
    %Queue{front: [first], rear: rear}
  end
  def drop_rear(%Queue{front: front, rear: [_item]}) do
    f2r(front)
  end
  def drop_rear(%Queue{rear: [_item | rest]} = queue) do
    %Queue{queue|rear: rest}
  end

  @doc """
  Get the first value from the front of the queue without removing it

  Returns the `{:ok, value}` or `:empty` if the queue has no items.
  """
  @spec peek(t) :: { :ok, term } | :empty
  def peek(%Queue{front: [], rear: []}) do
    :empty
  end
  def peek(%Queue{front: [item | _]}) do
    { :ok, item }
  end
  def peek(%Queue{front: [], rear: [item]}) do
    { :ok, item }
  end

  @doc """
  Get the last value from the rear of the queue without removing it

  Returns the `{:ok, value}` or `:empty` if the queue has no items.
  """
  @spec peek_rear(t) :: { :ok, term } | :empty
  def peek_rear(%Queue{front: [], rear: []}) do
    :empty
  end
  def peek_rear(%Queue{rear: [item | _]}) do
    { :ok, item }
  end
  def peek_rear(%Queue{front: [item], rear: []}) do
    { :ok, item }
  end

  @doc """
  Join two queues

  It effectively appends the second queue to the first queue.
  """
  @spec join(t, t) :: t
  def join(%Queue{} = q, %Queue{front: [], rear: []}) do
    q
  end
  def join(%Queue{front: [], rear: []}, %Queue{} = q) do
    q
  end
  def join(%Queue{front: f1, rear: r1}, %Queue{front: f2, rear: r2}) do
    %Queue{front: f1 ++ :lists.reverse(r1, f2), rear: r2}
  end

  @doc """
  Converts a queue to a list

  The front item of the queue will be the first element in the list.
  """
  @spec to_list(t) :: list
  def to_list(%Queue{front: front, rear: rear}) do
    front ++ :lists.reverse(rear, [])
  end

  @doc """
  Converts a list to a queue

  The first element in the list will be the front item of the queue.
  """
  @spec from_list(list) :: t
  def from_list(items) do
    f2r(items)
  end

  @doc "Converts a queue to Erlang's queue data type"
  @spec to_erl(t) :: { list, list }
  def to_erl(%Queue{front: front, rear: rear}) do
    { rear, front }
  end

  @doc "Converts Erlang's queue data type to a queue"
  @spec from_erl({ list, list }) :: t
  def from_erl({ rear, front }) when is_list(rear) and is_list(front) do
    %Queue{front: front, rear: rear}
  end

  @doc "Returns the number of items in the queue"
  @spec size(t) :: non_neg_integer
  def size(%Queue{front: front, rear: rear}) do
    length(front) + length(rear)
  end

  @doc "Returns true if the given value is an item in the queue"
  @spec member?(t, term) :: boolean
  def member?(%Queue{front: front, rear: rear}, item) do
    do_member?(front, item) or do_member?(rear, item)
  end

  defp do_member?([h | _t], x) when h == x, do: true
  defp do_member?([_h | t], x), do: do_member?(t, x)
  defp do_member?([], _x), do: false

  # Move half of elements from rear to front, if there are at least three
  defp r2f([]), do: %Queue{}
  defp r2f([_] = rear), do: %Queue{front: [], rear: rear}
  defp r2f([x, y]), do: %Queue{front: [y], rear: [x]}
  defp r2f(list) do
    { rear, front } = :lists.split(div(length(list), 2) + 1, list)
    %Queue{front: :lists.reverse(front, []), rear: rear}
  end

  # Move half of elements from front to rear, if there are enough
  defp f2r([]), do: %Queue{};
  defp f2r([_] = front), do: %Queue{front: [], rear: front}
  defp f2r([x, y]), do: %Queue{front: [x], rear: [y]}
  defp f2r(list) do
    { front, rear } = :lists.split(div(length(list), 2) + 1, list)
    %Queue{front: front, rear: :lists.reverse(rear, [])}
  end
end

defimpl Enumerable, for: Queue do
  def count(queue),       do: { :ok, Queue.size(queue) }
  def member?(queue, x), do: { :ok, Queue.member?(queue, x) }

  def reduce(%Queue{front: front, rear: rear}, acc, fun) do
    rear_acc = do_reduce(front, acc, fun)
    case do_reduce(:lists.reverse(rear, []), rear_acc, fun) do
      { :cont, acc } ->
        { :done, acc }
      { :halt, acc } ->
        { :halted, acc }
      suspended ->
        suspended
    end
  end

  defp do_reduce([h | t], { :cont, acc }, fun) do
    do_reduce(t, fun.(h, acc), fun)
  end
  defp do_reduce([], { :cont, acc }, _fun) do
    { :cont, acc }
  end
  defp do_reduce(_queue, { :halt, acc }, _fun) do
    { :halt, acc }
  end
  defp do_reduce(queue, { :suspend, acc }, fun) do
    { :suspended, acc, &do_reduce(queue, &1, fun) }
  end
  defp do_reduce(queue, { :suspended, acc, continuation }, fun) do
    { :suspended, acc, fn acc ->
      rear_acc = continuation.(acc)
      do_reduce(queue, rear_acc, fun)
    end }
  end
end

defimpl Collectable, for: Queue do
  def into(original) do
    { original, fn
      queue, { :cont, item } -> Queue.put(queue, item)
      queue, :done -> queue
      _, :halt -> :ok
    end }
  end
end

defimpl Inspect, for: Queue do
  import Inspect.Algebra

  def inspect(%Queue{} = queue, opts) do
    concat ["#Queue<", to_doc(Queue.to_list(queue), opts), ">"]
  end
end
