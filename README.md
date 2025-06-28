Quex
====

Simple queue implementation, based on Erlang's queue module, which is
an efficient implementation of double ended fifo queues

Differences between Quex and Erlang's queue module are a more Elixir
friendly API (subject as first argument) and implementations of the
`Enumerable`, `Collectable` and `Inspect` protocols.

### Examples
```elixir
iex> q = Quex.new |> Quex.put(1) |> Quex.put(2)
Quex.new([1, 2])
iex> Quex.pop(q)
{1, Quex.new([2])}

iex> Quex.new([1, 2, 3, 4]) |> Enum.take_while(&(&1 < 3))
[1, 2]

iex> for n <- 1..4, into: Quex.new(), do: n * n
Quex.new([1, 4, 9, 16])
```
