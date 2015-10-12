Queue
====

Simple queue implementation, based on Erlang's queue module, which is
an efficient implementation of double ended fifo queues

Differences between Queue and Erlang's queue module are a more Elixir
friendly API (subject as first argument) and implementations of the
`Enumerable`, `Collectable` and `Inspect` protocols.
