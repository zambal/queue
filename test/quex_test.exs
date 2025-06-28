defmodule QuexTest do
  use ExUnit.Case
  doctest Quex

  defp put_1_4 do
    Quex.new()
    |> Quex.put(1)
    |> Quex.put(2)
    |> Quex.put(3)
    |> Quex.put(4)
  end

  defp put_front_1_4 do
    Quex.new()
    |> Quex.put_front(1)
    |> Quex.put_front(2)
    |> Quex.put_front(3)
    |> Quex.put_front(4)
  end

  test "new queue" do
    assert %Quex{front: [], rear: []} = Quex.new()
  end

  test "new queue from list" do
    q1 = Enum.reduce(4..1//-1, Quex.new(), fn n, acc -> Quex.put_front(acc, n) end)
    q2 = Quex.new([1, 2, 3, 4])

    assert q1 == q2
  end

  test "put item" do
    q = Quex.new()
    assert %Quex{front: [], rear: [1]} = Quex.put(q, 1)
  end

  test "put_front item" do
    q = Quex.new()
    assert %Quex{front: [1], rear: []} = Quex.put_front(q, 1)
  end

  test "put and pop from queue" do
    q = put_1_4()
    assert {1, %Quex{rear: [4, 3], front: [2]}} = Quex.pop(q)
  end

  test "put and pop_front from queue" do
    q = put_1_4()
    assert {4, %Quex{rear: [3, 2], front: [1]}} = Quex.pop_rear(q)
  end

  test "put_rear and pop_rear from queue" do
    q = put_front_1_4()
    assert {1, %Quex{rear: [2], front: [4, 3]}} = Quex.pop_rear(q)
  end

  test "pop from empty queue" do
    q = Quex.new()
    assert :empty = Quex.pop(q)
  end

  test "peek queue" do
    q = put_1_4()
    assert {:ok, 1} = Quex.peek(q)
  end

  test "peek_rear queue" do
    q = put_1_4()
    assert {:ok, 4} = Quex.peek_rear(q)
  end

  test "peek empty queue" do
    q = Quex.new()
    assert :empty = Quex.peek(q)
  end

  test "drop from queue" do
    q = put_1_4()
    assert %Quex{rear: [4, 3], front: [2]} = Quex.drop(q)
  end

  test "drop_rear from queue" do
    q = put_1_4()
    assert %Quex{rear: [3, 2], front: [1]} = Quex.drop_rear(q)
  end

  test "join" do
    q1 = put_1_4()
    q2 = put_front_1_4()

    assert %Quex{front: [1, 2, 3, 4, 4, 3, 2], rear: [1]} = Quex.join(q1, q2)
  end

  test "to_list" do
    q = put_1_4()

    assert [1, 2, 3, 4] = Quex.to_list(q)
  end

  test "to and from erl" do
    q = put_1_4()
    eq = :queue.new()
    eq = :queue.in(1, eq)
    eq = :queue.in(2, eq)
    eq = :queue.in(3, eq)
    eq = :queue.in(4, eq)

    assert ^eq = Quex.to_erl(q)
    assert ^q = Quex.from_erl(eq)

    q = put_front_1_4()
    eq = :queue.new()
    eq = :queue.in_r(1, eq)
    eq = :queue.in_r(2, eq)
    eq = :queue.in_r(3, eq)
    eq = :queue.in_r(4, eq)

    assert ^eq = Quex.to_erl(q)
    assert ^q = Quex.from_erl(eq)
  end

  test "Enumerable implementation" do
    q = put_1_4()

    assert [1, 2, 3, 4] = Enum.map(q, & &1)
    assert true = Enum.member?(q, 3)
    assert false === Enum.member?(q, 0)
    assert 4 = Enum.count(q)
    assert [1, 2] = Enum.take_while(q, &(&1 < 3))
    assert [3, 4] = Enum.slice(q, 2..3)
  end

  test "Collectable implementation" do
    q1 = Quex.new([1, 2, 3, 4])
    q2 = for n <- 1..4, into: Quex.new(), do: n

    assert q1 == q2
  end
end
