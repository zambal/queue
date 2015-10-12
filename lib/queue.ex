defmodule Queue do
  @moduledoc File.read!("README.md")

  defstruct front: [], rear: []
  @type t :: %Queue{front: list, rear: list}

  @spec new :: t
  def new do
    %Queue{}
  end

  @spec push(t, term) :: t
  def push(%Queue{front: front = [_], rear: []}, item) do
    %Queue{front: [item], rear: front}
  end
  def push(%Queue{front: front} = queue, item) do
    %Queue{queue|front: [item | front]}
  end

  @spec pushr(t, term) :: t
  def pushr(%Queue{front: [], rear: rear = [_]}, item) do
    %Queue{front: rear, rear: [item]}
  end
  def pushr(%Queue{rear: rear} = queue, item) do
    %Queue{queue|rear: [item | rear]}
  end

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

  @spec popr(t) :: { term, t } | :empty
  def popr(%Queue{front: [], rear: []}) do
    :empty
  end
  def popr(%Queue{front: [item], rear: []}) do
    { item, %Queue{front: [], rear: []} }
  end
  def popr(%Queue{front: [first | rest], rear: []}) do
    [item | rear] = :lists.reverse(rest, [])
    { item, %Queue{front: [first], rear: rear} }
  end
  def popr(%Queue{front: front, rear: [item]}) do
    { item, f2r(front) }
  end
  def popr(%Queue{rear: [item | rest]} = queue) do
    { item, %Queue{queue|rear: rest} }
  end

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

  @spec dropr(t) :: t | :empty
  def dropr(%Queue{front: [], rear: []}) do
    :empty
  end
  def dropr(%Queue{front: [_item], rear: []}) do
    %Queue{front: [], rear: []}
  end
  def dropr(%Queue{front: [first | rest], rear: []}) do
    [_item | rear] = :lists.reverse(rest, [])
    %Queue{front: [first], rear: rear}
  end
  def dropr(%Queue{front: front, rear: [_item]}) do
    f2r(front)
  end
  def dropr(%Queue{rear: [_item | rest]} = queue) do
    %Queue{queue|rear: rest}
  end

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

  @spec peekr(t) :: { :ok, term } | :empty
  def peekr(%Queue{front: [], rear: []}) do
    :empty
  end
  def peekr(%Queue{rear: [item | _]}) do
    { :ok, item }
  end
  def peekr(%Queue{front: [item], rear: []}) do
    { :ok, item }
  end

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
  def count(_queue),           do: { :error, __MODULE__ }
  def member?(_queue, _),      do: { :error, __MODULE__ }

  def reduce(queue, acc, fun) do
    case do_reduce(queue, acc, fun) do
      { :cont, acc }    -> { :done, acc }
      { :suspend, acc } -> { :suspended, acc }
      { :halt, acc }    -> { :halted, acc }
    end
  end

  defp do_reduce(_queue, { :halt, acc }, _fun) do
    { :halt, acc }
  end
  defp do_reduce(queue, { :suspend, acc }, fun) do
    { :suspend, acc, &do_reduce(queue, &1, fun) }
  end
  defp do_reduce(%Queue{front: [], rear: []}, { :cont, acc }, _fun) do
    { :cont, acc }
  end
  defp do_reduce(%Queue{front: [item | rest]} = queue, { :cont, acc }, fun) do
    do_reduce(%Queue{queue|front: rest}, fun.(item, acc), fun)
  end
  defp do_reduce(%Queue{front: [], rear: rear}, { :cont, acc }, fun) do
    [item | rest] = :lists.reverse(rear, [])
    do_reduce(%Queue{front: rest, rear: []}, fun.(item, acc), fun)
  end
end

defimpl Collectable, for: Queue do
  def into(original) do
    { original, fn
      queue, { :cont, item } -> Queue.push(queue, item)
      queue, :done -> queue
      _, :halt -> :ok
    end }
  end
end

defimpl Inspect, for: Queue do
  def inspect(%Queue{front: front, rear: rear}, _opts) do
    items = front ++ :lists.reverse(rear, [])
    "#Queue<" <> inspect(items) <> ">"
  end
end
