Queue
====

Simple queue implementation, based on Erlang's queue module, which is
an efficient implementation of double ended fifo queues

Differences between Queue and Erlang's queue module are a more Elixir
friendly API (subject as first argument) and implementations of the
`Enumerable`, `Collectable` and `Inspect` protocols.

### Examples
```elixir
iex> q = Queue.new |> Queue.put(1) |> Queue.put(2)
#Queue<[1, 2]>
iex> Queue.pop(q)
{1, #Queue<[2]>}

iex> Queue.from_list([1,2,3,4]) |> Enum.take_while(&(&1 < 3))
[1, 2]

iex> for n <- 1..4, into: Queue.new, do: n * n
#Queue<[1, 4, 9, 16]>
```